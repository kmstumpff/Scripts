#!/usr/bin/python

#/*******************************************************************************
# * Copyright 2008 Seapine Software, Inc. All rights reserved.
# * 
# * IMPORTANT:  This Software is supplied to you by Seapine Software, Inc. (Seapine)
# * in consideration of your agreement to the following terms, and your use, installation,
# * modification or redistribution of this Software constitutes acceptance of these terms.
# * If you do not agree with these terms, please do not use, install, modify or redistribute
# * this Software.
# * 
# * In consideration of your agreement to abide by the following terms, and subject to these
# * terms, Seapine grants you a personal, non-exclusive license, under Seapine copyrights in
# * this original Seapine software (the Software), to use, reproduce, modify and redistribute
# * the Software, with or without modifications, in source and/or binary forms; provided that
# * if you redistribute the Software in its entirety and without modifications, you must retain
# * this notice and the following text and disclaimers in all such redistributions of the Software.
# * Neither the name, trademarks, service marks or logos of Seapine, Inc. may be used to endorse
# * or promote products derived from the Software without specific prior written permission from
# * Seapine.  Except as expressly stated in this notice, no other rights or licenses, express or
# * implied, are granted by Seapine herein, including but not limited to any patent rights that
# * may be infringed by your derivative works or by other works in which the Software may be
# * incorporated.
# * 
# * The Software is provided by Seapine on an "AS IS" basis.  SEAPINE MAKES NO WARRANTIES,
# * EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT,
# * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND
# * OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
# * 
# * IN NO EVENT SHALL SEAPINE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL
# * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE,
# * REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER
# * UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN
# * IF SEAPINE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ******************************************************************************/

import os,sys,string,datetime,getopt,time
import types
from subprocess import *

class SSCMException(Exception):

	"""Exception thrown by Surround SCM"""
	def __init__(self, commandLine,value):
		self.value = value
		self.commandLine = commandLine

	def __str__(self):
		return str(self.commandLine)+str(self.value)

class SCMTriState:
	Empty=None

class SCMTimestamps:
	Current, Modify, Checkin,Empty = "current", "modify", "checkin", None
    
class SCMReplace:
	Prompt, Replace, Skip, Empty = "prompt","replace","skip",None

class SCMFileType:
	Auto, Text, Binary, Mac_Binary,UTF8,UTF16, Empty = "auto_detect","text","binary","mac_binary","utf8","utf16",None

class SCMFieldFormat:
	Text, Integer, SCMFloat, SCMList, SCMUser, DateTime, CheckBox = "Text", "Integer", "SCMFloat", "SCMList", "SCMUser", "DateTime", "CheckBox"

class SCMFrequency:
	EveryDay,EveryRefresh,DontCache,Empty = "EveryDay","EveryRefresh","",None
	
class SCMEmailType:
	Internet, MAPI,Other,Empty = "Internet","MAPI","Other",None

class SCMLicencestype:
	Floating,Named,NoLicences,Empty = "floating","named","none",None

class SCMPhonetype:
	Work, Fax, Home, Pager, Mobile, Empty = "Work","Fax","Home","Pager","Mobile", None

class SCMEOL:
	Windows, Unix, Mac, WindowsAppend, UnixAppend, MacAppend = range(6)

class SCMStatus:
	Current, Missing, Modified, Old, Unknown, Empty = "c","i","m","o","u",None

class SCMChangelist:
	CanUse,MustUse,CannotUse,Empty="c","m","n",None

class SCMReplace:
	Latest,Original,Leave,Empty="latest","original","leave",None
	
class SCMDiffType:
	Unified,Context,Empty="Unified","Context",None

class SCMSecurity:
	Inherit,UseDefault,CopyParent,CopyDefault,CopyServer,Empty = range(6)

class SSCM(object):
	"""Use this class to interact with Surround SCM
	"""
	
	def __init__(self):
		self.Username=None
		self.Password=None
		self.SingleSignOn=False
		self.SCMServerAddr=None
		self.PortNum=None
		self.UnicodeOutput=False

	
	def runSCM(self,commandLine, isDestroy=False):
		if self.SingleSignOn:
			commandLine.append("-y+")
		elif self.Username is not None:
			commandLine.append("-y"+self.Username+":"+self.Password)
		if self.SCMServerAddr is not None:
			commandLine.append("-z"+str(self.SCMServerAddr)+":"+str(self.PortNum))
		if self.UnicodeOutput:
			commandLine.append("+u")

#		print("Command line is")
#		print(" ".join(commandLine))
		proc = Popen(" ".join(commandLine), shell=True, stdout=PIPE, stdin=PIPE)
		if isDestroy:
			proc.stdin.write(bytes("Y\n", "ascii"))
			proc.stdin.close()
		result = proc.stdout.readlines()
		if proc.wait() == 1:
			raise SSCMException(" ".join(commandLine),[line.strip() for line in result if not line.isspace()])
		return result
		
	
	def add(self,Items,CustomFields=None,Branch=None,Comment=False,Get=SCMTriState.Empty,Exclusive=False,Repository=None,Recursive=False,FileType=SCMFileType.Empty,\
			Restore=False,Writeable=False,Changelist=None,Label=None,Replacelabel=False,TTUsername=None,TTPassword=None,Defects=None,StateID=None):
		commandLine = ["sscm add"]
		if isinstance(Items,str):
			commandLine.append("'"+Items+"'")
		else:
			for anItem in Items : commandLine.append("'"+anItem+"'")
		
		if CustomFields is not None:
			for field, value in CustomFields.iteritems():
				commandLine.append("-f'"+field+"':'"+value+"'")
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if Comment is not False:
			commandLine.append("-cc'"+Comment+"'")
		else:
			commandLine.append("-c-")
		if Get:
			commandLine.append("-g")
		elif Get==False:
			commandLine.append("-g-")
		if Exclusive:
			commandLine.append("-k")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Recursive:
			commandLine.append("-r")
		if FileType is not None:
			commandLine.append("-t"+str(FileType))
		if Restore:
			commandLine.append("-u")
		if Writeable:
			commandLine.append("-w")
		if Changelist is not None:
			commandLine.append("-x'"+Changelist+"'")
		if Label is not None:
			commandLine.append("-l'"+Label+"'")
		if Replacelabel:
			commandLine.append("-o")
		if TTUsername is not None:
			commandLine.append("-i'"+TTUsername+"':'"+TTPassword+"'")
		if Defects is not None:
			commandLine.append("-a"+":".join(Defects))
		if StateID is not None:
			commandLine.append("-j"+StateID)

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def addcustomfield(self,Name,FieldCode,FieldFormat,DefaultValue=None,ListItems=None,MinValue=None,MaxValue=None):
		commandLine = ["sscm addcustomfield"]
		
		commandLine.append("-d'"+Name+"'")
		commandLine.append("-c'"+FieldCode+"'")
		commandLine.append("-f"+FieldFormat)
		if DefaultValue is not None:
			commandLine.append("-v'"+str(DefaultValue)+"'")
		if ListItems is not None:
			commandLine.append("-l'"+"',".join(ListItems))
		if MinValue is not None:
			commandLine.append("-n"+str(MinValue))
		if MaxValue is not None:
			commandLine.append("-m"+str(MaxValue))
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def addexistingmainline(self,MainlineBranchLocation):
		commandLine = ["sscm addexistingmainline"]
		commandLine.append("'"+MainlineBranchLocation+"'")
		
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def addgroup(self,GroupName,Description=None,Note=None,Commands=None,Usernames=None):
		commandLine = ["sscm addgroup"]
		commandLine.append("'"+GroupName+"'")
		
		if Description is not None:
			commandLine.append("-d'"+Description+"'")
		if Note is not None:
			commandLine.append("-n'"+Note+"'")
		if Commands is not None:
			tempLine=[]
			for category, comm in Commands.iteritems():
				tempLine.append(category+"+"+comm)
			commandLine.append("-s"+":".join(tempLine))
		if Usernames is not None:
			commandLine.append("-u+"+":+".join(Usernames))

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def addproxy(self,ProxyName,ProxyAddr,ProxyPort,ProxyPasswd,RefreshInterval=None,MinFileSize=None,\
				MaxSpace=None,AgeLimit=None,Frequency=SCMFrequency.Empty,Time=None,EncryptMaster=False,EncryptClient=False,Compress=False,Usernames=None):
		commandLine = ["sscm addproxy"]
		commandLine.append("'"+ProxyName+"'")
		commandLine.append("'"+str(ProxyAddr)+"':"+str(ProxyPort))
		commandLine.append("-p'"+ProxyPasswd+"'")

		if RefreshInterval is not None:
			commandLine.append("-i"+str(RefreshInterval))
		if MinFileSize is not None:
			commandLine.append("-m"+str(MinFileSize))
		if MaxSpace is not None:
			commandLine.append("-s"+str(MaxSpace))
		if AgeLimit is not None:
			commandLine.append("-a"+str(AgeLimit))
		if Frequency != SCMFrequency.Empty:
			if Frequency == SCMFrequency.EveryDay:
				commandLine.append("-cEveryDay")
			elif Frequency == SCMFrequency.EveryRefresh:
				commandLine.append("-cEveryRefresh")
			elif Frequency == SCMFrequency.DontCache:
				commandLine.append("-c-")
		if Time is not None:
			commandLine.append("-t"+str(Time))
		if EncryptMaster:
				commandLine.append("-n")
		if EncryptClient:
				commandLine.append("-r")
		if Compress:
				commandLine.append("-o")
		if Usernames is not None:
			commandLine.append("-u+"+":+".join(Usernames))

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def adduser(self,Username,CompanyName=None,CAddress=None,EmailType=SCMEmailType.Empty,EAddress=None,FirstName=None,\
				Licencestype=SCMLicencestype.Empty,NamedNumber=None,LastName=None,Initials=None,Note=None,PhoneType1=SCMPhonetype.Empty,Number1=None,\
				PhoneType2=SCMPhonetype.Empty,Number2=None,TTUsername=None,TTPassword=None,UserSCMPasswd=None):
		commandLine = ["sscm adduser"]
		commandLine.append("'"+Username+"'")
		
		if CompanyName is not None:
			if CAddress is not None:
				commandLine.append("-c'"+CompanyName+"':'"+CAddress+"'")
			else:
				commandLine.append("-c'"+CompanyName+"'")
		if EmailType != SCMEmailType.Empty and EAddress is not None:
			commandLine.append("-e'"+EmailType+"':'"+EAddress+"'")
		if FirstName is not None:
			commandLine.append("-f'"+FirstName+"'")
		if LastName is not None:
			commandLine.append("-l'"+LastName+"'")
		if Licencestype != SCMLicencestype.Empty:
			if Licencestype == SCMLicencestype.Floating:
				commandLine.append("-ifloating")
			elif Licencestype == SCMLicencestype.Named:
				commandLine.append("-inamed:"+str(NamedNumber))
			else:
				commandLine.append("-inone")
		if Initials is not None:
			commandLine.append("-m'"+Initials+"'")
		if Note is not None:
			commandLine.append("-n'"+Note+"'")
		if PhoneType1 != SCMPhonetype.Empty and Number1 is not None:
			if PhoneType2 != SCMPhonetype.Empty and Number2 is not None:
				commandLine.append("-p'"+PhoneType1+":"+Number1+";"+PhoneType2+":"+Number2+"'")
			else:
				commandLine.append("-p"+PhoneType1+":"+Number1)
		if TTUsername is not None:
			commandLine.append("-t'"+TTUsername+"':'"+TTPassword+"'")
		if UserSCMPasswd is not None:
			commandLine.append("-w'"+UserSCMPasswd+"'")
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def batch(self,InputFile,OutputFile=None):
		commandLine = ["sscm batch"]
		commandLine.append("'"+InputFile+"'")
		
		if OutputFile is not None:
			commandLine.append("-o'"+OutputFile+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def branchdiff(self,BranchName2,BranchName1=None,Repository=None,Recursive=False,ExcludeIdentical=False,ExcludeChanged=False,\
					IncludeFileDiffReport=False,IgnoreBlank=False,IgnoreCase=False,IgnoreWhitespace=True,DiffType=SCMDiffType.Empty,NumLines=None):
		commandLine = ["sscm branchdiff"]
		
		commandLine.append("'"+BranchName2+"'")
		if BranchName1 is not None:
			commandLine.append("-b'"+BranchName1+"'")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Recursive:
			commandLine.append("-r")
		else:
			commandLine.append("-r-")
		if ExcludeIdentical:
			commandLine.append("-i")
		if ExcludeChanged:
			commandLine.append("-c")
		if IncludeFileDiffReport:
			commandLine.append("-d")
		if IgnoreBlank:
			commandLine.append("-k")
		if IgnoreCase:
			commandLine.append("-j")
		if IgnoreWhitespace:
			commandLine.append("-w")
		if DiffType != SCMDiffType.Empty:
			commandLine.append("-l"+DiffType)
		if NumLines is not None:
			commandLine.append("-n"+str(NumLines))

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]
			
	def branchhistory(self,Branch=None,BaseRepository=None,DateFrom=None,DateTo=None):
		commandLine = ["sscm branchhistory"]
		
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if BaseRepository is not None:
			commandLine.append("-p'"+BaseRepository+"'")
		if DateFrom is not None and DateTo is not None:
			commandLine.append("-d"+str(DateFrom)+":"+str(DateTo))

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def branchproperty(self,Branch=None,Security=SCMSecurity.Empty,MainlineBranch=None):
		commandLine = ["sscm branchproperty"]
		
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if Security!=SCMSecurity.Empty:
			if Security==SCMSecurity.Inherit:
				commandLine.append("-i")
			elif Security==SCMSecurity.UseDefault:
				commandLine.append("-o")
			elif Security==SCMSecurity.CopyParent:
				commandLine.append("-si")
			elif Security==SCMSecurity.CopyDefault:
				commandLine.append("-so")
			elif Security==SCMSecurity.CopyServer:
				commandLine.append("-sf")
		if MainlineBranch is not None:
			commandLine.append("-p'"+MainlineBranch+"'")
			
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def breakshare(self,Files,Branch=None,Comment=None,Repository=None,Recursive=False,All=False):
		commandLine = ["sscm breakshare"]
		if isinstance(Files,str):
			commandLine.append("'"+Files+"'")
		else:
			for aFile in Files : commandLine.append("'"+aFile+"'")
		
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if Comment is not None:
			commandLine.append("-cc'"+Comment+"'")
		else:
			commandLine.append("-c-")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Recursive:
			commandLine.append("-r")
		if All:
			commandLine.append("-a")
			
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def bulkcustomfieldchange(self,FieldValues,Items,Branch=None,Repository=None,Recursive=False):
		commandLine = ["sscm bulkcustomfieldchange"]
		for field, value in FieldValues.iteritems():
			commandLine.append("'"+field+"':'"+value+"'")
		for aFile in Files : commandLine.append("'"+aFile+"'")
		
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Recursive:
			commandLine.append("-r")
			
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def changebranchattrib(self,BranchName,Mainline=None,Inactivate=SCMTriState.Empty,Cache=SCMTriState.Empty,Freeze=SCMTriState.Empty,Hide=SCMTriState.Empty,Comment=None,Case=False):
		commandLine = ["sscm changebranchattrib"]
		commandLine.append("'"+BranchName+"'")
		
		if Mainline is not None:
			commandLine.append("-p'"+Mainline+"'")
		if Inactivate:
			commandLine.append("-i")
		elif Inactivate==False:
			commandLine.append("-i-")
		if Cache:
			commandLine.append("-o")
		elif Cache==False:
			commandLine.append("-o-")
		if Freeze:
			commandLine.append("-f")
		elif Freeze==False:
			commandLine.append("-f-")
		if Hide:
			commandLine.append("-d")
		elif Hide==False:
			commandLine.append("-d-")
		if Comment is not None:
			commandLine.append("-cc'"+Comment+"'")
		else:
			commandLine.append("-c-")
		if Case:
			commandLine.append("-s")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def changebranchtype(self,BranchName,CurrentOwner=None,CurrentOwnerID=None,Repository=None,MakeBaseline=False,\
						NewOwnerID=None,NewBranchName=None,Comment=None):
		commandLine = ["sscm changebranchtype"]
		commandLine.append("'"+BranchName+"'")
		
		if CurrentOwner is not None:
			commandLine.append("-o'"+CurrentOwner+"'")
		elif CurrentOwnerID is not None:
			commandLine.append("-i"+str(iCurrentOwnerId))
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if MakeBaseline:
			commandLine.append("-sbaseline")
		elif NewOwnerID is not None:
			commandLine.append("-n'"+NewOwnerID+"'")
		if NewBranchName is not None:
			commandLine.append("-b'"+NewBranchName+"'")
		if Comment is not None:
			commandLine.append("-cc'"+Comment+"'")
		else:
			commandLine.append("-c-")
			
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def checkin(self,Files,Branch=None,Comment=None,Force=False,Get=SCMTriState.Empty,Keep=False,Label=None,\
				Override=False,Repository=None,Recursive=False,ConfigName=None,TTUsername=None,TTPassword=None,Defects=None,\
				Writeable=False,Update=SCMTriState.Empty,Remove=SCMTriState.Empty,Changelist=None,StateID=None):
		commandLine = ["sscm checkin"]
		if isinstance(Files,str):
			commandLine.append("'"+Files+"'")
		else:
			for aFile in Files : commandLine.append("'"+aFile+"'")
		
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if Comment is not None:
			commandLine.append("-cc'"+Comment+"'")
		else:
			commandLine.append("-c-")
		if Force:
			commandLine.append("-f")
		if Get:
			commandLine.append("-g")
		elif Get==False:
			commandLine.append("-g-")
		if Keep:
			commandLine.append("-k")
		if Label is not None:
			commandLine.append("-l'"+Label+"'")
		if Override:
			commandLine.append("-o")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Recursive:
			commandLine.append("-r")
		if ConfigName is not None:
			commandLine.append("-s'"+ConfigName+"'")
			if TTUsername is not None:
				commandLine.append("-i'"+TTUsername+"':'"+TTPassword+"'")
			commandLine.append("-a"+":".join(Defects))
		if Writeable:
			commandLine.append("-w")
		if Update:
			commandLine.append("-u")
		elif Update==False:
			commandLine.append("-u-")
		if Remove:
			commandLine.append("-d")
		elif Remove==False:
			commandLine.append("-d-")
		if Changelist is not None:
			commandLine.append("-x'"+Changelist+"'")
		if StateID is not None:
			commandLine.append("-t'"+StateID+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def checkout(self,Files,Branch=None,Comment=None,Exclusive=False,Force=False,Repository=None,\
					Recursive=False,Timestamp=None,Version=None,Replace=None,Changelist=None):
		commandLine = ["sscm checkout"]
		if isinstance(Files,str):
			commandLine.append("'"+Files+"'")
		else:
			for aFile in Files : commandLine.append("'"+aFile+"'")
		
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if Comment is not None:
			commandLine.append("-cc'"+Comment+"'")
		else:
			commandLine.append("-c-")
		if Exclusive:
			commandLine.append("-e")
		if Force:
			commandLine.append("-f")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Recursive:
			commandLine.append("-r")
		if Timestamp is not None:
			commandLine.append("-t'"+str(TimeStamp)+"'")
		if Version is not None:
			commandLine.append("-v"+Version)
		if Replace is not None:
			commandLine.append("-w'"+str(Replace)+"'")
		if Changelist is not None:
			commandLine.append("-x'"+Changelist+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def cloak(self,Branch=None,Repository=None):
		commandLine = ["sscm cloak"]
		
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def commitchangelist(self,ListID,Mainline=None):
		commandLine = ["sscm commitchangelist"]
		commandLine.append(str(ListID))
		
		if Mainline is not None:
			commandLine.append("-p'"+Mainline+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def cpfile(self,Filename,DestinationBranch,Branch=None,Repository=None,Version=None,DestinationPath=None,Overwrite=False,Comment=None):
		commandLine = ["sscm cpfile"]
		
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		commandLine.append("'"+Filename+"'")
		if Version is not None:
			commandLine.append("-v'"+Version+"'")
		commandLine.append("'"+DestinationBranch+"'")
		if DestinationPath is not None:
			commandLine.append("-v'"+DestinationPath+"'")
		if Overwrite:
			commandLine.append("-o")
		if Comment is not None:
			commandLine.append("-cc'"+Comment+"'")
		else:
			commandLine.append("-c-")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def cruisecontrol(self,Item=None,Branch=None,Repository=None,DateTimeRange=None,Recursive=False,Case=False,RegExpression=False):
		commandLine = ["sscm cruisecontrol"]
		
		if Item is not None:
			commandLine.append("'"+Item+"'")
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if DateTimeRange is not None:
			commandLine.append("-d'"+DateTimeRange+"'")
		if Recursive:
			commandLine.append("-r")
		if Case:
			commandLine.append("-m")
		else:
			commandLine.append("-m-")
		if RegExpression:
			commandLine.append("-x")
		else:
			commandLine.append("-x-")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def dblock(self,Aquire=False,All=True,DbDirectoryName=None,MainlineBranchName=None):
		commandLine = ["sscm dblock"]
		
		if Aquire:
			commandLine.append("acquire")
		else:
			commandLine.append("release")
		if All:
			commandLine.append("-a")
		elif DbDirectoryName is not None:
			commandLine.append("-d'"+DbDirectoryName+"'")
		elif MainlineBranchName is not None:
			commandLine.append("-b'"+MainlineBranchName+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def diff(self,File,Branch1=None,Branch2=None,Repository=None,Integrated=SCMTriState.Empty,DiffUtility=None,CheckedOut=False,Version1=None,Version2=None):
		commandLine = ["sscm diff"]
		commandLine.append("'"+File+"'")
		
		if Branch1 is not None:
			if Branch2 is not None:
				commandLine.append("-b'"+Branch1+"':'"+Branch2+"'")
			else:
				commandLine.append("-b'"+Branch1+"'")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Integrated:
			commandLine.append("-i")
		elif Integrated==False:
			commandLine.append("-i-")
		if DiffUtility is not None:
			commandLine.append("-u'"+DiffUtility+"'")
		if CheckedOut:
			commandLine.append("-c")
		if Version1 is not None:
			if Version2 is not None:
				commandLine.append("-v'"+Version1+"':'"+Version2+"'")
			else:
				commandLine.append("-v'"+Version1+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def diffreport(self,File,Header=False,Branch=None,White=False,Case=False,Blanks=False,DiffType=SCMDiffType.Empty,Lines=None,\
					Output=None,Repository=None,Versions=None,IgnoreAllWhite=False,VersionDifference=False):
		commandLine = ["sscm diff"]
		commandLine.append("'"+File+"'")
		
		if Header:
			commandLine.append("-a")
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if White:
			commandLine.append("-c")
		if Case:
			commandLine.append("-i")
		if Blanks:
			commandLine.append("-k")
		if DiffType != SCMDiffType.Empty:
			commandLine.append("-l"+DiffType)
		if Lines is not None:
			commandLine.append("-n"+Lines)
		if Output is not None:
			commandLine.append("-o'"+Output+"'")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Versions is not None:
			commandLine.append("-v"+":".join(Versions))
		if IgnoreAllWhite:
			commandLine.append("-w")
		if VersionDifference:
			commandLine.append("-d")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def editchangelist(self,ListID,Maineline=None,FileMatch=None,Comment=None,ChangelistID=None,RemoveFiles=False):
		commandLine = ["sscm editchangelist"]
		commandLine.append(ListID)
		
		if Maineline is not None:
			commandLine.append("-p'"+Maineline+"'")
		if FileMatch is not None:
			commandLine.append("-f'"+FileMatch+"'")
		if Comment is not None:
			commandLine.append("-cc'"+Comment+"'")
		else:
			commandLine.append("-c-")
		if ChangelistID is not None:
			commandLine.append("-m'"+ChangelistID+"'")
		if RemoveFiles:
			commandLine.append("-r")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def editcustomfield(self,FieldID,FieldName=None,FieldCode=None,DefaultValue=None,MinValue=None,MaxValue=None,ListItems=None):
		commandLine = ["sscm editcustomfield"]
		commandLine.append(FieldID)
		
		if FieldName is not None:
			commandLine.append("-d'"+FieldName+"'")
		if FieldCode is not None:
			commandLine.append("-c'"+FieldCode+"'")
		if DefaultValue is not None:
			commandLine.append("-v'"+DefaultValue+"'")
		if ChangelistID is not None:
			commandLine.append("-m'"+ChangelistID+"'")
		if ListItems is not None:
			commandLine.append("-l'"+"','".join(ListItems)+"'")
		if MinValue is not None:
			commandLine.append("-n"+MinValue)
		if MaxValue is not None:
			commandLine.append("-m"+MaxValue)

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def editgroup(self,GroupName,Description=None,Note=None,EnableCommands=None,DisableCommands=None,EnableUsers=None,DisableUsers=None):
		commandLine = ["sscm editgroup"]
		commandLine.append("'"+GroupName+"'")
		
		if Description is not None:
			commandLine.append("-d'"+Description+"'")
		if Note is not None:
			commandLine.append("-n'"+Note+"'")
		if EnableCommands is not None or DisableCommands is not None:
			tempCommand = ""
			if EnableCommands is not None:
				for category, commands in EnableCommands.iteritems():
					if len(tempCommand) > 0:tempCommand = tempCommand+":"
					tempCommand = tempCommand+category+"+"+(":"+category+"+").join(commands)
			if DisableCommands is not None:
				for category, commands in DisableCommands.iteritems():
					if len(tempCommand) > 0:tempCommand = tempCommand+":"
					tempCommand = tempCommand+category+"-"+(":"+category+"-").join(commands)
			commandLine.append("-s"+tempCommand)
		if EnableUsers is not None or DisableUsers is not None:
			tempCommand = ""
			if EnableUsers is not None:
				tempCommand="+"+":+".join(EnableUsers)
			if DisableUsers is not None:
				if len(tempCommand) > 0:tempCommand = tempCommand+":"
				tempCommand="-"+":-".join(DisableUsers)
			commandLine.append("-u"+tempCommand)

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def editmailqueue(self,MessageID=None,ApplyAll=False,Resend=False,Delete=False):
		commandLine = ["sscm editmailqueue"]
		
		if MessageID is not None:
			commandLine.append(MessageID)
		if ApplyAll:
			commandLine.append("-a")
		if Resend:
			commandLine.append("-r")
		if Delete:
			commandLine.append("-d")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def editproxy(self,ProxyName,ProxyPasswd=None,ProxyAddr=None,ProxyPort=None,RefreshInterval=None,MinFileSize=None,MaxSpace=None,AgeLimit=None,\
					Frequency=None,Time=None,EncryptMaster=SCMTriState.Empty,EncryptClient=SCMTriState.Empty,Compress=SCMTriState.Empty,EnableUsers=None,DisableUsers=None):
		commandLine = ["sscm editproxy"]
		commandLine.append("'"+ProxyName+"'")
		
		if ProxyPasswd is not None:
			commandLine.append("-p'"+ProxyPasswd+"'")
		if ProxyAddr is not None:
			commandLine.append("-d'"+ProxyAddr+"'")
		if ProxyPort is not None:
			commandLine.append("-l'"+ProxyPort+"'")
		if RefreshInterval is not None:
			commandLine.append("-i'"+RefreshInterval+"'")
		if MinFileSize is not None:
			commandLine.append("-m'"+MinFileSize+"'")
		if MaxSpace is not None:
			commandLine.append("-s'"+MaxSpace+"'")
		if AgeLimit is not None:
			commandLine.append("-a'"+AgeLimit+"'")
		if Frequency is not None:
			if Frequency == SCMFrequency.EveryDay:
				commandLine.append("-cEveryDay")
			elif Frequency == SCMFrequency.EveryRefresh:
				commandLine.append("-cEveryRefresh")
			elif Frequency == SCMFrequency.DontCache:
				commandLine.append("-c-")
		if Time is not None:
			commandLine.append("-t'"+Time+"'")
		if EncryptMaster:
			commandLine.append("-n")
		elif EncryptMaster==False:
			commandLine.append("-n-")
		if EncryptClient:
			commandLine.append("-r")
		elif EncryptClient==False:
			commandLine.append("-r-")
		if Compress:
			commandLine.append("-o")
		elif Compress==False:
			commandLine.append("-o-")
		if EnableUsers is not None or DisableUsers is not None:
			tempCommand = ""
			if EnableUsers is not None:
				tempCommand="+"+":+".join(EnableUsers)
			if DisableUsers is not None:
				if len(tempCommand) > 0:tempCommand = tempCommand+":"
				tempCommand="-"+":-".join(DisableUsers)
			commandLine.append("-u"+tempCommand)

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def editshadow(self,RepositoryPath=None,Branch=None,Path=None,Force=False,Recursive=SCMTriState.Empty,EOL=None,Timestamp=None):
		commandLine = ["sscm editshadow"]
		if RepositoryPath is not None:
			commandLine.append("'"+RepositoryPath+"'")
		
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if Path is not None:
			commandLine.append("-l'"+Path+"'")
		if Force:
			commandLine.append("-f")
		if Recursive:
			commandLine.append("-r")
		elif Recursive==False:
			commandLine.append("-r-")
		if EOL is not None:
			commandLine.append("-w"+str(EOL))
		if Timestamp is not None:
			commandLine.append("-t"+str(Timestamp))

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def edituser(self,Username,CompanyName=None,CAddress=None,EmailType=SCMEmailType.Empty,EAddress=None,FirstName=None,\
				Licencestype=SCMLicencestype.Empty,NamedNumber=None,LastName=None,Initials=None,Note=None,PhoneType1=SCMPhonetype.Empty,Number1=None,PhoneType2=SCMPhonetype.Empty,\
				Number2=None,TTUsername=None,TTPassword=None,NewUsername=None,UserSCMPasswd=None):
		commandLine = ["sscm edituser"]
		commandLine.append("'"+Username+"'")
		
		if CompanyName is not None:
			if CAddress is not None:
				commandLine.append("-c'"+CompanyName+"':'"+CAddress+"'")
			else:
				commandLine.append("-c'"+CompanyName+"'")
		if EmailType !=SCMEmailType.Empty:
			if EAddress is not None:
				commandLine.append("-c"+EmailType+":'"+EAddress+"'")
			else:
				commandLine.append("-e"+EmailType)
		if FirstName is not None:
			commandLine.append("-f'"+FirstName+"'")
		if Licencestype != SCMLicencestype.Empty:
			if Licencestype == SCMLicencestype.Floating:
				commandLine.append("-ifloating")
			elif Licencestype == SCMLicencestype.Named:
				commandLine.append("-inamed:"+str(NamedNumber))
			else:
				commandLine.append("-inone")
		if LastName is not None:
			commandLine.append("-l'"+LastName+"'")
		if Initials is not None:
			commandLine.append("-m'"+Initials+"'")
		if Note is not None:
			commandLine.append("-n'"+Note+"'")
		if PhoneType1 !=SCMPhonetype.Empty and Number1 is not None:
			if PhoneType2 !=SCMPhonetype.Empty and Number2 is not None:
				commandLine.append("-p"+PhoneType1+":"+Number1+";"+PhoneType2+":"+Number2)
			else:
				commandLine.append("-p"+PhoneType1+":"+Number1)
		if TTUsername is not none:
			commandLine.append("-t'"+TTUsername+"':'"+TTPassword+"'")
		if NewUsername is not None:
			commandLine.append("-u'"+NewUsername+"'")
		if UserSCMPasswd is not None:
			commandLine.append("-w'"+UserSCMPasswd+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def fetchttdb(self,TTServerAddress,PortNum):
		commandLine = ["sscm fetchttdb"]
		commandLine.append("'"+TTServerAddress+"':"+str(PortNum))
		

		output = self.runSCM(commandLine)
		
		return [tuple(line.strip().split(None,1)) for line in output if not line.isspace()]

	def get(self,Items,Branch=None,LocalDir=None,Writeable=False,Force=False,Repository=None,Label=None,TimeStamp=None,\
			Version=None,Removed=False,DisplayVersion=False,Recursive=False,RetrievelTimestamp=SCMTimestamps.Empty,Replace=SCMReplace.Empty,StateID=None):

		commandLine = ["sscm get"]
		if isinstance(Items,str):
			commandLine.append("'"+Items+"'")
		else:
			for anItem in Items : commandLine.append("'"+anItem+"'")
		
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if LocalDir is not None:
			commandLine.append("-d'"+LocalDir+"'")
		if Writeable:
			commandLine.append("-e")
		if Force:
			commandLine.append("-f")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Label is not None:
			commandLine.append("-l'"+Label+"'")
		if TimeStamp is not None:
			commandLine.append("-s'"+str(TimeStamp)+"'")
		if Version is not None:
			commandLine.append("-v'"+Version+"'")
		if Removed:
			commandLine.append("-i")
		if DisplayVersion:
			commandLine.append("-j")
		if Recursive:
			commandLine.append("-r")
		if RetrievelTimestamp !=SCMTimestamps.Empty:
			commandLine.append("-t"+RetrievelTimestamp)
		if Replace !=SCMReplace.Empty:
			commandLine.append("-w"+Replace)
		if StateID is not None:
			commandLine.append("-a'"+str(StateID)+"'")
		
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def history(self,Item,Action=None,Branch=None,CustomField=SCMTriState.Empty,DateFrom=None,DateTo=None,ExpandToDepth=None,\
					Repository=None,Username=None,VersionFrom=None,VersionTo=None,Workflow=SCMTriState.Empty):
		commandLine = ["sscm history"]
		commandLine.append("'"+Item+"'")
		
		if Action is not None:
			commandLine.append("-a'"+Action+"'")
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if CustomField:
			commandLine.append("-c")
		elif CustomField==False:
			commandLine.append("-c-")
		if DateFrom is not None and DateTo is not None:
			commandLine.append("-d"+str(DateFrom)+":"+str(DateTo))
		if ExpandToDepth is not None:
			commandLine.append("-e'"+ExpandToDepth+"'")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Username is not None:
			commandLine.append("-u'"+Username+"'")
		if VersionFrom is not None and VersionTo is not None:
			commandLine.append("-v"+VersionFrom+":"+VersionTo)
		if Workflow:
			commandLine.append("-w")
		elif Workflow==False:
			commandLine.append("-w-")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def label(self,Items,Branch=None,Comment=None,Label=None,Replace=False,Repository=None,Recursive=False,Version=None):
		commandLine = ["sscm label"]
		if isinstance(Items,str):
			commandLine.append("'"+Items+"'")
		else:
			for anItem in Items : commandLine.append("'"+anItem+"'")
		
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if Comment is not None:
			commandLine.append("-cc'"+Comment+"'")
		else:
			commandLine.append("-c-")
		if Label is not None:
			commandLine.append("-l'"+Label+"'")
		if Replace:
			commandLine.append("-o")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Recursive:
			commandLine.append("-r")
		if Version is not None:
			commandLine.append("-v'"+Version+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def labeledfilesreport(self,Label,RepositoryPath=None,Branch=None,IncludeAll=False,Recursive=False,ReportFile=None):
		commandLine = ["sscm labeledfilesreport"]
		commandLine.append("'"+Label+"'")
		
		if RepositoryPath is not None:
			commandLine.append("-p'"+RepositoryPath+"'")
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if IncludeAll:
			commandLine.append("-i")
		if Recursive:
			commandLine.append("-r")
		if ReportFile is not None:
			commandLine.append("-o'"+ReportFile+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def ls(self,Item=None,Branch=None,FieldID=None,FieldValue=None,FilterName=None,Repository=None,Recursive=False,\
				EventText=None,EventType=None,LabelText=None,FilenameCase=False,CommentCase=False,LabelCase=False,\
				FilenameRegExp=False,CommentRegExp=False,LabelRegExp=False,CheckoutUser=None,DisplayWorking=False,Status=SCMStatus.Empty):
		commandLine = ["sscm ls"]
		if Item is not None:
			commandLine.append("'"+Item+"'")
		
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if FieldID is not None and FieldValue is not None:
			commandLine.append("-c"+FieldID+":'"+FieldValue+"'")
		if FilterName is not None:
			commandLine.append("-f'"+FilterName+"'")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Recursive:
			commandLine.append("-r")
		if EventText is not None:
			commandLine.append("-e'"+EventText+"'")
		if EventType is not None:
			commandLine.append("-a'"+EventType+"'")
		if LabelText is not None:
			commandLine.append("-l'"+LabelText+"'")
		if FilenameCase or CommentCase or LabelCase:
			commandLine.append("-m"+'F' if FilenameCase else ''+'E' if CommentCase else ''+'L' if LabelCase else '')
		if FilenameRegExp or CommentRegExp or LabelRegExp:
			commandLine.append("-x"+'F' if FilenameRegExp else ''+'E' if CommentRegExp else ''+'L' if LabelRegExp else '')
		if CheckoutUser is not None:
			commandLine.append("-u'"+CheckoutUser+"'")
		if DisplayWorking:
			commandLine.append("-w")
		if Status !=SCMStatus.Empty:
			commandLine.append("-s"+Status)

		output = self.runSCM(commandLine)
		currentRepo=""
		results={}
		for aLine in output:
			if not aLine.isspace():
				if not aLine[0].isspace():
					currentRepo=aLine.strip()
					results[currentRepo]=[]
				else:
					if aLine.startswith("           Total listed files: "):
						continue
					if not aLine.startswith("   -checked out by "):
						results[currentRepo].append(aLine[1:aLine.index("  ")].strip())
		return results

	def lsbranch(self,File=None,Repository=None,Removed=False,Workspace=False,DisplayAll=False):
		commandLine = ["sscm lsbranch"]
		
		if File is not None:
			commandLine.append("-f'"+File+"'")
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Removed:
			commandLine.append("-d")
		if Workspace:
			commandLine.append("-w")
		if DisplayAll:
			commandLine.append("-a")

		output = self.runSCM(commandLine)
		lines = [line.strip() for line in output if not line.isspace()]
		results={}
		for aLine in lines:
			tempData = aLine.split("(")
			results[tempData[0].strip()]=[data[:-1] for data in tempData[1:]]
		return results

	def lschangelist(self,Mainline=None,ListID=None,User=None,Page=None):
		commandLine = ["sscm lschangelist"]
		
		if Mainline is not None:
			commandLine.append("-p'"+Mainline+"'")
		if ListID is not None:
			commandLine.append(str(ListID))
		if User is not None:
			commandLine.append("-u'"+User+"'")
		if Page is not None:
			commandLine.append("-x"+str(Page))

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lscloak(self):
		commandLine = ["sscm lscloak"]
		
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lscustomfield(self,FieldID=None,Removed=False):
		commandLine = ["sscm lscustomfield"]
		
		if FieldID is not None:
			commandLine.append("'"+FieldID+"'")
		if Removed:
			commandLine.append("-r")
		
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lsdefect(self,TTConfigurationName,FilterID=None,TTUsername=None,TTPassword=None):
		commandLine = ["sscm lsdefect"]
		
		commandLine.append("'"+TTConfigurationName+"'")
		if FilterID is not None:
			commandLine.append("-f'"+FilterID+"'")
		if TTUsername is not None:
			if TTPassword is not None:
				commandLine.append("-l'"+TTUsername+"':'"+TTPassword+"'")
			else:
				commandLine.append("-l'"+TTUsername+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lsdefectfilter(self,TTConfigurationName,TTUsername=None,TTPassword=None):
		commandLine = ["sscm lsdefectfilter"]
		
		commandLine.append("'"+TTConfigurationName+"'")
		if TTUsername is not None:
			if TTPassword is not None:
				commandLine.append("-l'"+TTUsername+"':'"+TTPassword+"'")
			else:
				commandLine.append("-l'"+TTUsername+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lsfilter(self):
		commandLine = ["sscm lsfilter"]
		
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lsgroup(self,GroupName=None,Description=False,BranchRepo=None,Notes=False,AllCategories=False,Categories=None,Users=False):
		commandLine = ["sscm lsgroup"]
		if GroupName is not None:
			commandLine.append("'"+GroupName+"'")
		
		if Description:
			commandLine.append("-d")
		if Notes:
			commandLine.append("-n")
		if Users:
			commandLine.append("-u")
		if AllCategories:
			commandLine.append("-s")
		if BranchRepo is not None:
			for branch, repo in BranchRepo.iteritems():
				commandLine.append("-f'"+branch+"':'"+repo+"'")
		if Categories is not None:
			commandLine.append("-s"+":".join(Categories))
		output = self.runSCM(commandLine)

		lines = [line.strip() for line in output if not line.isspace()]
		results={}
		mode=0
		for aLine in lines:
			if aLine.startswith("Group name:"):
				currentGroup=aLine[11:].strip()
				results[currentGroup]={}
				mode=0
			elif aLine.startswith("Description:"):
				results[currentGroup]["Description"]=aLine[12:].strip()
			elif aLine.startswith("Note:"):
				results[currentGroup]["Note"]=aLine[5:].strip()
			elif aLine.startswith("Users:"):
				results[currentGroup]["Users"]=aLine[6:].strip()
			elif aLine.startswith("Command Category and its Enabled Commands:"):
				mode=1
			elif  mode==1:
				if aLine.find(":") != -1:
					tempData = aLine.split(":",1)
					currentCategory = tempData[0].strip()
					results[currentGroup][currentCategory] = tempData[1].strip()
				else:
					results[currentGroup][currentCategory] += aLine
			elif aLine.startswith("The group is using the following branch specific security settings"):
				mode=2
			elif mode==2:
				if aLine.startswith("Branch:"):
					branchName=aLine[7:].strip()
				elif aLine.startswith("Repository:"):
					repoName=aLine[11:].strip()
				elif aLine.startswith("Enabled Files Commands:"):
					commandList=aLine[23:].strip()
				else:
					commandList += aLine.strip()
			elif aLine.startswith("The group is using the security settings for all branches in the repository"):
				mode=3
			elif mode==3:
				if aLine.startswith("Repository:"):
					repoName=aLine[11:].strip()
				elif aLine.startswith("Enabled Files Commands:"):
					commandList=aLine[23:].strip()
				else:
					commandList += aLine.strip()
		return results

	def lsmailqueue(self):
		commandLine = ["sscm lsmailqueue"]

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lsmainline(self,Inactive=False):
		commandLine = ["sscm lsmainline"]
		
		if Inactive:
			commandLine.append("-i")
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lsproxy(self,ProxyName=None):
		commandLine = ["sscm lsproxy"]
		
		if ProxyName is not None:
			commandLine.append("'"+ProxyName+"'")
		
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lsreport(self):
		commandLine = ["sscm lsreport"]

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lsserverlog(self,Ascending=False,Field=None,Level=None,PageNumber=None,Size=None,Types=None):
		commandLine = ["sscm lsserverlog"]
		
		if Ascending:
			commandLine.append("-a")
		if Field is not None:
			commandLine.append("-f'"+Field+"'")
		if Level is not None:
			commandLine.append("-l'"+Level+"'")
		if PageNumber is not None:
			commandLine.append("-p'"+str(PageNumber)+"'")
		if Size is not None:
			commandLine.append("-s'"+str(Size)+"'")
		if Types is not None:
			commandLine.append("-t'"+str(Types)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lsshadow(self,Repository=None,Branch=None,All=False):
		commandLine = ["sscm lsshadow"]
		
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if All:
			commandLine.append("-a")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lsstate(self,Removed=False):
		commandLine = ["sscm lsstate"]
		
		if Removed:
			commandLine.append("-r")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lsttdb(self):
		commandLine = ["sscm lsttdb"]
		
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def lsuser(self,User=None,DisplayAll=False,Active=False,Company=False,Oldname=False,Email=False,Fullname=False,LicenceServer=False,\
			LicenceType=False,Notes=False,Phone=False,Group=False,TestTrack=False,WorkingDirectories=False):
		commandLine = ["sscm lsuser"]
		
		if User is not None:
			commandLine.append("'"+str(User)+"'")
		if DisplayAll:
			commandLine.append("-o")
		else:
			if Active:
				commandLine.append("-a")
			if Company:
				commandLine.append("-c")
			if Oldname:
				commandLine.append("-d")
			if Email:
				commandLine.append("-e")
			if Fullname:
				commandLine.append("-f")
			if LicenceServer:
				commandLine.append("-g")
			if LicenceType:
				commandLine.append("-i")
			if Notes:
				commandLine.append("-n")
			if Phone:
				commandLine.append("-p")
			if Group:
				commandLine.append("-s")
			if TestTrack:
				commandLine.append("-t")
			if WorkingDirectories:
				commandLine.append("-w")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def merge(self,File,TargetBranch=None,TargetRepository=None,MergeUtility=None,Version=None,UseGuiffy=True,SourceRepository=None,SourceBranch=None,SourceFile=None):
		commandLine = ["sscm merge"]
		
		commandLine.append("'"+File+"'")
		if TargetBranch is not None:
			commandLine.append("-b'"+str(TargetBranch)+"'")
		if TargetRepository is not None:
			commandLine.append("-p'"+str(TargetRepository)+"'")
		if MergeUtility is not None:
			commandLine.append("-u'"+str(MergeUtility)+"'")
		if Version is not None:
			commandLine.append("-v'"+str(Version)+"'")
		if Version is not None:
			commandLine.append("-v'"+str(Version)+"'")
		if UseGuiffy:
			commandLine.append("-i")
		elif MergeUtility is not None:
			commandLine.append("-i-")
		if SourceRepository is not None:
			commandLine.append("-r'"+str(SourceRepository)+"'")
		if SourceBranch is not None:
			commandLine.append("-s'"+str(SourceBranch)+"'")
		if SourceFile is not None:
			commandLine.append("-f'"+str(SourceFile)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def mkbranch(self,Branch,Repo,ParentBranch=None,Comment=None,CustomField=None,Label=None,BranchType=None,TimeStamp=None,Removed=False,StateID=None):
		commandLine = ["sscm mkbranch"]
		
		commandLine.append("'"+Branch+"'")
		commandLine.append("'"+Repo+"'")
		if ParentBranch is not None:
			commandLine.append("-b'"+str(ParentBranch)+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")
		if CustomField is not None:
			commandLine.append("-f'"+str(CustomField)+"'")
		if Label is not None:
			commandLine.append("-l'"+str(Label)+"'")
		if BranchType is not None:
			commandLine.append("-s'"+str(BranchType)+"'")
		if TimeStamp is not None:
			commandLine.append("-t'"+str(TimeStamp)+"'")
		if Removed:
			commandLine.append("-i")
		if StateID is not None:
			commandLine.append("-a'"+str(StateID)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def mkmainline(self,MainlineName,Comment=None,CaseSensitive=False,MainlineLoc=None):
		commandLine = ["sscm mkmainline"]
		
		commandLine.append("'"+MainlineName+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")
		if CaseSensitive:
			commandLine.append("-s")
		if MainlineLoc is not None:
			commandLine.append("-l'"+str(MainlineLoc)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def mkrepository(self,SubRepository,Branch=None,Comment=None,Repository=None,Changelist=None):
		commandLine = ["sscm mkrepository"]
		
		commandLine.append("'"+SubRepository+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Changelist is not None:
			commandLine.append("-x'"+str(Changelist)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def mkshadow(self,Path,Repository=None,Branch=None,Recursive=False,EOF=None,TimeStamp=None):
		commandLine = ["sscm mkshadow"]
		
		commandLine.append("'"+Path+"'")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Recursive:
			commandLine.append("-r")
		if Recursive:
			commandLine.append("-r")
		if EOF is not None:
			commandLine.append("-w'"+str(EOF)+"'")
		if TimeStamp is not None:
			commandLine.append("-w'"+str(TimeStamp)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def passwd(self,Username=None,OldPassword=None,NewPassword=None):
		commandLine = ["sscm passwd"]

#		if OldPassword is not None:
#			commandLine.append("-p'"+str(Repository)+"'")

	def promote(self,ChildBranch,Comment=None,Repository=None,AutoMerge=False,UpperBranch=None,Preview=False):
		commandLine = ["sscm promote"]
		
		commandLine.append("'"+ChildBranch+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if AutoMerge:
			commandLine.append("-s")
		if UpperBranch is not None:
			commandLine.append("-u'"+str(UpperBranch)+"'")
		if Preview:
			commandLine.append("-v")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def promotefile(self,Items,Branch=None,Comment=None,Repository=None,Recursive=False,AutoMerge=False,UpperBranch=None,Preview=False):
		commandLine = ["sscm promotefile"]
		
		if isinstance(Items,str):
			commandLine.append("'"+Items+"'")
		else:
			for anItem in Items : commandLine.append("'"+anItem+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Recursive:
			commandLine.append("-r")
		if AutoMerge:
			commandLine.append("-s")
		if UpperBranch is not None:
			commandLine.append("-u'"+str(UpperBranch)+"'")
		if Preview:
			commandLine.append("-v")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def property(self,Item,Branch=None,Removed=False,Keywords=None,ParentTT=False,CanOverrideTT=SCMTriState.Empty,TTDbConfigName=None,Attach=None,Repository=None,FileType=None):
		commandLine = ["sscm property"]
		
		commandLine.append("'"+Item+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Removed:
			commandLine.append("-d")
		if Keywords is not None:
			commandLine.append("-k'"+str(Keywords)+"'")
		if ParentTT:
			commandLine.append("-i")
		else:
			if CanOverrideTT:
				commandLine.append("-o")
			elif CanOverrideTT==False:
				commandLine.append("-o-")
			if TTDbConfigName is not None:
				commandLine.append("-s'"+str(TTDbConfigName)+"'")
			if Attach is not None:
				commandLine.append("-a"+str(Attach))
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if FileType is not None:
			commandLine.append("-t'"+str(FileType)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rebase(self,ChildBranch,SnapshotBranch=None,Comment=None,Label=None,Repository=None,AutoMerge=False,TimeStamp=None,Preview=False,StateID=None):
		commandLine = ["sscm rebase"]
		
		commandLine.append("'"+ChildBranch+"'")
		if SnapshotBranch is not None:
			commandLine.append("-b'"+str(SnapshotBranch)+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")
		if Label is not None:
			commandLine.append("-l'"+str(Label)+"'")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if AutoMerge:
			commandLine.append("-s")
		if TimeStamp is not None:
			commandLine.append("-t'"+str(TimeStamp)+"'")
		if Preview:
			commandLine.append("-v")
		if StateID is not None:
			commandLine.append("-a"+str(StateID))

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rebasefile(self,Items,Branch=None,Comment=None,Label=None,SnapshotBranch=None,Repository=None,\
					Recursive=False,AutoMerge=False,TimeStamp=None,Preview=False,StateID=None):
		commandLine = ["sscm rebasefile"]
		
		if isinstance(Items,str):
			commandLine.append("'"+Items+"'")
		else:
			for anItem in Items : commandLine.append("'"+anItem+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")
		if Label is not None:
			commandLine.append("-l'"+str(Label)+"'")
		if SnapshotBranch is not None:
			commandLine.append("-n'"+str(SnapshotBranch)+"'")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Recursive:
			commandLine.append("-r")
		if AutoMerge:
			commandLine.append("-s")
		if TimeStamp is not None:
			commandLine.append("-t'"+str(TimeStamp)+"'")
		if Preview:
			commandLine.append("-v")
		if StateID is not None:
			commandLine.append("-a"+str(StateID))

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rename(self,CurrentName,NewName,Repository=None,Branch=None,Comment=None,Changelist=None):
		commandLine = ["sscm rename"]
		
		commandLine.append("'"+CurrentName+"'")
		commandLine.append("'"+NewName+"'")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")
		if Changelist is not None:
			commandLine.append("-x'"+str(Changelist)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def renamebranch(self,CurrentName,NewName,BaseRepository=None,Comment=None):
		commandLine = ["sscm renamebranch"]
		
		commandLine.append("'"+CurrentName+"'")
		commandLine.append("'"+NewName+"'")
		if BaseRepository is not None:
			commandLine.append("-p'"+str(BaseRepository)+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def restore(self,Item,Branch=None,Comment=None,Repository=None,Recursive=False):
		commandLine = ["sscm renamebranch"]
		
		commandLine.append("'"+Item+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Recursive:
			commandLine.append("-v")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def restorebranch(self,BranchName,BaseRepository=None,UserName=None,UserID=None,Comment=None):
		commandLine = ["sscm restorebranch"]
		
		commandLine.append("'"+BranchName+"'")
		if BaseRepository is not None:
			commandLine.append("-p'"+str(BaseRepository)+"'")
		if UserName is not None:
			commandLine.append("-u'"+str(UserName)+"'")
		elif UserID is not None:
			commandLine.append("-i"+str(UserID))
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def retrieveuser(self,Usernames):
		commandLine = ["sscm retrieveuser"]
		
		if isinstance(Usernames,str):
			commandLine.append("'"+Usernames+"'")
		else:
			for anItem in Usernames : commandLine.append("'"+anItem+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rm(self,Item,Branch=None,Comment=None,Destroy=False,Force=False,Repository=None,Changelist=None):
		commandLine = ["sscm rm"]
		
		commandLine.append("'"+Item+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")
		if Destroy:
			commandLine.append("-d -q")
		if Force:
			commandLine.append("-f")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Changelist is not None:
			commandLine.append("-x'"+str(Changelist)+"'")
		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rmbranch(self,BranchName,Comment=None,Repository=None,Destroy=False,UserName=None,UserID=None):
		commandLine = ["sscm rmbranch"]
		
		commandLine.append("'"+BranchName+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Destroy:
			commandLine.append("-d")
		if UserName is not None:
			commandLine.append("-u'"+str(UserName)+"'")
		elif UserID is not None:
			commandLine.append("-i"+str(UserID))

		output = self.runSCM(commandLine, Destroy)
		return [line.strip() for line in output if not line.isspace()]

	def rmcustomfield(self,FieldID):
		commandLine = ["sscm rmcustomfield"]
		
		commandLine.append("'"+FieldID+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rmgroup(self,GroupName):
		commandLine = ["sscm rmgroup"]
		
		commandLine.append("'"+GroupName+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rmmainline(self,MainlineName,Comment=None):
		commandLine = ["sscm rmmainline"]
		
		commandLine.append("'"+MainlineName+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rmproxy(self,ProxyName):
		commandLine = ["sscm rmproxy"]
		
		commandLine.append("'"+ProxyName+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rmserverlog(self,DeleteAll=False,DateTime=None):
		commandLine = ["sscm rmserverlog"]
		
		if DeleteAll:
			commandLine.append("-a")
		else:
			commandLine.append("-t"+str(DateTime))

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rmshadow(self,RepositoryPath=None,Branch=None,RemoveAll=False,Path=None):
		commandLine = ["sscm rmshadow"]
		
		if RepositoryPath is not None:
			commandLine.append("'"+RepositoryPath+"'")
			if Branch is not None:
				commandLine.append("-b'"+str(Branch)+"'")
			if RemoveAll:
				commandLine.append("-a")
		else:
			commandLine.append("-l'"+str(Path)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rmttdb(self,TTConnectName):
		commandLine = ["sscm rmttdb"]
		
		commandLine.append("'"+TTConnectName+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rmuser(self,Username):
		commandLine = ["sscm rmuser"]
		
		commandLine.append("'"+Username+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rmworkdir(self,Repository=None,Branch=None,BranchID=None,Computer=None):
		commandLine = ["sscm rmworkdir"]
		
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		elif BranchID is not None:
			commandLine.append("-i"+str(BranchID))
		if Computer is not None:
			commandLine.append("-c'"+str(Computer)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def rollback(self,File,Branch=None,Comment=None,Repository=None,Version=None):
		commandLine = ["sscm rollback"]
		
		commandLine.append("'"+File+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Comment is not None:
			commandLine.append("-cc'"+str(Comment)+"'")
		else:
			commandLine.append("-c-")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Version is not None:
			commandLine.append("-v'"+str(Version)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def runreport(self,ReportID,OutputFile=None,Branch=None,Repository=None):
		commandLine = ["sscm runreport"]
		
		commandLine.append("'"+ReportID+"'")
		if OutputFile is not None:
			commandLine.append("-o'"+str(OutputFile)+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def securerepository(self,AddGroup=False,RemoveGroup=False,Branch=None,All=False,EnableCommands=None,DisableCommands=None,GroupName=None,Repository=None,Recursive=False):
		commandLine = ["sscm securerepository"]
		
		if AddGroup:
			commandLine.append("-a")
		elif RemoveGroup:
			commandLine.append("-a-")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		elif All:
			commandLine.append("-o")
		if EnableCommands is not None or DisableCommands is not None:
			if EnableCommands is not None:
				commandText = "-f+"+"+".join(EnableCommands)
			else:
				commandText="-f"
			if DisableCommands is not None:
				commandText = "-"+"-".join(DisableCommands)
			commandLine.append(commandText)
		if GroupName is not None:
			commandLine.append("-g'"+str(GroupName)+"'")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Recursive:
			commandLine.append("-r")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def servercheckforupdate(self,Check=False,ReleaseNotes=False):
		commandLine = ["sscm servercheckforupdate"]
		
		if Check:
			commandLine.append("-c")
		if ReleaseNotes:
			commandLine.append("-n")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def serveremailoption(self,MAPI=SCMTriState.Empty,PauseMAPI=SCMTriState.Empty,ProfileName=None,MAPIPassword=None,SMTP=SCMTriState.Empty,PauseSMTP=SCMTriState.Empty,\
							OnePer=SCMTriState.Empty,SMTPHost=None,Username=None,SMTPPassword=None,AlwaysUseNotificationAccount=SCMTriState.Empty,\
							Name=None,EmailAddress=None,FileLinkHostName=None):
		commandLine = ["sscm serveremailoption"]
		
		if MAPI:
			commandLine.append("-m")
		elif MAPI==False:
			commandLine.append("-m-")
		if PauseMAPI:
			commandLine.append("-x")
		elif PauseMAPI==False:
			commandLine.append("-x-")
		if ProfileName is not None:
			commandLine.append("-r'"+str(ProfileName)+"'")
		if MAPIPassword is not None:
			commandLine.append("-w'"+str(MAPIPassword)+"'")
		if SMTP:
			commandLine.append("-s")
		elif SMTP==False:
			commandLine.append("-s-")
		if PauseSMTP:
			commandLine.append("-v")
		elif PauseSMTP==False:
			commandLine.append("-v-")
		if OnePer:
			commandLine.append("-o")
		elif OnePer==False:
			commandLine.append("-o-")
		if SMTPHost is not None:
			commandLine.append("-t'"+str(SMTPHost)+"'")
		if Username is not None:
			commandLine.append("-u'"+str(Username)+"'")
		if SMTPPassword is not None:
			commandLine.append("-p'"+str(SMTPPassword)+"'")
		if AlwaysUseNotificationAccount:
			commandLine.append("-a")
		elif AlwaysUseNotificationAccount==False:
			commandLine.append("-a-")
		if Name is not None:
			commandLine.append("-n'"+str(Name)+"'")
		if EmailAddress is not None:
			commandLine.append("-e'"+str(EmailAddress)+"'")
		if FileLinkHostName is not None:
			commandLine.append("-f'"+str(FileLinkHostName)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def serverlogoption(self,Address=None,MAPIAddress=SCMEmailType.Empty,WriteAll=SCMTriState.Empty,SendLoginEmail=SCMTriState.Empty,\
						NTLogLevel=None,EmailLevel=None,SurroundLogLevel=None,LogService=SCMTriState.Empty):
		commandLine = ["sscm serverlogoption"]
		
		if Address is not None:
			commandLine.append("-e'"+str(Address)+"'")
		if MAPIAddress == SCMEmailType.MAPI:
			commandLine.append("-gm")
		elif MAPIAddress == SCMEmailType.Internet:
			commandLine.append("-gi")
		if WriteAll:
			commandLine.append("-f")
		elif WriteAll==False:
			commandLine.append("-f-")
		if SendLoginEmail:
			commandLine.append("-l")
		elif SendLoginEmail==False:
			commandLine.append("-l-")
		if NTLogLevel is not None:
			commandLine.append("-n'"+str(NTLogLevel)+"'")
		if EmailLevel is not None:
			commandLine.append("-o'"+str(EmailLevel)+"'")
		if SurroundLogLevel is not None:
			commandLine.append("-s'"+str(SurroundLogLevel)+"'")
		if LogService:
			commandLine.append("-w")
		elif LogService==False:
			commandLine.append("-w-")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def serveroption(self,RAM=None,Compress=SCMTriState.Empty,Encrypt=SCMTriState.Empty,CheckoutRequired=SCMTriState.Empty,Guiffy=SCMTriState.Empty,\
						Keywords=SCMTriState.Empty,LicenseServerAddr=None,LicenseServerPortNum=None,LicenseServerPassword=None,AllowMultiple=SCMTriState.Empty,MaxCommentLength=None,\
						CacheRefreshRate=None,EnableThumbnail=SCMTriState.Empty,ThumbWidth=None,ThumbHeight=None,SCMAdminPassword=None,\
						ChangelistUsage=SCMChangelist.Empty,KeepHistoricalChangelist=SCMTriState.Empty):
		commandLine = ["sscm serverlogoption"]
		
		if RAM is not None:
			commandLine.append("-a"+str(RAM))
		if Compress:
			commandLine.append("-c")
		elif Compress==False:
			commandLine.append("-c-")
		if Encrypt:
			commandLine.append("-e")
		elif Encrypt==False:
			commandLine.append("-e-")
		if CheckoutRequired:
			commandLine.append("-f")
		elif CheckoutRequired==False:
			commandLine.append("-f-")
		if Guiffy:
			commandLine.append("-g")
		elif Guiffy==False:
			commandLine.append("-g-")
		if Keywords:
			commandLine.append("-k")
		elif Keywords==False:
			commandLine.append("-k-")
		if LicenseServerAddr is not None and LicenseServerPortNum is not None:
			commandLine.append("-l'"+str(LicenseServerAddr)+"':"+str(LicenseServerPortNum))
		if AllowMultiple:
			commandLine.append("-m")
		elif AllowMultiple==False:
			commandLine.append("-m-")
		if LicenseServerPassword is not None:
			commandLine.append("-p'"+str(LicenseServerPassword)+"'")
		if MaxCommentLength is not None:
			commandLine.append("-r"+str(MaxCommentLength))
		if CacheRefreshRate is not None:
			commandLine.append("-s"+str(CacheRefreshRate))
		if EnableThumbnail:
			if ThumbWidth is not None and ThumbHeight is not None:
				commandLine.append("-t"+str(ThumbWidth)+":"+str(ThumbHeight))
			else:
				commandLine.append("-t")
		elif EnableThumbnail==False:
			commandLine.append("-t-")
		if SCMAdminPassword is not None:
			commandLine.append("-u"+str(SCMAdminPassword))
		if ChangelistUsage !=SCMChangelist.Empty:
			commandLine.append("-x"+ChangelistUsage)
		if KeepHistoricalChangelist:
			commandLine.append("-xh")
		elif KeepHistoricalChangelist==False:
			commandLine.append("-xh-")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def serverunicodeoption(self,Autodetect=SCMTriState.Empty,UTF8Merge=SCMTriState.Empty,UTF8Encoding=None,UTF16Encoding=None):
		commandLine = ["sscm serverunicodeoption"]
		
		if Autodetect:
			commandLine.append("-a")
		elif Autodetect==False:
			commandLine.append("-a-")
		if UTF8Merge:
			commandLine.append("-u")
		elif UTF8Merge==False:
			commandLine.append("-u-")
		if UTF8Encoding is not None:
			commandLine.append("-s'"+str(UTF8Encoding)+"'")
		if UTF16Encoding is not None:
			commandLine.append("-d'"+str(UTF16Encoding)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def serverupdatecheckoption(self,BetaEmail=SCMTriState.Empty,AutoCheck=SCMTriState.Empty,EmailAddress=None,MAPIAddress=SCMEmailType.Empty,Level=None,\
									ReturnEmailAddress=None,EmailNewRelease=SCMTriState.Empty,Time=None):
		commandLine = ["sscm serverupdatecheckoption"]
		
		if BetaEmail:
			commandLine.append("-b")
		elif BetaEmail==False:
			commandLine.append("-b-")
		if AutoCheck:
			commandLine.append("-c")
		elif AutoCheck==False:
			commandLine.append("-c-")
		if EmailAddress is not None:
			commandLine.append("-e'"+str(EmailAddress)+"'")
		if MAPIAddress == SCMEmailType.MAPI:
			commandLine.append("-gm")
		elif MAPIAddress == SCMEmailType.Internet:
			commandLine.append("-gi")
		if Level is not None:
			commandLine.append("-n"+str(Level))
		if ReturnEmailAddress is not None:
			commandLine.append("-r'"+str(ReturnEmailAddress)+"'")
		if EmailNewRelease:
			commandLine.append("-s")
		elif EmailNewRelease==False:
			commandLine.append("-s-")
		if Time is not None:
			commandLine.append("-t'"+str(Time)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def setclient(self,DiffUtility=None,MergeUtility=None,EOF=None,UseProxy=SCMTriState.Empty,Proxyname=None,\
					Compress=SCMTriState.Empty,Guiffy=SCMTriState.Empty,JavaPath=None,GuiffyPath=None,ComputerName=None,UpdateVersion=SCMTriState.Empty,\
					RemoveOnCheckin=SCMTriState.Empty,GuiffyRAM=None,ProxyCompress=SCMTriState.Empty):
		commandLine = ["sscm setclient"]
		
		if DiffUtility is not None:
			commandLine.append("-d'"+str(DiffUtility)+"'")
		if MergeUtility is not None:
			commandLine.append("-m'"+str(MergeUtility)+"'")
		if EOF is not None:
			commandLine.append("-w'"+str(EOF)+"'")
		if UseProxy:
			if Proxyname is not None:
				commandLine.append("-p'"+str(Proxyname)+"'")
		elif UseProxy==False:
			commandLine.append("-p-")
		if Compress:
			commandLine.append("-c")
		elif Compress==False:
			commandLine.append("-c-")
		if Guiffy:
			commandLine.append("-i")
		elif Guiffy==False:
			commandLine.append("-i-")
		if JavaPath is not None:
			commandLine.append("-j'"+str(JavaPath)+"'")
		if GuiffyPath is not None:
			commandLine.append("-g'"+str(GuiffyPath)+"'")
		if ComputerName is not None:
			commandLine.append("-o'"+str(ComputerName)+"'")
		else:
			commandLine.append("-o-")
		if UpdateVersion:
			commandLine.append("-u")
		elif UpdateVersion==False:
			commandLine.append("-u-")
		if RemoveOnCheckin:
			commandLine.append("-r")
		elif RemoveOnCheckin==False:
			commandLine.append("-r-")
		if GuiffyRAM is not None:
			commandLine.append("-a"+str(GuiffyRAM))
		if ProxyCompress:
			commandLine.append("-s")
		elif ProxyCompress==False:
			commandLine.append("-s-")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def setcustomfield(self,FileName,FieldID,Value,Branch=None,Repository=None):
		commandLine = ["sscm setcustomfield"]
		
		commandLine.append("'"+FileName+"'")
		commandLine.append(str(FieldID))
		commandLine.append("'"+str(Value)+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def setstate(self,Item,StateID,Branch=None,Repository=None,Recursive=False,Version=None,Comment=None):
		commandLine = ["sscm setstate"]
		
		commandLine.append("'"+Item+"'")
		commandLine.append(str(StateID))
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Recursive:
			commandLine.append("-r")
		if Version is not None:
			commandLine.append("-v'"+str(Version)+"'")
		if Comment is not None:
			commandLine.append("-cc'"+Comment+"'")
		else:
			commandLine.append("-c-")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def setttdb(self,TTConnectName,TTServerAddress,PortNum,TTProjectId,AddToSurround=False):
		commandLine = ["sscm setttdb"]
		
		commandLine.append("'"+TTConnectName+"'")
		commandLine.append("'"+str(TTServerAddress)+"':"+str(PortNum))
		commandLine.append(str(TTProjectId))
		if AddToSurround:
			commandLine.append("-i")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def share(self,SourceRepository,Files,Branch=None,Comment=None,DestinationRepository=None,Recursive=False):
		commandLine = ["sscm share"]
		
		commandLine.append("'"+SourceRepository+"'")
		for aFile in Files : commandLine.append("'"+aFile+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Comment is not None:
			commandLine.append("-cc'"+Comment+"'")
		else:
			commandLine.append("-c-")
		if DestinationRepository is not None:
			commandLine.append("-p'"+str(DestinationRepository)+"'")
		if Recursive:
			commandLine.append("-r")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def showworkdirs(self,Computer=None):
		commandLine = ["sscm showworkdirs"]
		
		if Computer is not None:
			commandLine.append("-m'"+str(Computer)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def uncheckout(self,Items,Branch=None,Replace=SCMReplace.Empty,Repository=None,Recursive=False):
		commandLine = ["sscm uncheckout"]
		
		if isinstance(Items,str):
			commandLine.append("'"+Items+"'")
		else:
			for anItem in Items : commandLine.append("'"+anItem+"'")
		if Branch is not None:
			commandLine.append("-b'"+Branch+"'")
		if Replace != SCMReplace.Empty:
			commandLine.append("-f"+Replace)
		if Repository is not None:
			commandLine.append("-p'"+Repository+"'")
		if Recursive:
			commandLine.append("-r")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def uncloak(self,Branch=None,Repository=None):
		commandLine = ["sscm uncloak"]
		
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def upgrademainline(self,MainlineBranch,Directory=False):
		commandLine = ["sscm upgrademainline"]
		
		commandLine.append("'"+MainlineBranch+"'")
		if MainlineBranch:
			commandLine.append("-d")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def version(self):
		commandLine = ["sscm version"]
		
		output = self.runSCM(commandLine)
		return [tuple(line.strip().split(":",1)) for line in output if not line.isspace()]		

	def voidcheckout(self,Username,Items,Branch=None,Repository=None,Recursive=False):
		commandLine = ["sscm voidcheckout"]
		
		commandLine.append("'"+Username+"'")
		if isinstance(Items,str):
			commandLine.append("'"+Items+"'")
		else:
			for anItem in Items : commandLine.append("'"+anItem+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Repository is not None:
			commandLine.append("-p'"+str(Repository)+"'")
		if Recursive:
			commandLine.append("-r")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def workdir(self,Directory,Repository,Branch=None,Inherit=False,Override=False):
		commandLine = ["sscm workdir"]
		
		commandLine.append("'"+Directory+"'")
		commandLine.append("'"+Repository+"'")
		if Branch is not None:
			commandLine.append("-b'"+str(Branch)+"'")
		if Inherit:
			commandLine.append("-r")
		if Override:
			commandLine.append("-o")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]

	def workdirinfo(self,Directory,Recursive=False):
		commandLine = ["sscm workdirinfo"]
		
		commandLine.append("'"+Directory+"'")
		if Recursive:
			commandLine.append("-r")

		output = self.runSCM(commandLine)
		return [line.strip() for line in output if not line.isspace()]
