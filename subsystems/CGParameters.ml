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

exception Subsystem_not_available of CGSubsystem.t
exception Subsystem_not_attached of CGSubsystem.t * Hierarchy.cgroup

type ('ty, 'attr) t = {
  name : string;
  subsystem : CGSubsystem.t;

  reset_value : string;
  from_string : string -> 'ty;
  to_string : 'ty -> string;
}

let mk subsystem name from_string
    ?(reset_value = "") ?(to_string = (fun _ -> "")) () =
  { name; subsystem; reset_value; from_string; to_string; }

(* Attribute creation *)
let mk_get sub name from_string = mk sub name from_string ()

let mk_set sub name from_string to_string = mk sub name from_string ~to_string ()

let mk_reset sub name from_string reset_value = mk sub name from_string ~reset_value ()

(* Low-level Accessors *)
let file t = Format.asprintf "%s.%s" t.subsystem.CGSubsystem.name t.name

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
let check t g =
  if not t.subsystem.CGSubsystem.available then
    raise (Subsystem_not_available t.subsystem)
  else if not (List.mem t.subsystem (Hierarchy.subsys g)) then
    raise (Subsystem_not_attached (t.subsystem, g))

let get t g =
  check t g; t.from_string (raw_get t (Hierarchy.path g))

let set t g value =
  check t g; raw_set t (Hierarchy.path g) (t.to_string value)

let reset t g =
  check t g; raw_set t (Hierarchy.path g) t.reset_value

