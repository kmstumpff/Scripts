#!/usr/bin/env python

import sys
import os
import time
import socket
from pprint import pprint
from argparse import ArgumentParser

from minecraft_query import MinecraftQuery

def email():
	#print "Entered Email"
	cmd_string = """sendEmail -f stumpyballer10@yahoo.com -t 9374797493@vtext.com -s smtp.mail.yahoo.com -xu stumpyballer10@yahoo.com -xp stumpy10 -u "" -m "The server is down! \nPlease restart." """
	#print(cmd_string)
	os.system(cmd_string)
	return

def func_query():
    parser = ArgumentParser(description="Query status of Minecraft multiplayer server",
                            epilog="Exit status: 0 if the server can be reached, otherwise nonzero."
                           )
    parser.add_argument("host", help="target hostname")
    parser.add_argument("-q", "--quiet", action='store_true', default=True,
                        help='don\'t print anything, just check if the server is running')
    parser.add_argument("-p", "--port", type=int, default=25566,
                        help='UDP port of server\'s "query" service [25565]')
    parser.add_argument("-r", "--retries", type=int, default=2,
                        help='retry query at most this number of times [3]')
    parser.add_argument("-t", "--timeout", type=int, default=10,
                        help='retry timeout in seconds [10]')

    options = parser.parse_args()

    try:
        query = MinecraftQuery("mrjasper.co", options.port,
                               timeout=options.timeout,
                               retries=options.retries)
        server_data = query.get_rules()
    except socket.error as e:
        if not options.quiet:
            print "socket exception caught:", e.message
            print "Server is down or unreachable."
        print "Stopped : %s" % time.ctime()
	email()
        return 1

    if not options.quiet:
        print "Server response data:"
        pprint(server_data)
    return 0

def main():
	time.sleep(60)	
	while (True):
		rtn = func_query()
		if (rtn == 1):
			break
		else:
			print "Running : %s" % time.ctime()			
			time.sleep(60)


if __name__=="__main__":
    main()
