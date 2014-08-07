###########################################
## This script logs in to the web server ##
## then deletes all bookmarks.           ##
##                                       ##
## Created by Kyle Stumpff 7/10/2014     ##
###########################################
import cookielib, urllib, urllib2, json

#################################### Configuration ########################################
serverIPAddress = "192.168.101.144"   # IP Address of the test machine
httpPort = '8090'                     # Port for http access
wUsername = 'Administrator'           # SCM Username
wPassword = ''                        # SCM PAssword

#################################### Do not change anything below this line ####################################
#################################### Get First Cookie (Not logged in) ########################################
webAddress = "http://" + serverIPAddress + ":" + httpPort

cj = cookielib.CookieJar()
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
opener.addheaders = [('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36'),]

stylesheets = [
    webAddress + '/sscmweb/static/css/main.css',
]
try:
	opener.open(webAddress + '/sscmweb')
except urllib2.URLError as e:
    print(e)
sessid = cj._cookies[serverIPAddress]['/sscmweb/']['JSESSIONID'].value
opener.addheaders += [
    ('Referer', webAddress + '/sscmweb/'),
    ]
for st in stylesheets:
    # da trick
	try:
		opener.open(st+'?jsessionid='+sessid)
	except urllib2.URLError as e:
		print(e)
try:
	opener.open(webAddress + '/sscmweb/')
except urllib2.URLError as e:
    print(e)

JSESSIONID = cj._cookies[serverIPAddress]['/sscmweb/']['JSESSIONID'].value

#################################### Login ########################################
securityAddress = webAddress + '/sscmweb/j_spring_security_check'
attachData = urllib.urlencode( {
    'j_username' : wUsername,
    'j_password' : wPassword,
    'url-forward' : '',
    'ajax' : 'true'
} )
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
opener.addheaders.append(('Host', serverIPAddress))
opener.addheaders.append(('Connection', 'keep-alive'))
opener.addheaders.append(('Content-Type', 'application/x-www-form-urlencoded, charset=UTF-8'))
opener.addheaders.append(('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36'))
opener.addheaders.append(('Referer', webAddress + '/sscmweb/'))
opener.addheaders.append(('Accept-Encoding', 'gzip,deflate,sdch'))
opener.addheaders.append(('Accept-Language', 'en-US,en;q=0.8'))

try:
	f = opener.open( securityAddress,attachData )
	res = f.read()
	f.close()
except urllib2.URLError as e:
    print(e)
JSESSIONID = cj._cookies[serverIPAddress]['/sscmweb/']['JSESSIONID'].value

#################################### Add Bookmarks ########################################
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
opener.addheaders.append(('Host', serverIPAddress))
opener.addheaders.append(('Connection', 'keep-alive'))
opener.addheaders.append(('Accept', 'application/json, text/plain, */*'))
opener.addheaders.append(('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36'))
opener.addheaders.append(('Referer', webAddress + '/sscmweb/'))
opener.addheaders.append(('Accept-Encoding', 'gzip,deflate,sdch'))
opener.addheaders.append(('Accept-Language', 'en-US,en;q=0.8'))
# List all bookmarks
try:
	f = opener.open( webAddress + "/sscmweb/api/listBookmarks")
	bookmarkList = json.loads(f.read())
	f.close()
except urllib2.URLError as e:
    print(e)
# Delete each bookmark
try:
	for bookmark in bookmarkList:
#		print json.dumps(bookmark['id'])
		f = opener.open( webAddress + "/sscmweb/api/deleteBookmark?id="+ bookmark['id'])
		res = f.read()
		f.close()
except urllib2.URLError as e:
	print(e)
# Logout
try:
	f = opener.open( webAddress + "/sscmweb/logout")
	res = f.read()
	f.close()
except urllib2.URLError as e:
	print(e)
