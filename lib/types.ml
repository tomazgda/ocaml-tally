open Base

(* an /ammount/ is a pair of non-negative numbers *)
type amount = float * float
[@@deriving sexp]

(* a /movement/ is a movement of some quantity to an account*)
type movement =
  | Joint 	of amount
  | Expense 	of amount
  | Income	of amount
[@@deriving sexp]

(* a /transaction/ is a set of movements *)
type transaction = {
    date 	: string;
    name 	: string;
    movements	: movement list}
[@@deriving sexp]
