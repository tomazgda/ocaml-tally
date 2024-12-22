(* report.ml - presenting data from a tally *)

open Base

include Types

(* print the entire tally *)
let print tally =
  tally
  |> List.map ~f:Types.sexp_of_transaction
  |> List.map ~f:Sexp.to_string_hum
  |> List.iter ~f:Stdio.print_endline
