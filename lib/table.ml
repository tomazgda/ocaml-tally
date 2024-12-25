(* table.ml *)

open Base

(* Would like to use Format, following the "Pretty Printing in Ocaml:"
   https://keleshev.com/pretty-printing-in-ocaml-a-format-primer *)

(* current implementation *)

let is_number s =
  match Float.of_string_opt s with Some _ -> true | None -> false

let pad_string width s =
  let padding = width - String.length s in
  if is_number s then String.make padding ' ' ^ s
  else s ^ String.make padding ' '

let column_widths table =
  let initial_widths = List.hd_exn table |> List.map ~f:String.length in

  let get_wider_cell len cell = Int.max len (String.length cell) in

  let widest_cells acc row = List.map2_exn ~f:get_wider_cell acc row in

  List.fold ~f:widest_cells ~init:initial_widths table

let pp_table table =
  let widths = column_widths table in

  let between_pipes s = "| " ^ s ^ " |" in

  let h_rule =
    let make_rule w = String.make w '-' in

    List.map ~f:make_rule widths |> String.concat ~sep:" | " |> between_pipes
  in

  let print_row i row =
    (* begin table with a horizontal bar *)
    if i = 0 then Stdio.printf "%s\n" h_rule;

    (* print rows *)
    Stdio.printf "%s\n"
      (List.map2_exn ~f:pad_string widths row
      |> String.concat ~sep:" | " |> between_pipes);

    (* print hbar under first row and  end table with an hbar *)
    if i = 0 || i = List.length table - 1 then Stdio.printf "%s\n" h_rule
  in

  List.iteri ~f:print_row table
