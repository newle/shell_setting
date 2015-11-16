#!/bin/sh

export TERM=xterm-256color
export PS1="[\A \u@\h \W]$ "
export SVN_EDITOR=vim
export LIBXSLT_PLUGINS_PATH=/search/wangzhen/pa_trunk/explore_web_de/XsltTpl/.libs/
alias urlAnalysis='/search/wangzhen/script/dataAnalysis/urlDomainAnalysis '
alias urlDis='/search/wangzhen/script/dataAnalysis/urlDomainDistribute '
alias sortAnalysis='sh /search/wangzhen/script/dataAnalysis/sortAnalysis.sh '
alias urlType='sh /search/wangzhen/script/dataAnalysis/urltype.sh '
alias commentNormalize='/search/wangzhen/script/dataAnalysis/CommentUrlNormalize '
alias dbnetget='/search/wangzhen/tools/dbnetget -i url -o dd -df tpage-simple -d csum -l /search/wangzhen/tools/expoffsum9010list.txt '
alias dbnetAnalysis='sh /search/wangzhen/script/dataAnalysis/dbnetAnalysis.sh '
alias deldoc='sh /search/wangzhen/tools/deldoc.sh '
export JAVA_HOME=/usr/lib/jvm/java
alias dush="du -s * | sort -nk1 | awk '{if(\$1>1000000){print \$1/1000000\"G\t\"\$2}else if(\$1>1000){print \$1/1000\"M\t\"\$2}else{print \$1\"K\t\"\$2}}'"
alias rand='sh /search/wangzhen/tools/rand '
source /usr/bin/virtualenvwrapper.sh 

bind Space:magic-space
export EDITOR=vim

alias kk='sh /search/wangzhen/tools/kill.sh '


#if [ -f /etc/profile ]; then . /etc/profile; fi


