(* main.ml *)

open Tally

(* use cmdliner for the cli
   https://erratique.ch/software/cmdliner/doc/index.html *)

open Cmdliner

let dir =
  let doc = "a directory containing your bank statements." in
  Arg.(value & opt string "." & info [ "d" ] ~docv:"DIR" ~doc)

let tally_t = Term.(const Reports.summarise $ dir)

let cmd =
  let doc = "summarise a directory of bank statements" in
  let info = Cmd.info "tally" ~version:"0" ~doc in
  Cmd.v info tally_t

let () = Stdlib.exit (Cmd.eval cmd)
