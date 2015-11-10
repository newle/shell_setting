
datestr=`date +%Y%m%d%H`"00";
total_record="0"
total_chunk_empty="0"
total_chunk_total="0"


function resetAll()
{
	total_record="0"
	total_chunk_empty="0"
	total_chunk_total="0"
}
function updateAll()
{
	lvpiDB=$1
	echo "replace INTO $lvpiDB( \`datetime\`, \`Machine\`, \`record_num\`,\`extend1\`,\`extend2\`) values(\"$datestr\",\"ALL\",\"$total_record\",\"$total_chunk_empty\",\"$total_chunk_total\");" >> tmpfile.txt
	resetAll
}


function checkdb()
{
	Machine=$1
	Port=$2
	lvpiDB=$3

	qdb_state $Machine $Port > .stat/qdb_state_$Machine"_"$Port
	if [ -s .stat/qdb_state_$Machine"_"$Port ]; then
		record_num=`grep "record_count" .stat/qdb_state_$Machine"_"$Port | awk -vFS=":" '{print $2}'`
		chunk_empty=`grep "chunk_empty" .stat/qdb_state_$Machine"_"$Port | awk -vFS=":" '{print $2}'`
		chunk_total=`grep "chunk_total" .stat/qdb_state_$Machine"_"$Port | awk -vFS=":" '{print $2}'`
		if [[ $chunk_empty -lt 10 ]]; then
			echo $Machine":"$Port"   空闲chunk:"$chunk_empty"   db空间快要满了" >> mailfile.txt
		fi
		if [[ $chunk_empty -eq 0 ]]; then
			echo $Machine":"$Port"    空闲chunk:"$chunk_empty"   db空间满了" >> mailfile.txt
		fi
	else
		record_num="0"
		chunk_empty="0"
		chunk_total="0"
	fi

	echo "replace INTO $lvpiDB( \`datetime\`, \`Machine\`, \`record_num\`,\`extend1\`,\`extend2\`) values(\"$datestr\",\"$Machine\",\"$record_num\",\"$chunk_empty\",\"$chunk_total\");" >> tmpfile.txt
	total_record=$((total_record + record_num))
	total_chunk_empty=$((total_chunk_empty + chunk_empty))
	total_chunk_total=$((total_chunk_total + chunk_total))
}

mv mailfile.txt lastmailfile.txt
> mailfile.txt
rm -f tmpfile.txt


Port=9000
lvpiDB="inst_ondb"
for((i=1;i<=128;i++)); do
	Machine=`printf "qs%03d.pic.sjs" $i`
	checkdb $Machine $Port $lvpiDB
done
updateAll $lvpiDB

Port=9001
lvpiDB="inst_offdb"
for((i=1;i<=128;i++)); do
	Machine=`printf "qs%03d.pic.sjs" $i`
	checkdb $Machine $Port $lvpiDB
done
updateAll $lvpiDB

Port=9010
lvpiDB="norm_ondb"
for((i=1;i<=128;i++)); do
	Machine=`printf "qs%03d.pic.sjs" $i`
	checkdb $Machine $Port $lvpiDB
done
updateAll $lvpiDB

Port=8010
lvpiDB="norm_doingdb"
for((i=1;i<=128;i++)); do
	#Machine=`printf "qs%03d.pic.sjs" $i`
	Machine=`printf "qs%03d.pic.sjs" $i`
	checkdb $Machine $Port $lvpiDB
done
updateAll $lvpiDB

Port=9010
lvpiDB="cbir_ondb"
for((i=1;i<=128;i++)); do
	Machine=`printf "qs%03d.cbir.sjs" $i`
	checkdb $Machine $Port $lvpiDB
done
updateAll $lvpiDB

Port=8020
lvpiDB="cbir_doingdb"
#for((i=1;i<=96;i++)); do
for((i=1;i<=128;i++)); do
	#Machine=`printf "qs%03d.cbir.sjs" $i`
	Machine=`printf "qstmp%03d.cbir.sjs" $i`
	checkdb $Machine $Port $lvpiDB
done
updateAll $lvpiDB

Port=9010
lvpiDB="stu_ondb"
for((i=1;i<=96;i++)); do
	Machine=`printf "qs%03d.ris.sjs" $i`
	checkdb $Machine $Port $lvpiDB
done
updateAll $lvpiDB

Port=8010
lvpiDB="stu_doingdb"
for((i=1;i<=96;i++)); do
	Machine=`printf "qs%03d.ris.sjs" $i`
	checkdb $Machine $Port $lvpiDB
done
updateAll $lvpiDB

Port=12000
lvpiDB="find_ondb"
for((i=3;i<=10;i++)); do
	Machine=`printf "offsum%03d.pic.nm" $i`
	checkdb $Machine $Port $lvpiDB
done
updateAll $lvpiDB

Port=30003
lvpiDB="shop_image_db"
#for((i=1;i<=8;i++)); do
#	Machine=`printf "gpu.four%02d.sjs" $i`
for((i=1;i<=100;i++)); do
	Machine=`printf "qstmp%03d.cbir.sjs" $i`
	checkdb $Machine $Port $lvpiDB
done
updateAll $lvpiDB

#Port=7020
Port=8888
lvpiDB="shop_image_db1"
for((i=1;i<=128;i++)); do
	Machine=`printf "qstmp%03d.cbir.sjs" $i`
	checkdb $Machine $Port $lvpiDB
done
#checkdb "gpu.four08.nm" $Port $lvpiDB
updateAll $lvpiDB

#Port=7020
Port=8010
lvpiDB="tmp_ondb"
for((i=1;i<=128;i++)); do
	Machine=`printf "qstmp%03d.cbir.sjs" $i`
	checkdb $Machine $Port $lvpiDB
done
#checkdb "gpu.four08.nm" $Port $lvpiDB
updateAll $lvpiDB

mysql -h"10.134.71.142" -u lvpi -plvpi --database="picURLlibSta" < tmpfile.txt


if [ -s mailfile.txt ]; then
    mailmd5=`md5sum mailfile.txt | awk '{print $1}'`
    if [ -s lastmailfile.txt ]; then
        lastmailmd5=`md5sum lastmailfile.txt | awk '{print $1}'`
        if [ $mailmd5 != $lastmailmd5 ]; then
	     php /search/wangzhen/tools/send_mail.php -s "线上数据库快满了" -m txt -B mailfile.txt -f "wangzhensi0487@sogou-inc.com" -n wangzhen -t "wangzhensi0487@sogou-inc.com"
        fi
    else
	     php /search/wangzhen/tools/send_mail.php -s "线上数据库快满了" -m txt -B mailfile.txt -f "wangzhensi0487@sogou-inc.com" -n wangzhen -t "wangzhensi0487@sogou-inc.com"
    fi
elif [ -s lastmailfile.txt ]; then
	php /search/wangzhen/tools/send_mail.php -s "线上数据库恢复了" -m txt -b "数据库都恢复了" -f "wangzhensi0487@sogou-inc.com" -n wangzhen -t "wangzhensi0487@sogou-inc.com"


fi

