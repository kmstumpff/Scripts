import json
import urllib2

###############################################################################################
#
#	This script attaches a file to one issue, one test case, and one requirement
#
###############################################################################################
serverAddress = "http://localhost/cgi-bin/ttextpro.exe"
providerKey = '{79892515-4fec-49c6-9963-02a790ab8383}:{310a9292-03d8-45c5-86f5-a0a4a15dfb70}'

# This attaches filename.cpp to issue 4
objType1 = 'issue'
objNumber1 = 4
# This attaches filename.cpp to test case 7
objType2 = 'test case'
objNumber2 = 7
# This attaches filename.cpp to requirement 8
objType3 = 'requirement'
objNumber3 = 8

###############################################################################################
action = "AddAttachment"
author = 'seapine'

filename = 'filename.cpp'

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
     "file" :
     {
        "fileName" : filename,
        "changeType" : "modified",
        "dataOneData" : "someData1",
        "dataTwoData" : "someData2"
     }
    }
  ]
} )

req = urllib2.Request(serverAddress + '?action=' + action, data=attachJSON, headers={'Content-Type': 'application/json'})

f = urllib2.urlopen(req)
res = json.loads(f.read())
f.close()

print(json.dumps(res))
