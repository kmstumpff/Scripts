#!/usr/bin/python
from xml.dom import minidom
import os, sys

run_ans = input("Do you want to run the assessment now? [y/n]: ")

if (( run_ans == "y" ) | ( run_ans == "Y" )):
	sys_command = "winsat formal"
	os.system(sys_command)

# Open a file
path = "C:\Windows\Performance\WinSAT\DataStore"
dirs = os.listdir( path )

# This would print all the files and directories
for file in dirs:
	if "Formal.Assessment (Recent).WinSAT.xml" in file:
		myfile = file
print("")
print("File directory:")
print("-------------------------------------------------------------------")
print(path)
print("-------------------------------------------------------------------")
print("")
print("Reading from file:")
print("-------------------------------------------------------------------")
print(myfile)
print("-------------------------------------------------------------------")
print("")

wei_file_dir = "C:\Windows\Performance\WinSAT\DataStore"

xmldoc = minidom.parse(wei_file_dir + "\\" + myfile)
# Print header

print(" Score\t\tValue")
print("----------------------")

# Memory Score
score_mem = xmldoc.getElementsByTagName('MemoryScore')
for s in score_mem:
	print("RAM\t\t" + s.childNodes[0].nodeValue)
	
# CPU Score
score_cpu = xmldoc.getElementsByTagName('CPUScore')
for s in score_cpu:
	print("CPU\t\t" + s.childNodes[0].nodeValue)

#  Graphics Score
score_graphic = xmldoc.getElementsByTagName('GraphicsScore')
for s in score_graphic:
	print("Graphics\t" + s.childNodes[0].nodeValue)

#  Gaming Graphics Score
score_gaming = xmldoc.getElementsByTagName('GamingScore')
for s in score_gaming:
	print("Gaming Graphics\t" + s.childNodes[0].nodeValue)

#  Disk Score
score_disk = xmldoc.getElementsByTagName('DiskScore')
for s in score_disk:
	print("Disk\t\t" + s.childNodes[0].nodeValue)

#  System Score
score_sys = xmldoc.getElementsByTagName('SystemScore')
for s in score_sys:
	print("System\t\t" + s.childNodes[0].nodeValue)

