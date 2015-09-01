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

val t : CGSubsystem.t

type stat = {
  cache : int;
  rss : int;
  mapped_file : int;
  pgpgin : int;
  pgpgout : int;
  swap : int;
  active_anon : int;
  inactive_anon : int;
  active_file : int;
  inactive_file : int;
  unevictable : int;
  total_cache : int;
  total_rss : int;
  total_mapped_file : int;
  total_pgpgin : int;
  total_pgpgout : int;
  total_swap : int;
  total_active_anon : int;
  total_inactive_anon : int;
  total_active_file : int;
  total_inactive_file : int;
  total_unevictable : int;
  hierarchical_memory_limit : int;
  hierarchical_memsw_limit : int;
}

type oom_control = { oom_kill_disable : bool; under_oom : bool; }

val stat : (stat, [ `Read ], [ `Dummy ]) CGParameters.t
val usage_in_bytes : (int, [ `Read ], [ `Dummy ]) CGParameters.t
val memsw_usage_in_bytes : (int, [ `Read ], [ `Dummy ]) CGParameters.t
val max_usage_in_bytes : (int, [ `Read ], [ `Dummy ]) CGParameters.t
val memsw_max_usage_in_bytes : (int, [ `Read ], [ `Dummy ]) CGParameters.t
val limit_in_bytes : (int, [ `Read | `Write ], [ `Dummy ]) CGParameters.t
val memsw_limit_in_bytes : (int, [ `Read | `Write ], [ `Dummy ]) CGParameters.t
val failcnt : (int, [ `Read ], [ `Dummy ]) CGParameters.t
val memsw_failcnt : (int, [ `Read ], [ `Dummy ]) CGParameters.t
val soft_limit_in_bytes : (int, [ `Read | `Write ], [ `Dummy ]) CGParameters.t
val force_empty : (int, [ `Read ], [ `Reset ]) CGParameters.t
val swappiness : (int, [ `Read | `Write ], [ `Dummy ]) CGParameters.t
val move_charge_at_immigrate : (bool, [ `Read | `Write ], [ `Dummy ]) CGParameters.t
val use_hierarchy : (bool, [ `Read | `Write ], [ `Dummy ]) CGParameters.t
val oom_control : (oom_control, [ `Read | `Write ], [ `Dummy ]) CGParameters.t

