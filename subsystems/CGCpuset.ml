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

let t = CGSubsystem.find "cpuset"

let cpus = CGParameters.mk_set t "cpus" Util.Get.range Util.Set.range
let mems = CGParameters.mk_set t "mems" Util.Get.range Util.Set.range

let memory_migrate = CGParameters.mk_set t "memory_migrate" Util.Get.bool Util.Set.bool

let cpu_exclusive = CGParameters.mk_set t "cpu_exclusive" Util.Get.bool Util.Set.bool
let mem_exclusive = CGParameters.mk_set t "memory_exclusive" Util.Get.bool Util.Set.bool

let mem_hardwall = CGParameters.mk_set t "mem_hardwall" Util.Get.bool Util.Set.bool

let memory_pressure = CGParameters.mk_get t "memory_pressure" Util.Get.int

let memory_pressure_enabled = CGParameters.mk_set t "memory_pressure_enabled" Util.Get.bool Util.Set.bool

let memory_spread_page = CGParameters.mk_set t "memory_spread_page" Util.Get.bool Util.Set.bool
let memory_spread_slab = CGParameters.mk_set t "memory_spread_slab" Util.Get.bool Util.Set.bool

let sched_load_balance = CGParameters.mk_set t "sched_load_balance" Util.Get.bool Util.Set.bool

let sched_relax_domain_level = CGParameters.mk_set t "sched_relax_domain_level" Util.Get.int Util.Set.int

