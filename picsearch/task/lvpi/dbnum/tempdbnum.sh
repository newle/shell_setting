
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

rm -f tmpfile.txt
rm -f mailfile.txt


Port=12000
lvpiDB="find_ondb"
for((i=3;i<=10;i++)); do
	Machine=`printf "offsum%03d.pic.nm" $i`
	checkdb $Machine $Port $lvpiDB
done
updateAll $lvpiDB

mysql -h"10.134.71.142" -u lvpi -plvpi --database="picURLlibSta" < tmpfile.txt

if [ -s mailfile.txt ]; then
	php /search/wangzhen/tools/send_mail.php -s "线上数据库快满了" -m txt -B mailfile.txt -f "wangzhensi0487@sogou-inc.com" -n wangzhen -t "wangzhensi0487@sogou-inc.com"
fi
