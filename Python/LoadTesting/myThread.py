from threading import Thread
from PySSCM import *
import time, platform
# Get platform
#=====================================================================================================================================================================
myOS=platform.system()
#=====================================================================================================================================================================
# Options
#=====================================================================================================================================================================
# Global Options
numThreads = 5
wildcard = "\"*\""
scm_server_address = 'dellcoop33'
scm_server_port = 4900
scm_mainline_name = 'Mainline_1'

# CheckIO
cSSCM = SSCM()
cSSCM.SCMServerAddr=scm_server_address
cSSCM.PortNum=scm_server_port
cSSCM.Username='checkio'
cSSCM.Password='checkio'
scm_CIO_FileList = ['file1-1.java','file1-2.java','file1-3.java','file1-4.java','file1-5.java','file1-6.java','file1-7.java','file1-8.java','file1-9.java']
scm_CIO_Branch = scm_mainline_name
scm_CIO_Repo = scm_mainline_name + '/CheckIO/folder1'

# AddRm
aSSCM = SSCM()
aSSCM.SCMServerAddr=scm_server_address
aSSCM.PortNum=scm_server_port
aSSCM.Username='addrm'
aSSCM.Password='addrm'
if myOS is 'Windows':
	scm_AR_LocalAddRepo = 'scmAdd\\'
else:
	scm_AR_LocalAddRepo = 'scmAdd/'
scm_AR_Branch = scm_mainline_name
scm_AR_ServAddRepo = scm_mainline_name + '/AddRemove'

# Branch
bSSCM = SSCM()
bSSCM.SCMServerAddr=scm_server_address
bSSCM.PortNum=scm_server_port
bSSCM.Username='branch'
bSSCM.Password='branch'
scm_B_name = 'pythonBranch'
scm_B_Branch = scm_mainline_name
scm_B_Repo = scm_mainline_name

# Get
gSSCM = SSCM()
gSSCM.SCMServerAddr=scm_server_address
gSSCM.PortNum=scm_server_port
gSSCM.Username='get'
gSSCM.Password='get'
scm_G_Branch = scm_mainline_name
scm_G_Repo = scm_mainline_name + '/Get'
scm_G_Folders = ['folder1','folder2','folder3','folder4','folder5','folder6','folder7','folder8','folder9']
#=====================================================================================================================================================================
# Class for each thread
#=====================================================================================================================================================================
class scmCheckIO(Thread):
	def run(self):
		#while True:
		for x in range(0, 10):
			print("---------------------------- CheckIO " + str(x))
			cSSCM.checkout(scm_CIO_FileList,Branch=scm_CIO_Branch,Repository=scm_CIO_Repo)
			cSSCM.checkin(scm_CIO_FileList,Branch=scm_CIO_Branch,Repository=scm_CIO_Repo,Update=True)
		
class scmAddRm(Thread):
	def run(self):
		#while True:
		for x in range(0, 10):
			print("------------------ AddRm " + str(x))
			aSSCM.add(scm_AR_LocalAddRepo + "*",Branch=scm_AR_Branch,Repository=scm_AR_ServAddRepo,Comment=False)
			aSSCM.rm(wildcard,Branch=scm_AR_Branch,Repository=scm_AR_ServAddRepo,Destroy=True,Force=True)

class scmBranch(Thread):
	def run(self):
		#while True:
		for x in range(0, 10):
			print("-------- Branch " + str(x))
			time_str = str(int(time.time()))
			temp_name = scm_B_name + "-" + time_str[5:]
			bSSCM.mkbranch(temp_name,scm_B_Repo)
			time.sleep(1)
			bSSCM.rmbranch(temp_name,Repository=scm_B_Repo,Destroy=True)

class scmGet(Thread):
	def run(self):
		#while True:
		for x in range(0, 10):
			print("- Get " + str(x))
			gSSCM.get(scm_G_Folders,Branch=scm_G_Branch,Repository=scm_G_Repo,Force=True,Recursive=True)
#=====================================================================================================================================================================
# Start all threads
#=====================================================================================================================================================================
# Start thread - scm_get_thread
scm_get_thread = scmGet()
scm_get_thread.name = "Get"
scm_get_thread.start()
scm_get = 1

# Start thread - scm_branch_thread
scm_branch_thread = scmBranch()
scm_branch_thread.name = "Branch"
scm_branch_thread.start()
scm_branch = 1

# Start thread - scm_addrm_thread
scm_addrm_thread = scmAddRm()
scm_addrm_thread.name = "AddRm"
scm_addrm_thread.start()
scm_addrm = 1

# Start thread - scm_io_thread
scm_io_thread = scmCheckIO()
scm_io_thread.name = "IO"
scm_io_thread.start()
scm_io = 1
#=====================================================================================================================================================================

while scm_get_thread.is_alive() or scm_branch_thread.is_alive() or scm_addrm_thread.is_alive() or scm_io_thread.is_alive():
	if (scm_get == 1) and not scm_get_thread.is_alive():
		print("Get finished!")
		scm_get = 0
	if (scm_branch == 1) and not scm_branch_thread.is_alive():
		print("Branching finished!")
		scm_branch = 0
	if (scm_addrm == 1) and not scm_addrm_thread.is_alive():
		print("Add and remove finished!")
		scm_addrm = 0
	if (scm_io == 1) and not scm_io_thread.is_alive():
		print("Check in and out finished!")
		scm_io = 0

















