

dest=/tmp/dstlst

if [ $# -eq 1 ]; then
    cat $1 > $dest
elif [ $# -eq 2 ]; then
    awk -v e=$2 'NR<=e' $1 > $dest
elif [ $# -eq 3 ]; then
    awk -v s=$2 -v e=$3 'NR>=s&&NR<=e' $1 > $dest
fi

#cat $dest
/search/wangzhen/omnitty -T90 -f $dest
