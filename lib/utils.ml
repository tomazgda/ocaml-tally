(* utils.ml *)

open Base

(* ------------------------------------------------------------------------------------ *)

let ( >> ) f g x = g (f x)
let map_double ~f (a, b) = (f a, f b)

(* let round ~dp n = Float.round (n *. 100.) /. 100.;; *)

(* ------------------------------------------------------------------------------------ *)

let parse_date date =
  match String.split ~on:'/' date with
  | [d;m;y] -> y ^ "-" ^ m ^ "-" ^ d
  | _ -> failwith "Invalid date format: expected 'dd/mm/yyyy'"

let normalise_string string =
  string
  |> String.strip
  |> String.split ~on:' '
  |> List.filter ~f:(Fn.non String.is_empty)
  |> String.concat ~sep:" "

(* ------------------------------------------------------------------------------------ *)

let ls_dir dir =
  let rec loop result = function
    | f::fs when Stdlib.Sys.is_directory f ->
       Stdlib.Sys.readdir f
       |> Array.to_list
       |> List.map ~f:(Stdlib.Filename.concat f)
       |> List.append fs
       |> loop result
    | f::fs when Stdlib.Filename.check_suffix f "csv" ->
       loop (f::result) fs
    | _::fs -> loop result fs
    | []    -> result
  in
  loop [] [dir]
