open Base
open Tally

(* A tally is a list of transactions - a type in types.ml. They are represented by a list of S-expressions *)

let print_help () =
  let info =
    "
     Tally - a plain text accounting tool
          
     Usage
   	tally create <directory> <suffix> <dest>		create a tally file from a directory of files matching <suffix> and saves it at <dest>
     	tally print <file>					print a tally from a tally file
     	tally balance	-i <file>				print the balances of all accounts
     	tally balance -i <file> -a <accounts>			print the balances of specified accounts <accounts> in form 'account1' 'account2' ... etc
     	tally balance -i <file> --from <date> --to <date>	print the balance between a start and end date in form 'year-month-day'
   	tally --help						print help information
     "
  in
  Stdio.printf "%s" info
;;

(* needs rework for more command line options *)
let () =
  let args = Sys.get_argv () |> Array.to_list in
  match List.tl args with
  | Some ["create"; dir; suffix; dest]
    -> Utils.read_dir dir suffix
       |> First_direct.to_tally 		(* create a tally - a list of transactions *)
       |> Utils.write_tally ~filename:dest  	(* write those transactions as s-expressions to a file *)

  | Some ["print"; file]
    -> Utils.read_tally file 		
    |> Report.print

  (* balances for all acounts *)
  | Some ["balance"; "-i"; file]
    -> Utils.read_tally file
       |> Report.balance

  (* blanaces for specified accounts *)
  | Some ["balance"; "-i"; file; "-a"; accounts]
    -> Utils.read_tally file
    |> Report.balance ~accounts:(String.split ~on:' ' accounts)

  (* balances for all accounts between two dates *)
  | Some ["balance"; "-i"; file; "--from"; start_date; "--to"; end_date]
    -> Utils.read_tally file
       |> Report.balance ~start_date ~end_date

  (* balances for specified accounts  *)
  | Some ["balance"; "-i"; file; "-a"; accounts; "--from"; start_date; "--to"; end_date]
    -> Utils.read_tally file
       |> Report.balance ~accounts:(String.split ~on:' ' accounts) ~start_date ~end_date

  (* help or anything unmatched and the help screen is printed *)
  | Some ["--help"] 				-> print_help ()
  | _ 						-> print_help ()
;;
