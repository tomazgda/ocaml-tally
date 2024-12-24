(* types.ml *)

open Base

type amount = int * int
[@@deriving sexp]

type account = Joint | Expense | Income
[@@deriving sexp]

type movement = account * amount
[@@deriving sexp]

type transaction =
  { date : string
  ; desc : string
  ; tag : string
  ; movements : movement list }
[@@deriving sexp]
