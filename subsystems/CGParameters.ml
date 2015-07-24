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

type ('ty, 'kind) attr = {
  name : string;
  subsystem : string;

  reset_value : string;
  from_string : string -> 'ty;
  to_string : 'ty -> string;
}

let mk subsystem name from_string
    ?(reset_value = "") ?(to_string = (fun _ -> "")) () =
  { name; subsystem; reset_value; from_string; to_string; }

(* Attribute creation *)
let get_attr sub name from_string = mk sub name from_string ()
let set_attr sub name from_string to_string = mk sub name from_string ~to_string ()

let reset_attr sub name from_string reset_value = mk sub name from_string ~reset_value ()

(* Low-level Accessors *)
let file attr = Format.asprintf "%s.%s" attr.subsystem attr.name

let raw_get attr path =
  let f = Filename.concat path (file attr) in
  let rec aux ch acc =
    match input_line ch with
    | exception End_of_file -> acc
    | s -> aux ch (s :: acc)
  in
  let ch = open_in f in
  let res = String.concat "\n" (List.rev (aux ch [])) in
  close_in ch;
  res

let raw_set attr path value =
  let f = Filename.concat path (file attr) in
  let ch = open_out f in
  output_string ch value;
  close_out ch

(* High-level accessors *)
let check attr g = List.mem attr.subsystem (Hierarchy.subsys g)

let get attr g =
  attr.from_string (raw_get attr (Hierarchy.path g))

let set attr g value =
  raw_set attr (Hierarchy.path g) (attr.to_string value)

let reset attr g =
  raw_set attr (Hierarchy.path g) attr.reset_value

