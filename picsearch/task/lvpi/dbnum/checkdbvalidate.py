#coding:gb18030

import sys


def getDataStatus(filename):
	f = open(filename, 'r')
	data = [line.strip() for line in f.readlines()]
	status = {}
	for line in data:
		(product, db, dbnum, empty_chunk) = line.split("\t")
		if product not in status:
			status[product] = {}
		status[product][db] = [dbnum, empty_chunk]

	return status

#处于各种状态的db
#新增产品或者db
newproduct = ""
newdb = ""

#报警相关
littlechunk = ""  #db剩余chunk上次trunk多余10个，这次chunk少于10个
emptychunk = ""   #db剩余chunk上次大于0个，这次为0个

#总量相关
starttooslow = ""  #非0的量太小，ALL在10~10000之间
startfromzero = "" #前两小时总量为0，这个小时总量非0
resumefromdead = "" #前一小时总量为0， 前两小时和这个小时总量不空
deadlong = ""     #死了两小时了
gotodead = ""     #前一小时数据量非0，这个小时总量为0
leveldown = ""     #总量降低

#速度相关
rateupbig = ""  #数据增长速度是上个小时的2倍以上
ratedownbig = ""  #数据增长速度是上个小时的1/2以内

status1 = getDataStatus(sys.argv[1])
status2 = getDataStatus(sys.argv[2])
status3 = getDataStatus(sys.argv[3])

def checkdb(product, db):
	global status1
	global status2
	global status2
	global newproduct
	global newdb
	global littlechunk
	global emptychunk
	global starttooslow
	global startfromzero
	global resumefromdead
	global deadlong
	global gotodead
	global leveldown
	global rateupbig
	global ratedownbig
	showstr = product + "\t" + db + "\n"
	if product not in status2:
		newproduct += showstr
		return -1
	if db not in status2[product]:
		newdb += showstr
		return -2
	chunk_1 = int(status1[product][db][1])
	chunk_2 = int(status2[product][db][1])
	showstr = product + "\t" + db + "\t" + str(chunk_1)  + "\t" + str(chunk_2) + "\n"
	if chunk_1 == 0 and chunk_2 > 0:
		emptychunk += showstr
		return -3
	if chunk_1 <= 10 and chunk_2 > 10:
		littlechunk += showstr
		return -4


	dbnum_1 = int(status1[product][db][0])
	dbnum_2 = int(status2[product][db][0])
	dbnum_3 = int(status3[product][db][0])
	showstr = product + "\t" + db + "\t" + str(dbnum_1)  + "\t" + str(dbnum_2)  + "\t" + str(dbnum_3) + "\n"

	if db == "ALL" and dbnum_1 > 10 and dbnum_1 < 10000 and dbnum_2 == 0 and dbnum_3 == 0: 
		starttooslow += showstr
		return -5
	if dbnum_1 > 0 and dbnum_2 == 0 and dbnum_3 == 0: 
		startfromzero += showstr
		return 0
	if dbnum_1 > 0 and dbnum_2 == 0 and dbnum_3 > 0: 
		resumefromdead += showstr
		return -6
	if dbnum_1 == 0 and dbnum_2 == 0 and dbnum_3 > 0: 
		deadlong += showstr
		return -7
	if dbnum_1 == 0 and dbnum_2 > 0: 
		gotodead += showstr
		if db == "ALL":
			return 0
		return -8
	if dbnum_1 < dbnum_2: 
		leveldown += showstr
		return -9

	rate1 = dbnum_1 - dbnum_2
	rate2 = dbnum_2 - dbnum_3
	if rate1 > rate2 and rate1 - rate2 > rate2:
		rateupbig = showstr
		return 0
	if rate1 < rate2 and rate2 - rate1 > rate1:
		ratedownbig = showstr
		return -10

	return 0

	


for product in status1:
	if checkdb(product, "ALL") == 0:#一切正常，就不查相关其他的db了
		continue
	for db in status1[product]:
		#print product + "\t" + db + "\t" + status1[product][db][0] + "\t" + status1[product][db][1]
		#dbnum = status1[product][db][0]
		#empty_chunk = status1[product][db][1]
		if db != "ALL":
			checkdb(product, db)
	

def showout(title, showstr):
	if showstr != "":
		print title
		print showstr

showout("新增产品:", newproduct)
showout("产品新增db:", newdb)
showout("空间快耗尽的db:", littlechunk)
showout("没有空间的db:", emptychunk)
showout("速度太慢:", starttooslow)
showout("开始增加:", startfromzero)
showout("db恢复正常:", resumefromdead)
showout("db死透了:", deadlong)
showout("db死了:", gotodead)
showout("db量减少:", leveldown)
showout("速度增长2倍以上:", rateupbig)
showout("速度降低2倍以上:", ratedownbig)
			



