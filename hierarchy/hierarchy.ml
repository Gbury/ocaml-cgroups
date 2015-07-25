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
  mount : string;
  subsystems : string list;
}

and cgroup = {
  name : string;
  path : string;
  hierarchy : t;
}

let mk_t mount subsystems =
  { mount; subsystems }

let mk_cgroup name path hierarchy =
  { name; path; hierarchy; }

(* Access function *)
let root h = mk_cgroup "" h.mount h

let path g = g.path
let subsys g = g.hierarchy.subsystems

(* Generating hierarchies *)
let find_all subsys =
  let rec aux ch acc =
    match input_line ch with
    | exception End_of_file -> acc
    | s ->
      begin match Util.split ~seps:[' '; '\t'] s with
        | ["cgroup"; path; "cgroup"; opts; _; _] ->
          let l_opts = Util.split ~seps:[','] opts in
          begin match List.filter (fun x -> List.mem x l_opts) subsys with
            | [] -> aux ch acc
            | l -> aux ch (mk_t path l :: acc)
          end
        | _ -> aux ch acc
      end
  in
  let ch = open_in "/proc/mounts" in
  let res = aux ch [] in
  close_in ch;
  res

let children g =
  Util.fold_dir (fun s acc ->
      let f = Filename.concat g.path s in
      let stats = Unix.stat f in
      if stats.Unix.st_kind = Unix.S_DIR then begin
        let cg = mk_cgroup s f g.hierarchy in
        cg :: acc
      end else
        acc) g.path []

(* Modifying hierarchies *)
let mk_sub parent name perm =
  let path = Filename.concat parent.path name in
  Unix.mkdir path perm;
  mk_cgroup name path parent.hierarchy

