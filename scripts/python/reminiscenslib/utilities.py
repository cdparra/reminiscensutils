# Class that contains queries for getting the stories of a person in reminiscens
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
import configparser
import reminiscenslib.reminiscensdb as remidb
import reminiscenslib.queries as remiq

class Utilities: 
	@staticmethod
	def getStoriesOfPerson(person_id):
		rdb = remidb.ReminiscensDB()
		db = rdb.getConnection()
		q = remiq.Queries.storiesOfPerson(person_id)
		cur=db.cursor()
		cur.execute(q)
		result=cur.fetchall()
		db.close()
		return result


	@staticmethod
	def getStoriesOfPersonWithMementos(person_id):
		rdb = remidb.ReminiscensDB()
		db = rdb.getConnection()
		q = remiq.Queries.storiesOfPersonWithMementos(person_id)
		cur=db.cursor()
		cur.execute(q)
		result=cur.fetchall()
		db.close()
		return result

		
	@staticmethod
	def writeResultsToCSV(results, file):
		for row in results:
			file.writerow(row)
