(*
Copyright (c) 2015, Guillaume Bury
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*)

(* Type definition *)

type ('ty, -'attr) t = {
  read : string -> 'ty;
  write : 'ty -> string;
} constraint 'attr = [< `Read | `Write ]

(* Exceptions *)

let _invalid_arg s = raise (Invalid_argument s)

(* Using converters *)
let read t = t.read
let write t = t.write

(* Creating converters *)

let _false _ = assert false
let mk ?(read=_false) ?(write=_false) () = { read; write; }

let ro read = mk ~read ()
let wo write = mk ~write ()
let rw read write = mk ~read ~write ()

(* Bool converter *)
let bool = mk
    ~read:(function
    | "0" -> false | "1" -> true
    | s -> _invalid_arg "bool")
    ~write:(fun b -> if b then "1" else "0")
    ()

(* String converter (i.e identity) *)
let string = mk ~read:(fun s -> s) ~write:(fun s -> s) ()

(* Int converter *)
let bounded_int ?(min=min_int) ?(max=max_int) () = mk
    ~read:(fun s ->
        try
          let i = int_of_string s in
          if i >= min && i <= max then i
          else _invalid_arg "int"
        with Invalid_argument "string_of_int" ->
          _invalid_arg"int")
    ~write:(fun i ->
        if i >= min && i <= max then
          string_of_int i
        else
          _invalid_arg "int")
    ()

let int = bounded_int ()

(* Pair converter *)
let pair ~sep t1 t2 = mk
    ~read:(fun s ->
        match Util.split ~seps:[sep] s with
        | [a; b] -> (read t1 a, read t2 b)
        | _ -> _invalid_arg "pair")
    ~write:(fun (a, b) ->
        Format.asprintf "%s%c%s" (write t1 a) sep (write t2 b))
    ()

(* Triple converter *)
let triple ~sep t1 t2 t3 = mk
    ~read:(fun s ->
        match Util.split ~seps:[sep] s with
        | [a; b; c] -> (read t1 a, read t2 b, read t3 c)
        | _ -> _invalid_arg "pair")
    ~write:(fun (a, b, c) ->
        Format.asprintf "%s%c%s%c%s" (write t1 a) sep (write t2 b) sep (write t3 c))
    ()

(* List converter *)
let list ~sep t = mk
    ~read:(fun s ->
        List.map (read t) (Util.split ~seps:[sep] s))
    ~write:(fun l ->
        String.concat (String.make 1 sep) (List.map (write t) l))
    ()

(* Specific converter for linux device identifier *)
let device = pair ~sep:':' int int

(* Converter for range of discrete integer values,
    such as "1-4,8" *)
let single_range = mk
    ~read:(fun s ->
        match read (list ~sep:'-' int) s with
        | [i] -> (i,i)
        | [i; j] -> (i,j)
        | _ -> _invalid_arg "single_range")
    ~write:(fun ((i,j) : (int * int)) ->
        if i = j then Format.asprintf "%d" i
        else Format.asprintf "%d-%d" i j)
    ()

let range = mk
    ~read:(fun s ->
        List.flatten (List.map Util.range (read (list ~sep:',' single_range) s)))
    ~write:(fun l ->
        let l' = Util.compactify l in
        write (list ',' single_range) l')
    ()

