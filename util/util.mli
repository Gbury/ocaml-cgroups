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

val split : seps:(char list) -> string -> string list
val fold_dir : (string -> 'a -> 'a) -> string -> 'a -> 'a

module Opt : sig
  val map : ('a -> 'b) -> 'a option -> 'b option
  val iter : ('a -> unit) -> 'a option -> unit
  val bind : ('a -> 'b option) -> 'a option -> 'b option
end

module type S = sig
  type 'a t

  val bool : bool t
  val string : string t
  val int : ?min:int -> ?max:int -> int t

  val device : (int * int) t
  val range : int list t

  val list : sep:char -> 'a t -> 'a list t
  val pair : sep:char -> 'a t -> 'b t -> ('a * 'b) t
  val triple : sep:char -> 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t

end

module Get : S with type 'a t = string -> 'a
module Set : S with type 'a t = 'a -> string

