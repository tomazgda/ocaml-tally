open Base

include Types

let to_tally xs =

  let transaction_from_line line =
    
    (* remove prevailing, trailing, and middle-bit spaces *)
    let normalise_string string =
      string
      |> String.strip
      |> String.split ~on:' '
      |> List.filter ~f:(Fn.non String.is_empty)
      |> String.concat ~sep:" "
    in

    (* seperate the data *)
    let cols = String.split line ~on:','
               |> List.map ~f:normalise_string
    in

    (* declare the name and date *)
    let date = List.nth_exn cols 0 in
    let name = List.nth_exn cols 1 in

    (* delcare the amount, default to 0 *)
    let amount =
      match Float.of_string (List.nth_exn cols 2) with
      | exception _ -> 0.0
      | n -> n
    in

    (* Construct movements *)
    let movements =
      if Float.(amount >= 0.) then
        [Joint (amount, 0.); Income (0., amount)]
      else
        [Joint (0., amount); Expense (amount, 0.)]
    in

    (* construct the transaction *)
    { date; name; movements }
  in

  List.map ~f:(fun line ->
      line
      |> transaction_from_line
      |> Types.sexp_of_transaction
    ) xs
;;
