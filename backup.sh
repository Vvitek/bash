FILE_PATH=$HOME/.backup.lst
NEW_FILE=""

while [ "$1" != "" ]; do
	case $1 in
		-a ) shift
			if ! [ -f $FILE_PATH ] || ! [ `grep $1 $FILE_PATH` ]; then
				echo $1 >> $FILE_PATH
			fi
			;;
		-r ) shift
			if [ -f $FILE_PATH ] && [ `grep $1 $FILE_PATH` ]; then
				sed -i '' '/$1\$/d' $FILE_PATH
			fi
			;;
		* ) usage
			exit 1
	esac
	shift
done

