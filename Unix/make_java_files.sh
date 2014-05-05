#!/bin/bash

for x in {1..9}
do
	mkdir folder$x
	for y in {1..9}
	do
		echo /* This is a sample java file */ >> folder$x/file$x-$y.java
	done
done