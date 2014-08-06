import os
import platform

#make temp file
os.system("clear")
print("Loading...")
string = ""
for x in range(0,250):
	string=string+"A"
commandEcho = "echo " + string + " >> tempfile.txt"
for x in range(0,1000):
	os.system(commandEcho)

os.system("clear")
n = input("How many files?: ")
for y in range(1,n+1):
	commandCP = "cp tempfile.txt " + str(y) +".txt"
	os.system(commandCP)
	#if (n <= 15):	
		#print("Finished file" + str(y) + ".txt")
commandRM = "rm -f tempfile.txt"
os.system(commandRM)
print("Finished")
