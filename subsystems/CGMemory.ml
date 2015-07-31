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

let t = CGSubsystem.find "memory"

type stat = {
  cache         : int;
  rss           : int;
  mapped_file   : int;
  pgpgin        : int;
  pgpgout       : int;
  swap          : int;
  active_anon   : int;
  inactive_anon : int;
  active_file   : int;
  inactive_file : int;
  unevictable   : int;

  total_cache         : int;
  total_rss           : int;
  total_mapped_file   : int;
  total_pgpgin        : int;
  total_pgpgout       : int;
  total_swap          : int;
  total_active_anon   : int;
  total_inactive_anon : int;
  total_active_file   : int;
  total_inactive_file : int;
  total_unevictable   : int;

  hierarchical_memory_limit : int;
  hierarchical_memsw_limit : int
}

let stat_of_string s =
  let l = Util.Get.(list ~sep:'\n' (pair ~sep:' ' string int) s) in
  try {
    cache         = List.assoc "cache" l;
    rss           = List.assoc "rss" l;
    mapped_file   = List.assoc "mapped_file" l;
    pgpgin        = List.assoc "pgpgin" l;
    pgpgout       = List.assoc "pgpgout" l;
    swap          = List.assoc "swap" l;
    active_anon   = List.assoc "active_anon" l;
    inactive_anon = List.assoc "inactive_anon" l;
    active_file   = List.assoc "active_file" l;
    inactive_file = List.assoc "incative_file" l;
    unevictable   = List.assoc "unevictable" l;

    total_cache         = List.assoc "total_cache" l;
    total_rss           = List.assoc "total_rss" l;
    total_mapped_file   = List.assoc "total_mapped_file" l;
    total_pgpgin        = List.assoc "total_pgpgin" l;
    total_pgpgout       = List.assoc "total_pgpgout" l;
    total_swap          = List.assoc "total_swap" l;
    total_active_anon   = List.assoc "total_active_anon" l;
    total_inactive_anon = List.assoc "total_inactive_anon" l;
    total_active_file   = List.assoc "total_active_file" l;
    total_inactive_file = List.assoc "total_incative_file" l;
    total_unevictable   = List.assoc "total_unevictable" l;

    hierarchical_memory_limit = List.assoc "hierarchical_memory_limit" l;
    hierarchical_memsw_limit = List.assoc "hierarchical_memsw_limit" l;
  }
  with Not_found -> raise (Invalid_argument "stat_of_string")

type oom_control = {
  oom_kill_disable : bool;
  under_oom : bool;
}

let oom_of_string s =
  let l = Util.Get.(list ~sep:'\n' (pair ~sep:' ' string bool) s) in
  {
    oom_kill_disable = List.assoc "oom_kill_disable" l;
    under_oom = List.assoc "under_oom" l;
  }

let string_of_oom o = Util.Set.bool o.oom_kill_disable

let stat = CGParameters.mk_get t "stat" stat_of_string

let usage_in_bytes = CGParameters.mk_get t "usage_in_bytes" Util.Get.int
let memsw_usage_in_bytes = CGParameters.mk_get t "memsw.usage_in_bytes" Util.Get.int

let max_usage_in_bytes = CGParameters.mk_get t "max_usage_in_bytes" Util.Get.int
let memsw_max_usage_in_bytes = CGParameters.mk_get t "memsw.usage_in_bytes" Util.Get.int

let limit_in_bytes = CGParameters.mk_set t "limit_in_bytes" Util.Get.int Util.Set.int
let memsw_limit_in_bytes = CGParameters.mk_set t "memsw.limit_in_bytes" Util.Get.int Util.Set.int

let failcnt = CGParameters.mk_get t "failcnt" Util.Get.int
let memsw_failcnt = CGParameters.mk_get t "memsw.fail_cnt" Util.Get.int

let soft_limit_in_bytes = CGParameters.mk_set t "soft_limit_in_bytes" Util.Get.int Util.Set.int

let force_empty = CGParameters.mk_reset t "force_empty" Util.Get.int "0"

let swappiness = CGParameters.mk_set t "swappiness" Util.Get.int Util.Set.int

let move_charge_at_immigrate = CGParameters.mk_set t "move_charge_at_immigrate" Util.Get.bool Util.Set.bool

let use_hierarchy = CGParameters.mk_set t "use_hierarchy" Util.Get.bool Util.Set.bool

let oom_control = CGParameters.mk_set t "oom_control" oom_of_string string_of_oom

