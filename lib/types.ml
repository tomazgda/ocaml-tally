open Base

(* an /ammount/ is a pair of non-negative numbers *)
type amount = float * float
[@@deriving sexp]

(* an account is a unique identifier of an amount t*)
type account =
  | Joint 	of amount
  | Expense 	of amount
  | Income	of amount
[@@deriving sexp]

(* a transaction is a a summay with a date and name  *)
type transaction = {
    date 	: string;
    name 	: string;
    accounts	: account list}
[@@deriving sexp]
