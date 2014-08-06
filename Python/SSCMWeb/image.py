###########################################
## This script logs in to the web server ##
## then creates 1000 bookmarks.          ##
##    - 333 Mainline                     ##
##    - 333 Repository                   ##
##    - 334 File                         ##
##                                       ##
## Created by Kyle Stumpff 7/10/2014     ##
###########################################
import cookielib, urllib, urllib2

#################################### Configuration ########################################
serverIPAddress = "192.168.101.100"   # IP Address of the test machine
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
# Mainline
try:
	for i in range(1,334):

		f = opener.open( webAddress + "/sscmweb/api/addBookmark?bookmark=%7B%22location%22:%22Mainline::Mainline%22,%22name%22:%22Mainline-Bookmark-" + str(i) + "%22,%22description%22:%22This-Bookmark-is-bookmark-" + str(i) + "%22,%22branch%22:%22Mainline%22,%22path%22:%22Mainline%22%7D")
		res = f.read()
		f.close()
except urllib2.URLError as e:
    print(e)
