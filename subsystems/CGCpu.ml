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

let t = CGSubsystem.find "cpu"

type stat = {
  nr_periods : int;
  nr_throttled : int;
  throttled_time : int;
}

let stat_converter = Converter.ro
  (fun s -> match Converter.(read (list ~sep:'\n' (pair ~sep:' ' string int))) s with
  | ["nr_periods", nr_periods;
     "nr_throttled", nr_throttled;
     "throttled_time", throttled_time] ->
    { nr_periods; nr_throttled; throttled_time; }
  | _ -> raise (Invalid_argument "stat_of_string"))

let cfs_quota_us = CGParameters.mk_set t "cfs_quota_us" Converter.int
let cfs_period_us = CGParameters.mk_set t "cfs_period_us" Converter.int

let stat = CGParameters.mk_get t "stat" stat_converter

let shares = CGParameters.mk_set t "share" (Converter.bounded_int ~min:2 ())

let rt_period_us = CGParameters.mk_set t "rt_period_us" Converter.int
let rt_runtime_us = CGParameters.mk_set t "rt_runtime_us" Converter.int

