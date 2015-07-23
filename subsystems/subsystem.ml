
class t name = object

  val name : string = name

  method name = name

  method enabled = true

end

class attr sub name = object(self)

  val name = name
  val subsystem = sub

  method file =
    Format.asprintf "%s.%s" subsystem#name name

  method get path =
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

  method set path value =
    let f = Filename.concat path self#file in
    let ch = open_out f in
    output_string ch value;
    close_out ch

end

class ['a] get_attr sub name from_string = object
  inherit attr sub name as super

  val convert : string -> 'a = from_string

  method get path = convert (super#get path)
end


class ['a] reset_attr sub name from_string zero = object
  inherit ['a] get_attr sub name from_string as super

  val zero = from_string zero

  method reset path = super#set path zero
end

