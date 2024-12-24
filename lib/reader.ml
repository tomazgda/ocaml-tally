(* reader.ml *)

open Base
open Stdio
open Utils

include Types

(* ------------------------------------------------------------------------------------ *)

(* check the first line *)
let is_first_direct ic =
  match String.split ~on:',' (In_channel.input_line_exn ic) with
  | [dt; desc; amt; balance] ->
     begin
       String.equal dt "Date"
       && String.equal desc "Description"
       && String.equal amt "Amount"
       && String.equal balance "Balance"
     end
  | _ -> failwith "Invalid Statement Type"

let parse_line line =

  (* float -> movement list *)
  let movements_of_amount n =
    let n = Int.of_float (n *. 100.) in
    let abs_n = Int.abs n in
    if n >= 0 then
      [(Joint, (abs_n, 0)); (Income, (0, abs_n))]
    else
      [(Joint, (0, abs_n)); (Expense, (abs_n, 0))]
  in

  (* if desc greater than 18 characerts, the first 18 characters are the description
     and the remaining characters are a tag *)

  let split_desc_and_tag s =
    let len = String.length s in
    if len > 18 then
      (String.sub s ~pos:0 ~len:18, String.sub s ~pos:18 ~len:(len - 18))
    else
      (s, "")
  in
  
  match String.split ~on:',' line with
  | [dt; body; amt; _bal] ->
     begin
       let date = parse_date dt in
       let movements = amt |> Float.of_string |> movements_of_amount in
       let (desc,tag) = 
         split_desc_and_tag body
         |> map_double ~f:normalise_string
       in
       
       {date;desc;tag;movements}
     end
  | _ -> failwith "Invalid line format: expected 'date,description,amount,balance'"

(* ------------------------------------------------------------------------------------ *)

let parse_file filename =
  let make_tally ic =
    if (is_first_direct ic) then 
      let f acc x = parse_line x :: acc in
      In_channel.fold_lines ~init:[] ~f:f ic
    else
      failwith "Invalid Statement Type"
  in    
  
  In_channel.with_file ~f:make_tally filename

let parse_directory dir =
  Utils.ls_dir dir
  |> List.map ~f:parse_file
  |> List.concat

let write_to_sexps transactions  =
  List.map ~f:sexp_of_transaction transactions

let sexps_to_file ~name transactions =

  let write_all oc =
    let write_t t =
      Out_channel.fprintf oc "%s\n" (Sexp.to_string_hum t)
    in
    List.iter ~f:write_t transactions
  in

  Out_channel.with_file name ~f:write_all
