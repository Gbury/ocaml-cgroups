
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


(* Directory iteration *)
let rec fold_dir f d acc =
  let rec aux f dir acc =
    match Unix.readdir dir with
    | exception End_of_file -> Unix.closedir dir; acc
    | s when s = Filename.current_dir_name
             || s = Filename.parent_dir_name ->
      aux f dir acc
    | s -> aux f dir (f s acc)
  in
  aux f (Unix.opendir d) acc
