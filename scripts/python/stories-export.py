# Simple story exporter that takes the CSV of all the stories of a user 
# and creates markdown files with the textual information and downloads
# all the pictures to a folder 
#
# Author: Cristhian Parra
import urllib
import csv
import os
import os.path
import sys, argparse, csv
import re

def download_picture(url,name):
    """
    download a picture from 'url' and save it to 'name'

    url = http://www.example.com/00000000.jpg
    path = ./pictures
    """
    image=urllib.URLopener()
    try:
    	image.retrieve(url,name) 
    except IOError, e:
    	print "Download ERROR" + str(e)


# command arguments
parser = argparse.ArgumentParser(description='download photos from URLs listed in csv',\
	fromfile_prefix_chars="@")
parser.add_argument('file', help='csv file with URLs', action='store')
parser.add_argument('dir', help='directory where pictures should be saved', action='store')
parser.add_argument('outtesto', help='output file for stories', type=argparse.FileType('w'),default=sys.stdout)
parser.add_argument('outmeta', help='output file for stories', type=argparse.FileType('w'),default=sys.stdout)
parser.add_argument('outfull', help='output file for stories with embedded pictures', type=argparse.FileType('w'),default=sys.stdout)
args = parser.parse_args()

# parse arguments
csv_file = args.file
picsdir = args.dir
storyout = args.outtesto
storydata = args.outmeta
storywithpics = args.outfull

with open(csv_file, 'rb') as csvfile:
	# configure dialect such that double quotes inside the text that are escaped by '/' will be ignored
	csv.register_dialect('reminiscens', delimiter=',', quotechar='"', doublequote=False, escapechar='\\')
	storyreader = csv.reader(csvfile, dialect='reminiscens')
	
	# TODO: support reading dynamic model of metadata
	# right now, using specifically structured csv for my current need 
	included_cols = [0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13]  

	storyidList = []

	for story in storyreader:
		content = list(story[i] for i in included_cols)
		
		# make sure of stripping surrounding whitespaces for all textual information 
		# that will be used to create folders and files
		storyid = content[0]	
		title = content[1].strip() 		
		text = content[2].strip()
		photoid = content[3]
		url = content[4].strip()
		picname = content[5].strip()
		year = content[6]
		month = content[7]
		day = content[8]
		country = content[9].strip()
		region = content[10].strip()
		city = content[11].strip()
		place = content[12].strip()

		try:
			storyidList.index(storyid) 
		except ValueError:
			storyidList.append(storyid)

			output = "## STORIA *("+storyid+") "+title+ "*\n\n"
			output+=" * Quando: **"+year
			if month > 0:
				output+="-"+month
			if day > 0:
				output+="-"+day

			output+="**\n"
			output += " * Dove: **"

			if place!="":
				output+=place+", "
			if city!="":
				output+=city+", "
			if region!="":
				output+=region+", "
			if country!="":
				output+=country+"**\n"

			# write metadata of the story in a file
			storydata.write(output+"\n\n")

			output+=text+"\n\n---"

			# write metadata plus text of the story in a file
			storyout.write(output+"\n\n")

		p = re.compile('http*') # pattern to test if the url is http

		print "Checking Download URL: "+url

		if p.match(url):
			storypath = storyid + "_" + title 
			dirpath = os.path.abspath(os.path.join(picsdir,storypath))
			if not os.path.exists(dirpath):
				os.makedirs(dirpath)

			path = os.path.join(dirpath,picname)

			# embed picture in the output markdown file with embedded pictures
			browserpath = "file://localhost"+path
			output += "** Foto # "+photoid+" **\n"
			output += "![]("+browserpath+")"
			storywithpics.write(output+"\n\n")

			# do not download twice
			if not os.path.exists(path):
				print "### Downloading picture ("+photoid+") "+picname+" of story ("+storyid+") '"+title+"'"
				download_picture(url,path)
			else: 
				print "Already downloaded picture ("+photoid+") "+picname+" of story ("+storyid+") '"+title+"'"

		else: 
			print "Story '"+title+"' has no valid URL associated"

storyout.close()
