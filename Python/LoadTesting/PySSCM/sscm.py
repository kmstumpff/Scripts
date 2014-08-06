from PySSCM import *
print("Connecting")
mySSCM = SSCM()
mySSCM.SCMServerAddr='localhost'
mySSCM.PortNum=4900
mySSCM.Username='Administrator'
mySSCM.Password=''
print("Connected")
print("Checking out")
mySSCM.checkout('make_java_files.bat',Branch='RAD',Repository='RAD/Test_1/src',)
print("Checked out")
print("Checking in")
mySSCM.checkin('make_java_files.bat',Branch='RAD',Repository='RAD/Test_1/src',Update=True)
print("Finished")