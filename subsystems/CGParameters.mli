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

(** Defines the parameters of subsystems *)

(** {2 Types and exceptions} *)

type ('ty, 'attr) t
(** The type of parameters for subsystems. The ['ty] argument represents
    the high level type of the value stored in the parameter. The ['attr]
    type parameter represents the level of access of the parameter, i.e
    should it be a read-only parameter, can it be set to a specific value ? *)

exception Expected_root of string * Hierarchy.cgroup
(** Raised by parametersthat are only settable for thr rootcgroupof a hierarchy,
    such as release_agent. *)

exception Subsystem_not_available of CGSubsystem.t
(** Raised when trying to get/set/reset a parameter of a subsystem that is not
    available on the machine. *)

exception Subsystem_not_attached of CGSubsystem.t * Hierarchy.cgroup
(** Raised when trying to get/set/reset a parameter of a subsystem that is not
    mounted on the hierarchyof the selected cgroup. *)

(** {2 Using parameters} *)

val get : ('a, [> `Get ]) t -> Hierarchy.cgroup -> 'a
(** Returns the value of the parameter for the given cgroup. *)

val set : ('a, [> `Set ]) t -> Hierarchy.cgroup -> 'a -> unit
(** Sets the parameter to the given value for the cgroup. *)

val reset : ('a, [> `Reset ]) t -> Hierarchy.cgroup -> unit
(** Reset the parameter for the given cgroup *)

(** {2 Standard cgroup parameters} *)

val release_agent : (string, [ `Get | `Set ]) t
val notify_on_release : (bool, [ `Get | `Set ]) t
(** These parameters do not belong to any subsystem but are present in every cgroup. *)

(** {2 Creating parameters}
    As parameters are stored in system files, they are stored as strings.
    Thus conversion functions are used to translate the strings to appropriate
    representations of the values actually stored. *)

val mk_get : CGSubsystem.t -> string -> (string -> 'a) -> ('a, [ `Get ]) t
(** [mk_get subsystem name from_string] returns a gettable parameter. *)

val mk_set : CGSubsystem.t -> string -> (string -> 'a) -> ('a -> string) -> ('a, [ `Get | `Set ]) t
(** [mk_set subsystem name from_string to_string] returns a settable parameter.
    Note that a settable parameter is also a gettable parameter. *)

val mk_reset : CGSubsystem.t -> string -> (string -> 'a) -> string -> ('a, [ `Get | `Reset ]) t
(** [mk_reset subsystem name from_string reset_value] returns a gettable parameter
    whose value can be reset by writing [reset_value] in the corresponding file. *)

