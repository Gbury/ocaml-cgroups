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

type t = {
  name : string;
  enabled : bool;
  available : bool;
}

let mk_some name enabled =
  { name; enabled; available = true; }

let mk_none name =
  { name; enabled = false; available = false; }

(* Access function *)
let find_all () =
  let rec aux ch acc =
    match input_line ch with
    | exception End_of_file -> acc
    | s ->
      begin match Util.split ~seps:[' '; '\t'] s with
        | [sub_name; _; _; enabled;] ->
          aux ch (mk_some sub_name (enabled = "1") :: acc)
        | _ -> aux ch acc
      end
  in
  let ch = open_in "/proc/cgroups" in
  let res = aux ch [] in
  close_in ch;
  res

let find name =
  try List.find (fun t -> t.name = name) (find_all ())
  with Not_found -> mk_none name

