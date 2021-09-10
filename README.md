# Stonks! #
Stonks is a bash script which pulls the adjusted closing price for a user-defined stock, month, and year.
## Key Features ##
* Stonks can be passed command-line arguments, or be used in "interactive" mode
* If `Julia` is present on the system, Stonks will try to execute a plotting script which will plot the user's query in the shell
* Stonks can be exited by typing `exit` at the prompt or by interrupting with `Ctrl + C`
* Stonks will continue to prompt the user for input until interrupted
* Stonks outputs the requested data to a new file labeled `<stockSymbol>_<Month>_<Year>.txt` in reverse chronological order (newest first)
* Stonks _should_ handle most errors relatively gracefully
* Stonks will check the directory it's in for files which match the expected output of the Yahoo! quotes query. If it finds it, then the query won't be executed a 2nd time.
## Usage ##
* Run `./stonks.sh` in an environment where BASH is available for "interactive" mode
* Run `./stonks.sh STOCK MONTH YEAR` to run a quick query
## Dependencies ##
Everything should "just work" in a BASH shell. If you want the inline plotting via `Julia` to work, `Julia` must be installed, and on `PATH`. Additionally, `Julia` will look for the `CSV` `DataFrames` and `UnicodePlots` packages. If it doesn't find them, it will attempt to add them using `Pkg`.
