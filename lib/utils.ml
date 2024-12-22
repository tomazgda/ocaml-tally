open Base
open Stdio

include Types

(* ------------------------------------------------------------------------------------------ *)

(* return a list of file paths *)
let dir_contents dir suffix =
  let rec loop result = function
    | f::fs when Stdlib.Sys.is_directory f ->
       Stdlib.Sys.readdir f
       |> Array.to_list
       |> List.map ~f:(Stdlib.Filename.concat f)
       |> List.append fs
       |> loop result
    | f::fs when Stdlib.Filename.check_suffix f suffix ->
       loop (f::result) fs
    | _::fs -> loop result fs
    | []    -> result
  in
  loop [] [dir]
;;

(* reads a file into a list of strings - each string being a line *)
let read_file filename =
  In_channel.with_file filename ~f:(fun ic ->
      In_channel.fold_lines ic ~init:[] ~f:(fun acc line -> line :: acc))
  |> List.rev
;;

(* reads a directory into a list of strings - each string being a line *)
let read_dir dir suffix =
  dir_contents dir suffix
  |> List.map ~f:read_file
  |> List.fold_left ~f:List.append ~init:[]

(* ------------------------------------------------------------------------------------------ *)

(* write a tally to file *)
let write_tally ~filename tally =
  Out_channel.with_file filename ~f:(fun out_channel ->
      List.iter tally ~f:(fun transaction ->
          Out_channel.fprintf out_channel "%s\n" (Sexp.to_string transaction)))
;;

(* reads a file into a list of strings - each string being a line *)
let read_tally filename =
  In_channel.with_file filename ~f:(fun ic ->
      In_channel.fold_lines ic ~init:[] ~f:(fun acc line -> (Types.transaction_of_sexp (Parsexp.Single.parse_string_exn line)) :: acc))
  |> List.rev
;;


