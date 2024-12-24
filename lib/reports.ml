(* reports.ml *)

open Base
open Utils

include Types

(* ------------------------------------------------------------------------------------ *)

let summarise directory =

  let get_movements =
    List.map ~f:(fun t -> t.movements)
    >> List.concat
  in

  let add_amount (db1, cr1) (db2, cr2) =
    (db1 + db2, cr1 + cr2)
  in

  (* let fmt (db, cr) = *)
  (*   Printf.sprintf "(%.2f, %.2f)" db cr *)
  (* in *)

  (* sum the amounts for each account *)
  let sum_movements movements =
    
    let empty_accounts = ((0,0), (0,0), (0,0)) in

    let f (joint,expense,income) = function
      | (Joint, amt) -> (add_amount amt joint, expense, income)
      | (Expense, amt) -> (joint, add_amount amt expense, income)
      | (Income, amt) -> (joint, expense, add_amount amt income)
    in
    
    List.fold movements ~init:empty_accounts ~f:f

  in

  let (joint_bal, expense_bal, income_bal) =
    directory
    |> Reader.parse_directory
    |> get_movements
    |> sum_movements
  in

  let make_row account balance =
    let format = Int.to_float
                 >> (fun n -> n /. 100.0)
                 >> Float.to_string_hum ~delimiter:',' ~decimals:2
    in
    
    let (cr,db) = Utils.map_double ~f:format balance in

    [account;cr;db]
  in

  let table = [
      ["Account"; "Debit"; "Credit"]
      ; make_row "Joint" joint_bal
      ; make_row "Expense" expense_bal
      ; make_row "Income" income_bal
    ]
  in

  Table.pp_table table
