# Ocaml-tally

A plain text accounting tool.

## Notes 

In Tally, A tally is a list of transactions each represented by an s-expression.

Tally can build a tally from a directory of first-direct bank statements with the command `tally create`, using the module `lib/first_direct.ml`.

This tally can then be parsed and displayed as reports.

## Types

Right now, only three acounts exist (Joint, Expense and Income) - postive values in a first-direct statement are parsed as Incomes, and negative as Expenses.

```ocaml
type amount = float * float
type account = Joint | Expense | Income
type transfer = account * amount
type transaction = {
    date 	: string;
    name 	: string;
    transfers	: transfer list}
```

## Build

On nix run

``` bash
nix-shell
```

to install dependencies defined in `shell.nix`.

Then to build run

``` bash
dune build tally
```

The exectuble can be found in `_build/default/bin/main.exe`.

## Help

```
Tally - a plain text accounting tool
          
Usage 
tally create <directory> <suffix> <dest>			create a tally file from a directory of files matching <suffix> and saves it at <dest>
tally print <file>									print a tally from a tally file
tally balance	-i <file>							print the balances of all accounts
tally balance -i <file> -a <accounts>				print the balances of specified accounts <accounts> in form 'account1' 'account2' ... etc
tally balance -i <file> --from <date> --to <date>	print the balance between a start and end date in form 'year-month-day'
tally --help										print help information
```
