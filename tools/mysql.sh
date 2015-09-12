

if [ $# -eq 0 ]; then
	mysql -h"pic01.ss.mysql.db.sogou-op.org" -u chanpinyunying -pm6i1m2a3 --database="pic_tiny"
elif [ $1 = "zuoyebao" ]; then
	mysql -h"10.134.60.171" -u zuoyebao -pzuoyebao zuoyebao
elif [ $1 = "zuoyebao2" ]; then
	mysql -h"10.12.143.151" -u zuoyebao -pzuoyebao zuoyebao
elif [ $1 = "edu" ]; then
	mysql -hmysql01.edu.sjs -uedu -pEDU2014  edu
elif [ $1 = "edu2" ]; then
	mysql -hmysql02.edu.sjs -uedu -pEDU2014  edu
elif [ $1 = "lvpi" ]; then
	mysql -h"10.11.206.177" -u lvpi -plvpi picURLlibSta
elif [ $1 = "local" ]; then
	mysql -h"10.134.71.142" -u lvpi -plvpi picURLlibSta
elif [ $1 = "deadlink" ]; then
	mysql -h"10.11.215.156" -u web -pweb vs_pic_stats 
elif [ $1 = "umis" ]; then
	mysql -h"mysql01.ctc" -u pic_query_black -ppic_query_black ubs_spider 
elif [ $1 = "eduocr" ]; then
	mysql -h"10.134.249.21" -u edu -pedu edu 
fi


