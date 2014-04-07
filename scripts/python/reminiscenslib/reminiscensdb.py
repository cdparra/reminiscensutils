import pymysql as dbapi
import sys
import configparser


class ReminiscensDB: 
	dburl = None
	dbschema = None
	dbport = None
	dbuser = None
	dbpass = None

	def __init__(self,config_file="reminiscens.conf"):
		# Reading of configuration parameters
		print("Using configuration from: "+config_file)
		config = configparser.RawConfigParser()
		config.read(config_file)

		# getfloat() raises an exception if the value is not a float
		# getint() and getboolean() also do this for their respective types
		self.dburl = config.get('DB Connection', 'url')
		self.dbschema = config.get('DB Connection', 'schema')
		self.dbport = config.getint('DB Connection', 'port')
		self.dbuser = config.get('DB Connection', 'user')
		self.dbpass = config.get('DB Connection', 'pass')

	def getConnection(self):
		return dbapi.connect(host=self.dburl,port=self.dbport,db=self.dbschema,user=self.dbuser,passwd=self.dbpass)
