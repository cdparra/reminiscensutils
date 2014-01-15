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
import reminiscenslib.utilities as rutil

# Main Program

# Command arguments
parser = argparse.ArgumentParser(description='download photos from URLs listed in csv',\
	fromfile_prefix_chars="@")
parser.add_argument('person_id', help='person id', action='store')
parser.add_argument('csvfile', help='output csv for stories')
parser.add_argument('--nopictures', help='skip pictures', action='store_true')
args = parser.parse_args()

# parse arguments
csv_file = args.csvfile
person_id = args.person_id
nopics = args.nopictures

with open(csv_file, 'w') as csvfile:
	# configure dialect such that double quotes inside the text that are escaped by '/' will be ignored
	csv.register_dialect('reminiscens', delimiter=',', quotechar='"', doublequote=False, escapechar='\\')
	storywriter = csv.writer(csvfile, dialect='reminiscens')

	if nopics:
		result = rutil.Utilities.getStoriesOfPerson(person_id)
		rutil.Utilities.writeResultsToCSV(result,storywriter)
	else:
		result = rutil.Utilities.getStoriesOfPersonWithMementos(person_id)
		rutil.Utilities.writeResultsToCSV(result,storywriter)