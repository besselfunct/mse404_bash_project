#!/usr/bin/bash
# This script:
#    1. Repeatedly prompts the user for $STOCK, $MONTH, and $YEAR
#       and produces a file containing the adjusted daily closing
#       price for each trading day that month
#    2. The output should be a file named: '<stockSymbol>_<Month>_<Year>.txt'
#    3. The output should be two columns: "Date" and "Adjusted Closing Price / cent"
#       and the output should be in reverse chronological order.
#####################################################################
echo Welcome to Stonks\!™
echo This program takes a stock ticker \(e.g. AAPL\)
echo a month \(as an integer, for example 9 = September\)
echo and a four-digit year \(2009\) and produces a 2-column text file
echo as output in reverse chronological order.
echo [typing "exit" at any point will exit the script]
echo -e "\n \n \n"
#####################################################################
while true; do

	read -p "Please enter a stock ticker month and year (i.e. 'AAPL 9 2009'): " stock month year
	echo The query that will be executed is: $stock for $month/$year
	# Input checking!
	if [ "$stock" = "exit" ]
	then
		exit 1
	elif [ "${#stock}" -gt 6 ] # Not sure how to test for mixing ints and str
	then
		echo Invalid stock ticker length!
		continue
	elif [ "$month" -gt 12 -o "$month" -lt 1 ]
	then
		echo Invalid month! Please use a number between 1 and 12
		continue
	elif [ "$year" -gt 2021 -o "$year" -lt 1928 ]
	then
		echo Invalid year! Please use 4-digit format,
		echo and limit queries to 1928 or later.
		continue
	fi

	read -p "Is this correct[y/n]? " decision

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
