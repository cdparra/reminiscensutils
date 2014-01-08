# Simple story exporter that takes the CSV of all the stories of a user in reminiscens
# and creates markdown files with the textual information and downloads
# all the pictures to a folder 
#
# Author: Cristhian Parra
import urllib.request, urllib.parse, urllib.error
import csv
import os
import os.path
import sys, argparse, csv
import re
import subprocess
import time

def download_picture(url,name):
    """
    download a picture from 'url' and save it to 'name'

    url = http://www.example.com/00000000.jpg
    path = ./pictures
    """
    image=urllib.request.URLopener()
    try:
    	image.retrieve(url,name) 
    except IOError as e:
    	print( "Download ERROR" + str(e))

def convert_to_pdf(file): 
	print("Converting ", file.name, " to PDF...")
	out_file = file.name+".pdf"
	subprocess.call([
		"pandoc",
		file.name,
		"-o",
		out_file,
		"--highlight-style=Zenburn",
		"--number-sections",
		# Table of contents
		"--toc"
	])

def download_stories(person_id, url):
	print("*** TODO ***\n\n")



# Main Program
# command arguments
parser = argparse.ArgumentParser(description='download photos from URLs listed in csv',\
	fromfile_prefix_chars="@")
parser.add_argument('file', help='csv file with URLs', action='store')
parser.add_argument('dir', help='directory where pictures should be saved', action='store')
parser.add_argument('outtesto', help='output file for stories', type=argparse.FileType('w', encoding='UTF-8'),default=sys.stdout)
parser.add_argument('outmeta', help='output file for stories', type=argparse.FileType('w', encoding='UTF-8'),default=sys.stdout)
parser.add_argument('outfull', help='output file for stories with embedded pictures', type=argparse.FileType('w', encoding='UTF-8'),default=sys.stdout)
args = parser.parse_args()

# parse arguments
csv_file = args.file
picsdir = args.dir
storyout = args.outtesto
storydata = args.outmeta
storywithpics = args.outfull

# open csv file (resulting of a mysql export)
with open(csv_file, 'rt', encoding='iso-8859-1') as csvfile:
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
		
		#print("storyid = ",content[0],"\n")
		#print("title = ",content[1].strip(),"\n")
		#print("text = ",content[2].strip(),"\n")
		#print("photoid = ",content[3],"\n")
		#print("url = ",content[4].strip(),"\n")
		#print("picname = ",content[5].strip(),"\n")
		#print("year = ",content[6],"\n")
		#print("month = ",content[7],"\n")
		#print("day = ",content[8],"\n")
		#print("country = ",content[9].strip(),"\n")
		#print("region = ",content[10].strip(),"\n")
		#print("city = ",content[11].strip(),"\n")
		#print("place = ",content[12].strip(),"\n")

		# process the text of the story only once and ignore in the following lines
		try:
			storyidList.index(storyid) 
		except ValueError:
			storyidList.append(storyid)

			output = "## STORIA *("+storyid+") "+title+ "*\n\n"
			output+=" * Quando: **"+year
			if int(month) > 0:
				output+="-"+month
			if int(day) > 0:
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
			storywithpics.write(output+"\n\n")

		p = re.compile('http*') # pattern to test if the url is http

		print( "Checking Download URL: "+url)

		if p.match(url):

			# remove doublequotes (") and question marks (?) from the title of the story and the picture's name
			title = re.sub('["?]', '', title.strip())
			picname = re.sub('["?]', '', picname.strip())
			picname_for_markdown = re.sub('[)]', '\)', picname)
			storypath = storyid + "_" + title 
			
			dirpath = os.path.abspath(os.path.join(picsdir,storypath))
			dirpath.strip()
			if not os.path.exists(dirpath):
				os.makedirs(dirpath)
			path = os.path.join(dirpath,picname)
			path.strip()

			# embed picture in the output markdown file with embedded pictures
			#browserpath = "file://localhost"+path
			#img = "** Foto # "+photoid+" **\n"
			#img += "<img src=\""+browserpath+"\" width=\"200\"/>"
			#storywithpics.write(img+"\n\n")
			pic_small_url = "http://base.reminiscens.me/files/SMALL_"+picname_for_markdown
			img = "** Foto # "+photoid+" **\n"
			img += "![]("+pic_small_url+")"
			storywithpics.write(img+"\n\n")

			# do not download twice
			if not os.path.exists(path):
				print( "### Downloading picture ("+photoid+") "+picname+" of story ("+storyid+") '"+title+"'")
				print( "### Copying in "+path+"###")
				download_picture(url,path)
			else: 
				print( "Already downloaded picture ("+photoid+") "+picname+" of story ("+storyid+") '"+title+"'")

		else: 
			print( "Story '"+title+"' has no valid URL associated")

convert_to_pdf(storyout)
convert_to_pdf(storydata)
convert_to_pdf(storywithpics)

storyout.close()
storydata.close()
storywithpics.close()
