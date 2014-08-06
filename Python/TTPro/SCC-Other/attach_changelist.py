import json
import urllib2

###############################################################################################
#
#	This script attaches a changelist (three files) to one issue, one test case, and one requirement
#
###############################################################################################
serverAddress = "http://localhost/cgi-bin/ttextpro.exe"
providerKey = '{79892515-4fec-49c6-9963-02a790ab8383}:{98e8c5ed-e0ed-4971-95a5-a1e209370fbc}'

# This attaches three files to issue 4
objType1 = 'issue'
objNumber1 = 4
# This attaches three files to test case 7
objType2 = 'test case'
objNumber2 = 7
# This attaches three files to requirement 8
objType3 = 'requirement'
objNumber3 = 8

###############################################################################################
action = "AddAttachment"
author = 'seapine'

filename1 = 'filename1.cpp'
filename2 = 'filename2.cpp'
filename3 = 'filename3.cpp'

###############################################################################################
attachJSON = json.dumps( {
  "providerKey" : providerKey,
  "attachmentList" : [
    {
      "attachmentMessage" : "Testing",
      "attachmentAuthor" : author,
      "branchName" : "myBranch",
      "commitHash" : "ThisIsTheCommitHash1234567890",
      "toAttachList" : [
         {
           "objectType" : objType1,
           "number" : objNumber1
         },
         {
           "objectType" : objType2,
           "number" : objNumber2
         },
         {
           "objectType" : objType3,
           "number" : objNumber3
         }
      ],
     "fileList" : [
         {
           "fileName" : filename1,
           "changeType" : "modified",
           "dataOneData" : "someData1",
           "dataTwoData" : "someData2"
         },
         {
           "fileName" : filename2,
           "changeType" : "modified",
           "dataOneData" : "someData1",
           "dataTwoData" : "someData2"
         },
         {
           "fileName" : filename3,
           "changeType" : "modified",
           "dataOneData" : "someData1",
           "dataTwoData" : "someData2"
         }
      ]
    }
  ]
} )

req = urllib2.Request(serverAddress + "?action=" + action, data=attachJSON, headers={'Content-Type': 'application/json'})

f = urllib2.urlopen(req)
res = json.loads(f.read())
f.close()

print(json.dumps(res))
