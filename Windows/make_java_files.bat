@echo off

for /l %%x in (1, 1, 9) do (
	mkdir folder%%x
	for /l %%y in (1, 1, 9) do (
		echo /* This is a test file */ > folder%%x\file%%x-%%y.java
	)
)
