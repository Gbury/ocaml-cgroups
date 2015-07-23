
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


