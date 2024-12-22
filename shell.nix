{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages;
      [
        bash
        
        ocamlPackages.ocaml
        ocamlPackages.dune_3
        ocamlPackages.findlib
        ocamlPackages.utop
        ocamlPackages.odoc
        ocamlPackages.ocaml-lsp

        ocamlPackages.janeStreet.base
        ocamlPackages.janeStreet.core
        ocamlPackages.janeStreet.core_unix
        ocamlPackages.janeStreet.sexplib
        ocamlPackages.janeStreet.ppx_jane
      ];
}
