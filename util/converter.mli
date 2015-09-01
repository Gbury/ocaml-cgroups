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

type ('ty, -'attr) t
  constraint 'attr = [< `Read | `Write ]

val ro : (string -> 'a) -> ('a, [ `Read ]) t
val wo : ('a -> string) -> ('a, [ `Write ]) t
val rw : (string -> 'a) -> ('a -> string) -> ('a, [ `Read | `Write ]) t

val read : ('a, [> `Read ]) t -> string -> 'a
val write : ('a, [> `Write ]) t -> 'a -> string

val int : (int, [ `Read | `Write ]) t
val bool : (bool, [ `Read | `Write ]) t
val string : (string, [ `Read | `Write ]) t

val pair : sep:char -> ('a, 'c) t -> ('b, 'c) t -> ('a * 'b, 'c) t
val triple : sep:char -> ('a, 'd) t -> ('b, 'd) t -> ('c, 'd) t -> ('a * 'b * 'c, 'd) t

val list : sep:char -> ('a, 'b) t -> ('a list, 'b) t

val device : (int * int, [ `Read | `Write ]) t

val range : (int list, [ `Read | `Write ]) t
val single_range : (int * int, [ `Read | `Write ]) t

val bounded_int : ?min:int -> ?max:int -> unit -> (int, [ `Read | `Write ]) t

