(* report.ml - presenting data from a tally *)

open Base

include Types

(* print the entire tally *)
let print tally =
  tally
  |> List.map ~f:Types.sexp_of_transaction
  |> List.map ~f:Sexp.to_string_hum
  |> List.iter ~f:Stdio.print_endline
;;

let string_of_account = function
  | Joint 	-> "Joint"
  | Expense 	-> "Expense"
  | Income 	-> "Income"
;;

(* :) *)
let date_in_range date initial final =
  (String.compare date final < 0) && (String.compare date initial > 0)
;;

let balance ?(accounts=["Joint";"Expense";"Income"]) ?(start_date="") ?(end_date="") tally =

  let dates_provided  =
    (not (String.equal start_date "")) && (not (String.equal end_date ""))
  in
  
  (* a list of transfers *)
  let get_transfers tally =
    tally (* A list of transactions *)
    (* Filter out the dates out of range *)
    |> List.filter ~f:(fun t ->
           (* if dates unspecified, keep all the transactions *)
           if (not dates_provided) then
             true
           else
             (date_in_range t.date start_date end_date))
    |> List.map ~f:(fun t -> t.transfers) (* we need the dates as well just get the transfers *)
    |> List.concat
    (* filter out the accounts that have not been specified *)
    |> List.filter ~f:(fun transfer -> let (name, _) = transfer in
                                       List.mem ~equal:String.equal accounts (string_of_account name))
    (* sort the transfers by date *)
  in

  (* create a list of balances for each account specified - a balance is a named amount *)
  let create_statement transfers =

    let add_amount (db1, cr1) (db2, cr2) =
      (db1 +. db2, cr1 +. cr2)
    in

    let sum_amounts amounts =
      List.fold ~f:add_amount ~init:(0.0,0.0) amounts
    in
    
    List.map ~f:(fun account_name ->
        let total = 
          transfers
          |> List.filter ~f:(fun transfer -> let (name, _) = transfer in
                                             String.equal account_name (string_of_account name))
          |> List.map ~f:(fun transfer -> let (_, amount) = transfer in amount)
          |> sum_amounts
        in
        (account_name, total)
      )
      accounts
  in

  let print_statement statement =
    let format_balance balance =
      let (name, (db,cr)) = balance in
      Printf.sprintf "%-10s | %-10.2f %-10.2f" name db cr
    in

    let box string =
      let len = String.length string in
      let hbar = String.init len ~f:(fun _ -> '-') in
      Stdio.printf "%s\n%s\n%s\n" hbar string hbar
    in

    if dates_provided then
      Printf.sprintf "From: %s to %s" start_date end_date |> box;
    List.iter ~f:(fun balance -> balance |> format_balance |> box) statement
  in


  tally |> get_transfers |> create_statement |> print_statement
;;
