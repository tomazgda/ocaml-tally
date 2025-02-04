(* reader.ml *)

open Base
open Stdio
open Utils
include Types

let parse_line line =
  (* if desc greater than 18 characerts, the first 18 characters are the description
     and the remaining characters are a tag *)
  let split_desc_and_tag s =
    let len = String.length s in
    if len > 18 then
      (String.sub s ~pos:0 ~len:18, String.sub s ~pos:18 ~len:(len - 18))
    else (s, "")
  in

  (* float -> movement list *)
  let movements_of_amount n =
    let n = Int.of_float (n *. 100.) in
    let abs_n = Int.abs n in
    if n >= 0 then [ (Joint, (abs_n, 0)); (Income, (0, abs_n)) ]
    else [ (Joint, (0, abs_n)); (Expense, (abs_n, 0)) ]
  in

  let transaction_of_fields (dt, body, amt, _bal) =
    let date = parse_date dt in
    let movements = amt |> Float.of_string |> movements_of_amount in
    let desc, tag = split_desc_and_tag body |> map_double ~f:normalise_string in
    { date; desc; tag; movements }
  in

  match String.split ~on:',' line with
  | [ dt; body; amt; _bal ] -> transaction_of_fields (dt, body, amt, _bal)
  | _ ->
      failwith "Invalid line format: expected 'date,description,amount,balance'"

let parse_file filename =
  let transactions_of_file ic =
    let first_line = In_channel.input_line_exn ic in
    if String.equal first_line "Date,Description,Amount,Balance" then
      let f acc x = parse_line x :: acc in
      In_channel.fold_lines ~init:[] ~f ic
    else failwith "Invalid Statement Type"
  in

  In_channel.with_file ~f:transactions_of_file filename

let parse_directory dir =
  Utils.ls_dir dir |> List.map ~f:parse_file |> List.concat

(* let transactions_to_sexps transactions = List.map ~f:sexp_of_transaction transactions *)

let sexps_to_file ~name transactions =
  let write_all oc =
    let write_t t = Out_channel.fprintf oc "%s\n" (Sexp.to_string_hum t) in
    List.iter ~f:write_t transactions
  in

  Out_channel.with_file name ~f:write_all
