#!/usr/bin/bash
# This script:
#    1. Repeatedly prompts the user for $STOCK, $MONTH, and $YEAR
#       and produces a file containing the adjusted daily closing
#       price for each trading day that month
#    2. The output should be a file named: '<stockSymbol>_<Month>_<Year>.txt'
#    3. The output should be two columns: "Date" and "Adjusted Closing Price / cent"
#       and the output should be in reverse chronological order.
#####################################################################
user_prompt () {
	read -p "Please enter a stock ticker month and year (i.e. 'AAPL 9 2009'): " stock month year
}
#####################################################################
initarg=1 # Assume that arguments are passed
err=0 # Initialize a state tracking variable for control flow
stock=$1; month=$2; year=$3; # Assign CLI args
if [[ -z "$stock" ]]
then
initarg=0 # If $stock is empty we can assume no CLI args were passed
echo Welcome to Stonks\!™
echo This program takes a stock ticker \(e.g. AAPL\)
echo a month \(as an integer, for example 9 = September\)
echo and a four-digit year \(2009\) and produces a 2-column text file
echo as output in reverse chronological order.
echo [typing "exit" at any point will exit the script]
echo -e "\n"
echo You can also run this script by passing command line arguments
echo \> ./stonks.sh AAPL 9 2009
echo For example
echo -e "\n"
user_prompt
fi
#####################################################################
while true
do
	if [ "$err" = 1 ] # We only want to call this again if we have an error
	then
		user_prompt
	fi
	echo The query that will be executed is: $stock for $month/$year
	# Input checking!
	if [ "$stock" = "exit" ]
	then
		exit 1
	elif [ "${#stock}" -gt 6 ] # Not sure how to test for mixing ints and str
	then
		echo Invalid stock ticker length!
		err=1
		continue
	elif [ "$month" -gt 12 -o "$month" -lt 1 ]
	then
		echo Invalid month! Please use a number between 1 and 12
		err=1
		continue
	elif [ "$year" -gt 2021 -o "$year" -lt 1970 ]
	then
		echo Invalid year! Please use 4-digit format,
		echo and limit queries to 1970 or later.
		err=1
		continue
	fi
if [ "$initarg" = 0 ]
then
	read -p "Is this correct[y/n]? " decision
fi
	if [ "$decision" = "y" -o "$decision" = "Y" ]
	then
		echo Fetching data...

	elif [ "$decision" = "n" -o "$decision" = "N" ]
	then
		echo Clearing variables...
	elif [ "$decision" = "exit" ]
	then
		exit 1
	else
		echo Invalid input. Please answer \(y/n/exit\)
	fi
done
