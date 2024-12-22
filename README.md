# Ocaml-tally

A plain text accounting tool.

## Build

On nix run

``` bash
nix-shell
```

to install dependencies in `shell.nix`.

Then to build run

``` bash
dune build tally
```

The exectuble can be found in `_build/default/bin/main.exe`.

## Help

``` bash
Tally - a plain text accounting tool
          
Usage	
		tally   --create [directory] [suffix] [dest]    create a tally from a directory of files matching [suffix] and saves it at [dest]
	    tally   --print [file]                          print a tally from a tally file
    	tally   --help                                  print help information
```

