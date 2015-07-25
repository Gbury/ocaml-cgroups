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

(** Defines cgroups and hierachies. *)

(** {2 Type definitions} *)

type t
(** The type of a cgroup hierarchy. A hierarchy is defined by its
    mounting point, and the subsystems attached to it. *)

type cgroup
(** The type of cgroups. Each hierarchy is composed of a tree where the nodes
    and leaves are cgroups. *)


(** {2 Hierarchy Access} *)

val root : t -> cgroup
(** Returns the cgroup at the root of a given hierarchy *)

val path : cgroup -> string
(** Returns the filesystem path of a cgroup. *)

val subsys : cgroup -> string list
(** Returns the list of subsystems attached to the hierarchy of a cgroup. *)

(** {2 Manipulating hierarchies} *)

val find_all : string list -> t list
(** Given a list of subsystems, returns the list of hierarchies that have
    at least one of the subsystems attached. Information on the returned
    hierarchies may be incomplete, i.e if a hierarchy [h] has subsystems ["A"]
    and ["B"] attached, then [find_all \["A"\]] will return a hierarchy [h]
    with only ["A"] attached. [find_all \["A"; "B"\]], however, will
    return the expected hierarchy. *)

val children : cgroup -> cgroup list
(** Returns the list of children of a cgroup. *)

val mk_sub : cgroup -> string -> Unix.file_perm -> cgroup
(** Create a new childrenfor a cgroup. Since interaction with cgroups is
    done via the filesystem, this means creating a directory at the
    appropriate place in the filesystem, hence the permission argument.
    Note that this function may currently very well raise erros from the
    Unix module if, for instance, the user does not have permission
    to create directories in the cgroup. *)

