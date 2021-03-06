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

(** Parameters for the 'cpuacct' subsystem *)

(** {2 Type definitions} *)

type stat = {
  user : int;
  system : int;
}
(** The types of stats for cpu activity. *)

(** {2 Parameters} *)

val t : CGSubsystem.t
(** The name of the subsystem *)

val stat : (stat, [ `Read ], [ `Dummy ]) CGParameters.t
(** Parameter: returns the user & system time (in nanoseconds) used by
    all tasks in a cgroup and its children (recursively). *)

val usage : (int, [ `Read ], [ `Reset ]) CGParameters.t
(** Parameter: returns the cpu time (in nanoseconds) used by
    all tasks in a cgroup and its children (recusively). *)

val usage_percpu : (int list, [ `Read ], [ `Dummy ]) CGParameters.t
(** Parameter: same as [usage] but discriminates between cpus. *)

