FILE_PATH=$HOME/.backup.lst
NEW_FILE=""

while [ "$1" != "" ]; do
	case $1 in
		-a ) shift
			if [ -f $FILE_PATH ] || `touch $FILE_PATH` ; then
				if ! [ `egrep $1$ $FILE_PATH` ]; then
					if [ `echo $1 | head -c 1` == "/" ]; then
						echo $1 >> $FILE_PATH
					else
						echo `pwd`"/$1" >> $FILE_PATH
					fi
				fi
			fi
			;;
		-r ) shift
			if [ -f $FILE_PATH ] && [ `grep $1$ $FILE_PATH` ]; then
				sed -i '' "/${1//\//\\/}$/d" $FILE_PATH
			elif [ -s $FILE_PATH ]; then
				`rm $FILE_PATH`
			fi
			;;
		-b ) shift
			NOW=`date "+%Y-%m-%d-%H-%M-%S"`
			echo `date "+%s"` >> .log
			for file in `cat $FILE_PATH`; do
				ssh $1 "mkdir -p $NOW/$file"
				`scp -r $file $1:$NOW/$file`
			done
			shift
			;;
		-u ) shift
                        NOW=`date "+%Y-%m-%d-%H-%M-%S"`
                        for file in `cat $FILE_PATH`; do
				if [ `cat .log | tail -1` -lt `stat -f%m $file` ]; then
                                	ssh $1 "mkdir -p $NOW/$file"
                                	`scp -r $file $1:$NOW/$file`
				fi
                        done
                        echo `date "+%s"` >> .log
			shift
                        ;;
		-h ) shift
			cat man.txt
			;;
		* ) usage
			exit 1
	esac
	shift
done

