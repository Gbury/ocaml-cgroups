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

let t = CGSubsystem.find "blkio"

let devices = Converter.(list ~sep:'\n' (pair ~sep:' ' device int))

let weight = CGParameters.mk_set t "weight" (Converter.bounded_int ~min:100 ~max:1000 ())

let weight_device = CGParameters.mk_set t "weight_device" devices

let throttle_read_bps_device = CGParameters.mk_set t "throttle.read_bps_device" devices
let throttle_read_iops_device = CGParameters.mk_set t "throttle.read_iops_device" devices
let throttle_write_bps_device = CGParameters.mk_set t "throttle.write_bps_device" devices
let throttle_write_iops_device = CGParameters.mk_set t "throttle.write_iops_device" devices

let throttle_io_serviced = CGParameters.mk_get t "throttle.io_serviced"
    Converter.(list ~sep:'\n' (triple ~sep:' ' device string int))

let throttle_io_service_bytes = CGParameters.mk_get t "throttle.io_service_bytes"
    Converter.(list ~sep:'\n' (triple ~sep:' ' device string int))

let reset_stats = CGParameters.mk_reset t "reset_stats" Converter.int "0"

let time = CGParameters.mk_get t "time" devices

let sectors = CGParameters.mk_get t "sectors" devices

let avg_queue_size = CGParameters.mk_get t "avg_queue_size" Converter.int

let group_wait_time = CGParameters.mk_get t "group_wait_time" Converter.int

let empty_time = CGParameters.mk_get t "empty_time" Converter.int

let idle_time = CGParameters.mk_get t "idle_time" Converter.int

let io_serviced = CGParameters.mk_get t "io_serviced"
    Converter.(list ~sep:'\n' (triple ~sep:' ' device string int))

let io_service_bytes = CGParameters.mk_get t "io_service_bytes"
    Converter.(list ~sep:'\n' (triple ~sep:' ' device string int))

let io_service_time = CGParameters.mk_get t "io_service_time"
    Converter.(list ~sep:'\n' (triple ~sep:' ' device string int))

let wait_time = CGParameters.mk_get t "wait_time"
    Converter.(list ~sep:'\n' (triple ~sep:' ' device string int))

let io_merged = CGParameters.mk_get t "io_merged"
    Converter.(pair ~sep:' ' int string)

let io_queued = CGParameters.mk_get t "io_queued"
    Converter.(pair ~sep:' ' int string)

