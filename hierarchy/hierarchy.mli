
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

val find : string list -> t list

