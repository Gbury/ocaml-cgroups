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
  subsystems : CGSubsystem.t list;
}

and cgroup = {
  name : string;
  path : string;
  hierarchy : t;
}

let mk_t mount subsystems =
  assert (List.for_all (fun s -> s.CGSubsystem.enabled) subsystems);
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
          begin match List.filter (fun x -> List.mem x.CGSubsystem.name l_opts) subsys with
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

let rec follow c = function
  | [] -> Some c
  | child :: r ->
    begin match List.filter (fun s -> s.name = child) (children c) with
      | [ c' ] -> follow c' r
      | _ -> None
    end

let find_aux sub path =
  match find_all [sub] with
  | [h] -> follow (root h) (Util.split ~seps:['/'] path)
  | _ -> None

let find s =
  match Util.split ~seps:[':'] s with
  | [ sub; path ] -> find_aux (CGSubsystem.find sub) path
  | _ -> None

let find_exn s =
  match find s with
  | Some c -> c
  | None -> raise (Invalid_argument "find_exn")

(* Modifying hierarchies *)
let mk_sub parent name perm =
  let path = Filename.concat parent.path name in
  Unix.mkdir path perm;
  mk_cgroup name path parent.hierarchy


(* Cgroups and processes *)
let processes g =
  let rec aux ch acc = match input_line ch with
    | exception End_of_file -> close_in ch; acc
    | s -> aux ch (int_of_string s :: acc)
  in
  aux (open_in (Filename.concat g.path "tasks")) []

let add_process g pid =
  let ch = open_out (Filename.concat g.path "tasks") in
  output_string ch (string_of_int pid);
  close_out ch

let process_info pid =
  let rec aux ch acc =
    match input_line ch with
    | exception End_of_file -> close_in ch; acc
    | s ->
      begin match Util.split ~seps:[':'] s with
        | [id; _; path] -> aux ch ((int_of_string id, path) :: acc)
        | _ -> aux ch acc
      end
  in
  let l = aux (open_in (Format.asprintf "/proc/%d/cgroup" pid)) [] in
  let subs = CGSubsystem.find_all () in
  List.fold_left (fun acc (id, path) ->
      match List.find (fun s -> s.CGSubsystem.id = id) subs with
      | exception Not_found -> acc
      | sub ->
        begin match find_aux sub path with
          | Some g -> g :: acc | None -> acc
        end
    ) [] l

