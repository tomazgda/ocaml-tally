open Base

(* an /ammount/ is a pair of non-negative numbers *)
type amount = float * float
[@@deriving sexp]

(* an account is a unique identifier *)
type account = Joint | Expense | Income
[@@deriving sexp]

(* a transfer contains an account and an amount *)
type transfer = account * amount
[@@deriving sexp]

(* a transaction is a list of transfers with a date and name
   - the transfers must balance *)
type transaction = {
    date 	: string;
    name 	: string;
    transfers	: transfer list}
[@@deriving sexp]
