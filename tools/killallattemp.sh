wget "$1" -O /search/wangzhen/tools/attemp.home


> /search/wangzhen/tools/attemp.candidate
grep -o -P "taskdetails.jsp\?tipid=task_[^\"]+(?=\")" /search/wangzhen/tools/attemp.home | awk '{print "http://console01.dragon.hadoop.nm.sogou-op.org:50030/"$0}' | while read line; do
wget $line -O /search/wangzhen/tools/attemp.temp
attemp=`grep -o -P "(?<=attemptid=)attempt_[^\"]+" /search/wangzhen/tools/attemp.temp | tail -n 1`
echo $attemp >> /search/wangzhen/tools/attemp.candidate
done

while read line; do
	hadoop job -kill-task $line
done <  /search/wangzhen/tools/attemp.candidate


