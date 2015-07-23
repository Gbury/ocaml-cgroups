
let rec next_occ s i l =
  if i >= String.length s || List.mem s.[i] l then i
  else next_occ s (i + 1) l

let split ~seps s =
  let rec aux l s acc i =
    let j = next_occ s i l in
    if j = i then aux l s acc (i + 1)
    else aux l s (String.sub s i (j - i):: acc) (j + 1)
  in
  List.rev (aux seps s [] 0)


