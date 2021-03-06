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

(* Directory iteration *)
let fold_dir f d acc =
  let rec aux f dir acc =
    match Unix.readdir dir with
    | exception End_of_file -> Unix.closedir dir; acc
    | s when s = Filename.current_dir_name
             || s = Filename.parent_dir_name ->
      aux f dir acc
    | s -> aux f dir (f s acc)
  in
  aux f (Unix.opendir d) acc

(* String manipulation *)
let rec next_occ s i l =
  if i >= String.length s || List.mem s.[i] l then i
  else next_occ s (i + 1) l

let split ~seps s =
  let rec aux l s acc i =
    if i >= String.length s then acc
    else begin
      let j = next_occ s i l in
      if j <= i then
        aux l s acc (i + 1)
      else
        aux l s (String.sub s i (j - i) :: acc) (j + 1)
    end
  in
  List.rev (aux seps s [] 0)

(* Operations on integer lists as ranges *)
let range (start, stop) =
  let rec aux start acc i =
    if i < start then acc
    else aux start (i :: acc) (i -1)
  in
  aux start [] stop

let compactify l =
  let rec aux acc (min,max) = function
    | [] -> (min,max) :: acc
    | x :: r ->
      if x = max + 1 then aux acc (min,x) r
      else aux ((min,max) :: acc) (x,x) r
  in
  match List.sort (fun (x:int) y -> compare x y) l with
  | [] -> []
  | x :: r -> aux [] (x,x) r

(* Option operations *)
module Opt = struct

  let map f = function None -> None | Some a -> Some (f a)

  let iter f = function None -> () | Some a -> f a

  let iter2 f = function None -> () | Some (a, b) -> f a b

  let bind f = function None -> None | Some a -> f a

end

