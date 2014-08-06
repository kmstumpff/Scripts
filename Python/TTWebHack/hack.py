import json
import urllib2

serverAddress = "http://localhost/cgi-bin/ttcgi.exe"

def send(req):
	f = urllib2.urlopen(req)
	res = json.loads(f.read())
	f.close()
	return res


attachJSON = json.dumps( {"requestType":"Logon","cookie":"","symmetricKey":"","serverName":"","userName":"Administrator","ssoChecked":False,"useExternalAuth":False,"externalCredentials":"","password":"","credentialsEncrypted":False} )
res = send(urllib2.Request(serverAddress, data=attachJSON, headers={'Content-Type': 'application/json'}))
print(json.dumps(res, sort_keys=True, indent=4))

attachJSON = json.dumps( {"requestType":"ProjectSelect","cookie":"","symmetricKey":"","serverName":"Default","userName":"Administrator","password":"","credentialsEncrypted":False,"ssoChecked":False,"useExternalAuth":False,"externalCredentials":"","databaseID":3,"projectListID":1,"forceLogout":False,"useTestTrackPro":True,"useTestTrackTCM":True,"useTestTrackRM":True,"useTestTrackRMReviewer":False} )
res = send(urllib2.Request(serverAddress, data=attachJSON, headers={'Content-Type': 'application/json'}))
print(json.dumps(res, sort_keys=True, indent=4))

cookie = res['cookie']

print("Cookie: " + cookie)

attachJSON = json.dumps( {"requestType":"GetSessionData","cookie":cookie,"symmetricKey":"","serverName":"Default","needAllUsers":True,"needAllUserGroups":True,"needProjectOptions":True,"needUserOptions":True,"needUserViews":True,"needRenamableFlds":True,"needMenuListItems":True,"needSecurityLists":True,"needTestConfigList":True,"needSubtypeList":True,"needLinkDefinitionList":True,"needStateDefinitionList":True,"needFolderTypeList":True,"needFolderList":True,"needStylesheets":True,"needObjectGenerationOptions":True,"needFieldStyleList":True} )
res = send(urllib2.Request(serverAddress, data=attachJSON, headers={'Content-Type': 'application/json'}))
print(json.dumps(res, sort_keys=True, indent=4))

attachJSON = json.dumps( {"requestType":"GetDashboard","cookie":cookie,"symmetricKey":"","serverName":"Default","json":{"pageNumber":1}} )
res = send(urllib2.Request(serverAddress, data=attachJSON, headers={'Content-Type': 'application/json'}))
print(json.dumps(res, sort_keys=True, indent=4))

attachJSON = json.dumps( {"requestType":"Logoff","cookie":cookie,"symmetricKey":"","serverName":"Default"} )
res = send(urllib2.Request(serverAddress, data=attachJSON, headers={'Content-Type': 'application/json'}))
print(json.dumps(res, sort_keys=True, indent=4))

