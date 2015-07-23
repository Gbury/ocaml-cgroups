
type t = {
  root : cgroup;
  mount : string;
  subsystems : string list;
}

and cgroup = {
  path : string;
  hierarchy : t;
  mutable children : cgroup list;
}

(* Generating hierarchies *)
let rec populate stack =
  match Stack.pop stack with
  | exception Stack.Empty -> ()
  | g ->
    let l = Util.fold_dir (fun s acc ->
        let f = Filename.concat g.path s in
        let stats = Unix.stat f in
        if stats.Unix.st_kind = Unix.S_DIR then begin
          let cg = {
            path = f;
            hierarchy = g.hierarchy;
            children = [];
          } in
          Stack.push cg stack;
          cg :: acc
        end else
          acc) g.path [] in
    g.children <- l;
    populate stack

let make path subs =
  let rec t = {
    root = root;
    mount = path;
    subsystems = subs;
  }
  and root = {
    path = path;
    hierarchy = t;
    children = []
  }
  in
  let s = Stack.create () in
  Stack.push root s;
  populate s;
  t

let find subsys =
  let rec aux ch acc =
    match input_line ch with
    | exception End_of_file -> acc
    | s ->
      begin match Util.split ~seps:[' '; '\t'] s with
        | ["cgroup"; path; "cgroup"; opts; _; _] ->
          let l_opts = Util.split ~seps:[','] opts in
          begin match List.filter (fun x -> List.mem x l_opts) subsys with
            | [] -> aux ch acc
            | l -> aux ch (make path l :: acc)
          end
        | _ -> aux ch acc
      end
  in
  let ch = open_in "/proc/mounts" in
  let res = aux ch [] in
  close_in ch;
  res

