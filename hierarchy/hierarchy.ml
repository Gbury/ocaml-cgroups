
type subsystem = string

type t = {
  mount : string;
  subs : subsystem list;
  root : cgroup;
}

and cgroup = {
  path : string;
  mutable children : cgroup list;
  hierarchy : t;
}

(* Generating hierarchies *)
let make path subs =
  let rec t = {
    mount = path;
    subs = subs;
    root = root;
  }
  and root = {
    path = path;
    hierarchy = t;
    children = []
  }
  in
  t

let list subsys =
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
  let ch = open_in "/proc/mounts/" in
  let res = aux ch [] in
  close_in ch;
  res

