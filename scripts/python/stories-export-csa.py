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
	# Beware that when there are two many picture urs in a story, two erros might happen
	# 1. Latex's "Too many unprocessed floats" 
	# 2. Random URL's not being able to download
	print("Converting ", file.name, " to PDF...")
	out_file = file.name+".pdf"

	subprocess.call([
		"pandoc",
		"-V geometry:margin=1in",
		file.name,
		"-o",
		out_file,
		"--highlight-style=Zenburn",
		"--number-sections",
		"--latex-engine=xelatex"
		#,
		# Table of contents
	#	"--toc"
	])

def download_stories(person_id, url):
	print("*** TODO ***\n\n")

def print_avviso(file, person_name):
	avviso = "# Bozza del libro finale di Reminiscens per **"+person_name+"**\n"
	avviso += "Questa è una bozza del contenuto che sarebbe inserito nel tuo libro "
	avviso += "finale di reminiscens. Ti chiediamo gentilmente di fare un controllo "
	avviso += "completo e ti invitiamo a correggere dei problemi o errori che trovi "
	avviso += "attraverso la pagina web di reminiscens (base.reminiscens.me/ui), "
	avviso += "al massimo prima della mattina del **15/gennaio.** \n\n"
	avviso += "Se non riesci a correggere tutto per il 15/gennaio, ti chiediamo "
	avviso += "gentilmente di indicare ai ricercatori quali sono i problemi/errori da "
	avviso += "correggere tramite un'email a **cdparra@gmail.com**, oppure consegnando "
	avviso += "una copia di questa bozza con i commenti.\n\n"
	avviso += "Inoltre, ti chiediamo di **scegliere 3 o 4 storie preferite che saresti "
	avviso += "d'accordo ad includere in un libro finale generale che sarà consegnato al CSA.** "
	avviso += "Invia il numero e titolo di queste storie tramite email a **cdparra@gmail.com** "
	avviso += "prima del **19/gennaio.** \n\n"
	avviso += "Alcune Osservazioni: \n\n"
	avviso += "* Se hai già controllato e corretto tutto prima, no c'e bisogno di farlo di nuovo\n"
	avviso += "* Questa è solo una bozza per controllo, non è ancora impaginata come "
	avviso += "sarà nella versione finale (che certamente sarà molto più bella)\n"
	avviso += "* L'orientazione e dimensione delle foto saranno sistemate/ottimizzate "
	avviso += "nel libro finale. Le foto in questa bozza sono soltanto una anteprima con "
	avviso += "l'obiettivo di facilitare il controllo.\n\n"
	avviso += "* A causa di errori di sistema, e possibile che in alcune storie la 'domanda collegata' "
	avviso += "sia sbagliata. Non devi preoccuparti di questi errori, saranno sistemati automaticamente.\n\n"
	avviso += "* Una copia stampata della bozza sarà disponibile al CSA.\n\n"
	avviso += "Vi saluta cordialmente,\n Il team di Reminiscens\n\n\n"

	file.write(avviso)

# Main Program
# command arguments
parser = argparse.ArgumentParser(description='download photos from URLs listed in csv',\
	fromfile_prefix_chars="@")
parser.add_argument('file', help='csv file with URLs', action='store')
parser.add_argument('dir', help='directory where pictures should be saved', action='store')
parser.add_argument('outtesto', help='output file for stories', type=argparse.FileType('a', encoding='UTF-8'),default=sys.stdout)
parser.add_argument('outmeta', help='output file for stories', type=argparse.FileType('a', encoding='UTF-8'),default=sys.stdout)
parser.add_argument('outfull', help='output file for stories with embedded pictures', type=argparse.FileType('a', encoding='UTF-8'),default=sys.stdout)
parser.add_argument('person', help='name of the person', type=str)
parser.add_argument('--onlylocal', help='skip story processing and jumpt to pdf generations from output files', action='store_true')
parser.add_argument('--onlypdf', help='skip story processing and jumpt to pdf generations from output files', action='store_true')
args = parser.parse_args()

# parse arguments
csv_file = args.file
picsdir = args.dir
storyout = args.outtesto
storydata = args.outmeta
storywithpics = args.outfull
onlypdf = args.onlypdf
person_name = args.person
onlylocal = args.onlylocal


if onlypdf:
	convert_to_pdf(storyout)
	convert_to_pdf(storydata)
	convert_to_pdf(storywithpics)
	sys.exit("converted to pdf")
else: 
	storyout.truncate(0)
	storywithpics.truncate(0)
	storydata.truncate(0)

print_avviso(storyout,person_name)
print_avviso(storydata,person_name)
print_avviso(storywithpics,person_name)

# open csv file (resulting of a mysql export)
with open(csv_file, 'rt', encoding='iso-8859-1') as csvfile:
	# configure dialect such that double quotes inside the text that are escaped by '/' will be ignored
	csv.register_dialect('reminiscens', delimiter=',', quotechar='"', doublequote=False, escapechar='\\')
	storyreader = csv.reader(csvfile, dialect='reminiscens')
	
	# TODO: support reading dynamic model of metadata
	# right now, using specifically structured csv for my current need 
	included_cols = [0, 1, 2, 3, 4, 5, 6, 8, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]  

	storyidList = []

	for story in storyreader:
		content = list(story[i] for i in included_cols)
		
		# make sure of stripping surrounding whitespaces for all textual information 
		# that will be used to create folders and files
		personName = content[0]	
		storyid = content[1]	
		title = content[2].strip() 		
		text = content[3].strip()
		photoid = content[4]
		url = content[5].strip()
		picname = content[6].strip()
		year = content[8]
		month = content[9]
		day = content[10]
		country = content[11].strip()
		region = content[12].strip()
		city = content[13].strip()
		place = content[14].strip()
		fotohash = content[15].strip()
		qid = content[16]
		qtext= content[17].strip()
		pid = content[18]
		ptitle = content[19].strip()
		purl = content[20].strip()

		
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


			# title = re.sub('[\']', '\\\'', title.strip())

			output= "## STORIA *("+storyid+") di **"+personName+"** - "+title+ "*\n\n"
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
				output+=country

			output+="**\n"

			if (qid != 'N' and qid != None and qid != ''):
				print("--> Domanda collegata found: "+qid)
				output+="* **Domanda collegata:** *("+qid+") "+qtext+"*\n"
		
			if (pid != 'N' and pid != None and pid != ''):  
				print("--> Public Memento collegato found: "+pid)
				output+="* **Articolo di contesto collegato:** *("+pid+") "+ptitle+"*\n"
				output+="* **URL dell'Articolo di contesto collegato:** *("+purl+")*\n"

			output+="\n"

			# write metadata of the story in a file
			storydata.write(output+"\n\n")
			# text = re.sub('[\']', '\\\'', text.strip())
			output+=text+"\n\n"

			# write metadata plus text of the story in a file
			storyout.write(output)
			storywithpics.write(output)

		p = re.compile('http*') # pattern to test if the url is http

		print( "Checking Download URL: "+url)

		if p.match(url):

			# remove doublequotes (") and question marks (?) from the title of the story and the picture's name
			title = re.sub('["?]', '', title.strip())
			picname = re.sub('["?]', '', picname.strip())
			picname_for_markdown = re.sub('[)]', '\)', picname)
			storypath = personName + "-" + storyid + "_" + title 
			
			# Donwload LARGE picture for BOOK
			dirpath = os.path.abspath(os.path.join(picsdir,storypath))
			dirpath.strip()
			if not os.path.exists(dirpath):
				os.makedirs(dirpath)
			path = os.path.join(dirpath,picname)
			path.strip()

			# do not download twice
			if not os.path.exists(path):
				print( "### Downloading picture ("+photoid+") "+picname+" of story ("+storyid+") '"+title+"'")
				print( "### Copying in "+path+"###")
				download_picture(url,path)
			else: 
				print( "Already downloaded picture ("+photoid+") "+picname+" of story ("+storyid+") '"+title+"'")

			
			pic_small_url = "http://base.reminiscens.me/lifeapi/file/"+fotohash+"/SMALL"
			url = pic_small_url

			if onlylocal: 

				# Donwload SMALL picture for control DRAFT
				dirpath = "/Users/cristhian/Dropbox/research/projects/reminiscens/reminiscens-books/SMALLs"
				dirpath.strip()
				filename = fotohash+".jpg"
				if not os.path.exists(dirpath):
					os.makedirs(dirpath)
				path = os.path.join(dirpath,filename)
				path.strip()

				
				# do not download twice
				if not os.path.exists(path):
					print( "### Downloading SMALL picture ("+photoid+") "+picname+" with hash ("+fotohash+")")
					print( "### Copying in "+path+"###")
					download_picture(pic_small_url,path)
				else: 
					print( "Already downloaded picture ("+photoid+") "+picname+" of story ("+storyid+") '"+title+"'")

			# embed picture in the output markdown file with embedded pictures
			#browserpath = "file://localhost"+path
			#img = "** Foto # "+photoid+" **\n"
			#img += "<img src=\""+browserpath+"\" width=\"200\"/>"
			#storywithpics.write(img+"\n\n")
			print( "### Printing picture "+fotohash+" to "+storywithpics.name)

			if onlylocal:
				url = re.sub('[\s]', '\\ ', path)

			img = "![Foto "+photoid+" della storia "+storyid+"]("+url+")"
			storywithpics.write(img+"\n\n")

		else: 
			print( "Story '"+title+"' has no valid URL associated")

storyout.close()
storydata.close()
storywithpics.close()

convert_to_pdf(storyout)
convert_to_pdf(storydata)
convert_to_pdf(storywithpics)

