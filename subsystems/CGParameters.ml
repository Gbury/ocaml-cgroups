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

class virtual attr sub name = object(self)

  val name = name
  val subsystem = sub

  method subsystem = subsystem

  method private file =
    Format.asprintf "%s.%s" subsystem name

  method private raw_get path =
    let f = Filename.concat path self#file in
    let rec aux ch acc =
      match input_line ch with
      | exception End_of_file -> acc
      | s -> aux ch (s :: acc)
    in
    let ch = open_in f in
    let res = String.concat "\n" (List.rev (aux ch [])) in
    close_in ch;
    res

  method private raw_set path value =
    let f = Filename.concat path self#file in
    let ch = open_out f in
    output_string ch value;
    close_out ch
end

class ['a] get_attr sub name from_string = object
  inherit attr sub name as super

  val convert_to : string -> 'a = from_string

  method get path = convert_to (super#raw_get path)
end


class ['a] reset_attr sub name from_string zero = object
  inherit ['a] get_attr sub name from_string as super

  val reset_value = zero

  method reset path = super#raw_set path reset_value
end

class ['a] set_attr sub name from_string to_string = object
  inherit ['a] get_attr sub name from_string as super

  val convert_from : 'a -> string = to_string

  method set path value = super#raw_set path (convert_from value)
end
