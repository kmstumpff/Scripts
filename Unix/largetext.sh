#!/bin/bash
clear
echo "Enter name of text file (do not add extension):"
echo "If file exists, it will be replaced."
read name
#touch $name.txt
#rm $name.txt
touch $name.txt
echo "Enter size of file (KB):"
read size
multiplier="63"
numtimes=$((size*multiplier))
echo "Creating $size KB file!"
echo "Please wait..."
for (( i = 1 ; i <= $numtimes ; i++ ))
do
	echo "!@#$%^&*()_+=-~" >> $name.txt
	if [ $(($i%63000)) = "0" ]
	then
		echo "$(($i/63000)) MB created"
	fi
done
echo "Finished!"
sleep 2
clear
