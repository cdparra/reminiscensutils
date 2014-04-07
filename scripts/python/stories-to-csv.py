# Simple story script to query storis from the DB of reminiscens and write them down into a CSV file#
# Author: Cristhian Parra
import urllib.request, urllib.parse, urllib.error
import csv
import os
import os.path
import sys, argparse, csv
import re
import subprocess
import time
import configparser
import codecs 
# import cStringIO
import reminiscenslib.utilities as rutil


# class UnicodeWriter:
#     """
#     A CSV writer which will write rows to CSV file "f",
#     which is encoded in the given encoding.
#     """

#     def __init__(self, f, dialect=csv.excel, encoding="utf-8", **kwds):
#         # Redirect output to a queue
#         self.queue = cStringIO.StringIO()
#         self.writer = csv.writer(self.queue, dialect=dialect, **kwds)
#         self.stream = f
#         self.encoder = codecs.getincrementalencoder(encoding)()

#     def writerow(self, row):
#         self.writer.writerow([s.encode("utf-8") for s in row])
#         # Fetch UTF-8 output from the queue ...
#         data = self.queue.getvalue()
#         data = data.decode("utf-8")
#         # ... and reencode it into the target encoding
#         data = self.encoder.encode(data)
#         # write to the target stream
#         self.stream.write(data)
#         # empty queue
#         self.queue.truncate(0)

#     def writerows(self, rows):
#         for row in rows:
#             self.writerow(row)


# Main Program

# Command arguments
parser = argparse.ArgumentParser(description='download photos from URLs listed in csv',\
	fromfile_prefix_chars="@")
parser.add_argument('person_id', help='person id', action='store')
parser.add_argument('csvfile', help='output csv for stories')
parser.add_argument('--nopictures', help='skip pictures', action='store_true')
parser.add_argument('--config', help='skip pictures', action='store')
args = parser.parse_args()

# parse arguments
csv_file = args.csvfile
person_id = args.person_id
nopics = args.nopictures
if args.config != None:
	config = args.config
else:
	config = "reminiscens.conf"

with open(csv_file, 'w', encoding='iso-8859-1') as csvfile:
	# configure dialect such that double quotes inside the text that are escaped by '/' will be ignored
	csv.register_dialect('reminiscens', delimiter=',', quotechar='"', doublequote=False, escapechar='\\', lineterminator="\n", quoting=csv.QUOTE_ALL)
	storywriter = csv.writer(csvfile, dialect='reminiscens')

	if nopics:
		result = rutil.Utilities.getStoriesOfPerson(person_id,config)
		rutil.Utilities.writeResultsToCSV(result,storywriter)
	else:
		result = rutil.Utilities.getStoriesOfPersonWithMementos(person_id,config)
		rutil.Utilities.writeResultsToCSV(result,storywriter)
