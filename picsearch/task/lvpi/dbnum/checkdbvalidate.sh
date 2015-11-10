

####   保留处理的log
datestr_1=`date -d "-1 hours" +%Y%m%d%H`"00";
datestr_2=`date -d "-2 hours" +%Y%m%d%H`"00";
datestr_3=`date -d "-3 hours" +%Y%m%d%H`"00";
datestr_4=`date -d "-4 hours" +%Y%m%d%H`"00";
datestr_5=`date -d "-5 hours" +%Y%m%d%H`"00";
datestr_rm=`date -d "-10 hours" +%Y%m%d%H`"00";
tmpfile1="tmpfile"$datestr_1".txt"
tmpfile2="tmpfile"$datestr_2".txt"
tmpfile3="tmpfile"$datestr_3".txt"
tmpfile4="tmpfile"$datestr_4".txt"
tmpfile5="tmpfile"$datestr_5".txt"
tmpfile_rm="tmpfile"$datestr_rm".txt"
n_tmpfile1="n_tmpfile"$datestr_1".txt"
n_tmpfile2="n_tmpfile"$datestr_2".txt"
n_tmpfile3="n_tmpfile"$datestr_3".txt"
n_tmpfile4="n_tmpfile"$datestr_4".txt"
n_tmpfile5="n_tmpfile"$datestr_5".txt"
n_tmpfile_rm="n_tmpfile"$datestr_rm".txt"

if [ ! -s $tmpfile1 ]; then
	mv tmpfile.txt $tmpfile1
fi

rm -f $tmpfile_rm
rm -f $n_tmpfile_rm

####   得到数组
function normalize()
{
	file=$1
	newfile=$2
	if [ -s $file ]; then
		awk -vFS=" |," '{print $3"\t"$12"\t"$13"\t"$14}' $file  | sed 's/"//'g | sed 's/(//'g > $newfile
	fi
}

normalize $tmpfile1 $n_tmpfile1
normalize $tmpfile2 $n_tmpfile2
normalize $tmpfile3 $n_tmpfile3
normalize $tmpfile4 $n_tmpfile4
normalize $tmpfile5 $n_tmpfile5

python checkdbvalidate.py $n_tmpfile1 $n_tmpfile2 $n_tmpfile3 > checkdbvalidate.log 2>&1 

if [ -s checkdbvalidate.log ]; then
	php /search/wangzhen/tools/send_mail.php -s "线上数据库状态变化" -m txt -B checkdbvalidate.log -f "wangzhensi0487@sogou-inc.com" -n wangzhen -t "wangzhensi0487@sogou-inc.com"
fi



