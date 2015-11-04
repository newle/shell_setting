#coding:gb18030

import sys


def getDataStatus(filename):
	f = open(filename, 'r')
	data = [line.strip() for line in f.readlines()]
	status = {}
	for line in data:
		(product, db, dbnum, empty_trunk) = line.split("\t")
		if product not in status:
			status[product] = {}
		status[product][db] = [dbnum, empty_trunk]

	return status

#���ڸ���״̬��db
#������Ʒ����db
newproduct = ""
newdb = ""

#�������
starttooslow = ""  #��0����̫С��ALL��10~10000֮��
startfromzero = "" #ǰ��Сʱ����Ϊ0�����Сʱ������0
resumefromdead = "" #ǰһСʱ����Ϊ0�� ǰ��Сʱ�����Сʱ��������
gotodead = ""     #ǰһСʱ��������0�����Сʱ����Ϊ0
leveldown = ""     #��������

#�ٶ����
rateupbig = ""  #���������ٶ����ϸ�Сʱ��2������
ratedownbig = ""  #���������ٶ����ϸ�Сʱ��1/2����

status1 = getDataStatus(sys.argv[1])
status2 = getDataStatus(sys.argv[2])
status3 = getDataStatus(sys.argv[3])

def checkdb(product, db):
	global status1
	global status2
	global status2
	global newproduct
	global newdb
	global starttooslow
	global startfromzero
	global resumefromdead
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

	dbnum_1 = int(status1[product][db][0])
	dbnum_2 = int(status2[product][db][0])
	dbnum_3 = int(status3[product][db][0])
	showstr = product + "\t" + db + "\t" + str(dbnum_1)  + "\t" + str(dbnum_2)  + "\t" + str(dbnum_3) + "\n"

	if db == "ALL" and dbnum_1 > 10 and dbnum_1 < 10000 and dbnum_2 == 0 and dbnum_3 == 0: 
		starttooslow += showstr + str(dbnum_1)
		return -3
	if dbnum_1 > 0 and dbnum_2 == 0 and dbnum_3 == 0: 
		startfromzero += showstr
		return 0
	if dbnum_1 > 0 and dbnum_2 == 0 and dbnum_3 > 0: 
		resumefromdead += showstr
		return -5
	if dbnum_1 == 0 and dbnum_2 > 0: 
		gotodead += showstr
		return -6
	if dbnum_1 < dbnum_2: 
		leveldown += showstr
		return -7

	rate1 = dbnum_1 - dbnum_2
	rate2 = dbnum_2 - dbnum_3
	if rate1 > rate2 and rate1 - rate2 > rate2:
		rateupbig = showstr
		return 0
	if rate1 < rate2 and rate2 - rate1 > rate1:
		ratedownbig = showstr
		return -9

	


for product in status1:
	if checkdb(product, "ALL") == 0:#һ���������Ͳ������������db��
		continue
	for db in status1[product]:
		#print product + "\t" + db + "\t" + status1[product][db][0] + "\t" + status1[product][db][1]
		#dbnum = status1[product][db][0]
		#empty_trunk = status1[product][db][1]
		if db != "ALL":
			checkdb(product, db)
	

def showout(title, showstr):
	if showstr != "":
		print title
		print showstr

showout("������Ʒ:", newproduct)
showout("��Ʒ����db:", newdb)
showout("�ٶ�̫��:", starttooslow)
showout("��ʼ����:", startfromzero)
showout("db�ָ�����:", resumefromdead)
showout("db����:", gotodead)
showout("db������:", leveldown)
showout("�ٶ�����2������:", rateupbig)
showout("�ٶȽ���2������:", ratedownbig)
			



