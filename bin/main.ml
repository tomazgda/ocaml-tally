open Base
open Tally

(* A tally is a list of transactions - a type in types.ml. They are represented by a list of S-expressions *)

let print_help () =
  let info =
    "
     Tally - a plain text accounting tool
          
     Usage
   	tally 	--create [directory] [suffix] [dest]	create a tally from a directory of files matching [suffix] and saves it at [dest]
   	tally	--print [file]				print a tally from a tally file
   	tally 	--help					print help information
     "
  in
  Stdio.printf "%s" info
;;

let () =
  let args = Sys.get_argv () |> Array.to_list in
  match List.tl args with
  | Some ["--create"; dir; suffix; dest] -> Utils.read_dir dir suffix
                                           |> First_direct.to_tally 		(* create a tally - a list of transactions *)
                                           |> Utils.write_tally ~filename:dest  (* write those transactions as s-expressions to a file *)

  | Some ["--print"; file]		-> Utils.read_tally file 		
                                           |> Report.print

  | Some ["--help"] 			-> print_help ()
  | _ 					-> print_help ()

;;
