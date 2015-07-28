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

val weight : (int, [ `Get | `Set ]) CGParameters.t
val weight_device :(((int * int) * int) list, [ `Get | `Set ]) CGParameters.t

val throttle_read_bps_device : (((int * int) * int) list, [ `Get | `Set ]) CGParameters.t
val throttle_read_iops_device : (((int * int) * int) list, [ `Get | `Set ]) CGParameters.t
val throttle_write_bps_device : (((int * int) * int) list, [ `Get | `Set ]) CGParameters.t
val throttle_write_iops_device : (((int * int) * int) list, [ `Get | `Set ]) CGParameters.t
val throttle_io_serviced : (((int * int) * string * int) list, [ `Get ]) CGParameters.t
val throttle_io_service_bytes : (((int * int) * string * int) list, [ `Get ]) CGParameters.t

val reset_stats : (int, [ `Get | `Reset ]) CGParameters.t
val time : (((int * int) * int) list, [ `Get ]) CGParameters.t
val sectors : (((int * int) * int) list, [ `Get ]) CGParameters.t
val avg_queue_size : (int, [ `Get ]) CGParameters.t
val group_wait_time : (int, [ `Get ]) CGParameters.t
val empty_time : (int, [ `Get ]) CGParameters.t
val idle_time : (int, [ `Get ]) CGParameters.t

val io_serviced : (((int * int) * string * int) list, [ `Get ]) CGParameters.t
val io_service_bytes : (((int * int) * string * int) list, [ `Get ]) CGParameters.t
val io_service_time : (((int * int) * string * int) list, [ `Get ]) CGParameters.t

val wait_time : (((int * int) * string * int) list, [ `Get ]) CGParameters.t
val io_merged : (int * string, [ `Get ]) CGParameters.t
val io_queued : (int * string, [ `Get ]) CGParameters.t
