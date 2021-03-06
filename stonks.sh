#!/bin/bash
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
	# Input checking!
	if [ "$stock" = "exit" ]
	then
		exit 1
	elif [ "${#stock}" -gt 6 ]
	then
		echo Invalid stock ticker length!
		err=1
		continue
	elif [[ -z "$month" ]]
	then
		echo No month entered!
		err=1
		continue
	elif [[ -z "$year" ]]
	then
		echo No year entered!
		err=1
		continue
	elif [ "${#month}" -gt 2 ]
	then
		echo Invalid month! Please enter a number between 1 and 12
		err=1
		continue
	elif [ "$month" -gt 12 -o "$month" -lt 1 ]
	then
		echo Invalid month! Please enter a number between 1 and 12
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
	echo The query that will be executed is: $stock for $month/$year
	read -p "Is this correct[y/n]? " decision
	if [ "$decision" = "n" -o "$decision" = "N" ]
	then
		err=1
		continue
	elif [ "$decision" = "exit" ]
	then
		exit 1
	elif [ "$decision" != "y" -a "$decision" != "Y" ]
	then
		echo 'Invalid selection. Please input [y/n] or exit' 
	fi
fi
# Let's make sure that the script is already in our directory
if [ ! -f get-yahoo-quotes.sh ]
then
	wget https://raw.githubusercontent.com/bradlucas/get-yahoo-quotes/master/get-yahoo-quotes.sh
	chmod +x get-yahoo-quotes.sh
fi
# Let's check an see if there's already a file for the stock we're interested in before calling the script
FILE=$stock.csv
if [ ! -f "$FILE" ]
then
	./get-yahoo-quotes.sh $stock
fi
if [ -f "$FILE" ]
then
	echo File "$FILE" created
	err=1
	initarg=0
else
	echo Error pulling quotes from Yahoo!
	err=1
	initarg=0
	continue
fi
# Start the command flow for pulling the user's query
# The get-yahoo-quotes script should grab all available dates from 1970 onwards
# We should check to see if the year the user queries makes sense
# This stores the first year and first month in the scraped file
firstyear="$(awk -F "-" 'NR==2{print $1}' "$stock".csv)"
firstmonth="$(awk -F "-" 'NR==2{print $2}' "$stock".csv)"
# Let's compare this to the user input
if [ "$firstyear" -gt "$year" ]
then
	echo The first year this stock was tracked is "$firstyear"
	echo Please provide a year query which is consistent with the available
	echo data.
	err=1
	initarg=0
	continue
fi
# Do the same thing for the month
	if [ "$firstmonth" -gt "$month" -a "$firstyear" -eq "$year" ]
then
	echo The first month this stock was tracked is "$firstmonth"
	echo Please provide a month query which is consistent with the
	echo available data.
	err=1
	initarg=0
	continue
fi
# We need to modify our month so we can use it in a regular expression
if [ "$month" -lt 10 -a ${#month} -lt 2 ]
then
	month=0"$month"
fi
# The year, month, and stock ticker should all be good now.
# We can move on to parsing the file
# Let's find the row where the first instance of our year + month occurs
rows="$(echo "$(awk "/${year}-${month}/"'{print NR}' "$stock".csv)")"
# HACKY SOLUTION TO ARRAY OUTPUT
echo "$rows" > row_indices.tmp
# This could be an array, so we need to trim it down
firstrow="$(head -n 1 row_indices.tmp)"
lastrow="$(tail -n 1 row_indices.tmp)"
# Let's prep the file
echo 'Date, Adjusted Closing Price / cent' > "$stock"_"$month"_"$year".txt
# Now we should just need to use awk to grab the correct columns and rows
awk -v firstrow="$firstrow" -v lastrow="$lastrow" -F "\"*,\"*" 'NR>=firstrow && NR<=lastrow{print $1", "$6*100}' "$stock".csv > chronologic.tmp
# Reverse the order of the original query
tac chronologic.tmp >> "$stock"_"$month"_"$year".txt
# Cleanup
rm row_indices.tmp chronologic.tmp
################################################################################
# Stretch Goal
# Use Julia to generate a Unicode Plot of the user's Query
################################################################################
# Check and see if Julia is installed
if command -v julia &> /dev/null
then
	echo Initializing Julia Plotting Script...
	echo This may take a while.
	julia plotting_script.jl "$stock"_"$month"_"$year".txt "$stock" "$month" "$year"
	echo 
fi
# We want to change these flags so that it prompts for user input
# the next time we go through the loop
err=1
initarg=0
done
