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

(* Directory iteration *)
let fold_dir f d acc =
  let rec aux f dir acc =
    match Unix.readdir dir with
    | exception End_of_file -> Unix.closedir dir; acc
    | s when s = Filename.current_dir_name
             || s = Filename.parent_dir_name ->
      aux f dir acc
    | s -> aux f dir (f s acc)
  in
  aux f (Unix.opendir d) acc

(* String manipulation *)
let rec next_occ s i l =
  if i >= String.length s || List.mem s.[i] l then i
  else next_occ s (i + 1) l

let split ~seps s =
  let rec aux l s acc i =
    if i >= String.length s then acc
    else begin
      let j = next_occ s i l in
      if j <= i then
        aux l s acc (i + 1)
      else
        aux l s (String.sub s i (j - i) :: acc) (j + 1)
    end
  in
  List.rev (aux seps s [] 0)

(* Option operations *)
module Opt = struct

  let iter f = function None -> () | Some a -> f a

  let map f = function None -> None | Some a -> Some (f a)

  let bind f = function None -> None | Some a -> f a

end

(* Conversion to/from strings *)
module type S = sig
  type 'a t

  val bool : bool t
  val string : string t
  val int : ?min:int -> ?max:int -> int t

  val device : (int * int) t
  val range : int list t

  val list : sep:char -> 'a t -> 'a list t
  val pair : sep:char -> 'a t -> 'b t -> ('a * 'b) t
  val triple : sep:char -> 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t
end

module Get = struct
  type 'a t = string -> 'a

  let bool s = match s with
    | "0" -> false | "1" -> true
    | _ -> raise (Invalid_argument "bool")

  let string x = x

  let int ?(min=min_int) ?(max=max_int) = fun s ->
    let i = int_of_string s in
    if i >= min && i <= max then i
    else raise (Invalid_argument "range")

  let pair ~sep p1 p2 = fun s ->
    match split ~seps:[sep] s with
    | [a; b] -> (p1 a, p2 b)
    | _ -> raise (Invalid_argument "pair")

  let triple ~sep p1 p2 p3 = fun s ->
    match split ~seps:[sep] s with
    | [a; b; c] -> (p1 a, p2 b, p3 c)
    | _ -> raise (Invalid_argument "triple")

  let list ~sep f = fun s ->
    List.map f (split ~seps:[sep] s)

  let device = pair ~sep:':' int int

  let make_list start stop =
    let rec aux start acc i =
      if i < start then acc
      else aux start (i :: acc) (i -1)
    in
    assert (start <= stop);
    aux start [] stop

  let range_aux s =
    match list ~sep:'-' int s with
    | [i] -> [i]
    | [i; j] -> make_list i j
    | _ -> raise (Invalid_argument "short")

  let range s = List.flatten (list ~sep:',' range_aux s)

end

module Set = struct
  type 'a t = 'a -> string

  let bool b = if b then "1" else "0"

  let string x = x

  let int ?(min=min_int) ?(max=max_int) = function i ->
    if i >= min && i <= max then string_of_int i
    else raise (Invalid_argument "range")

  let pair ~sep p1 p2 = fun (a, b) ->
    Format.asprintf "%s%s%s" (p1 a) (String.make 1 sep) (p2 b)

  let triple ~sep p1 p2 p3 = fun (a, b, c) ->
    Format.asprintf "%s%s%s%s%s"
      (p1 a) (String.make 1 sep) (p2 b) (String.make 1 sep) (p3 c)

  let list ~sep f = function l ->
    String.concat (String.make 1 sep) (List.map f l)

  let device = pair ~sep:':' int int

  let compactify l =
    let rec aux acc (min,max) = function
      | [] -> (min,max) :: acc
      | x :: r ->
        if x = max + 1 then aux acc (min,x) r
        else aux ((min,max) :: acc) (x,x) r
    in
    match List.sort (fun (x:int) y -> compare x y) l with
    | [] -> []
    | x :: r -> aux [] (x,x) r

  let range_aux (i,j) =
    if i = j then string_of_int i
    else Format.asprintf "%d-%d" i j

  let range l =
    let l' = compactify l in
    String.concat "," (List.map range_aux l')

end

