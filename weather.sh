LOCATION="Poznan"
NOW=`date +%s`
TIME_INTERVAL=`expr 5 \* 60`

while [ "$1" != "" ]; do
	case $1 in
		-l | -location )  shift
			LOCATION=$1
		        ;;
		-d ) shift
			DYNAMIC_UPDATE=true
			;;
		-f ) shift
			FORMAT=true
			;;
		* )   usage
		      exit 1
      esac
      shift
done

LAST_MODIFIED=`stat -f%m "/tmp/$LOCATION.json"`

if [ $(($LAST_MODIFIED + $TIME_INTERVAL)) -lt $NOW ]; then
	`curl -X GET "https://api.apixu.com/v1/current.json?key=APIKEY&q=$LOCATION" > "/tmp/$LOCATION.json"`
fi

while true; do
	`clear`
	if [ $FORMAT ]; then
		echo `cat "/tmp/$LOCATION.json" | jq .current | jq '{"temperature": .temp_c, "wind force": .wind_kph, "weather conditions": .condition.text}'`
	else
		echo `cat "/tmp/$LOCATION.json" | jq .current | jq '{"temperature": .temp_f, "wind force": .wind_mph, "weather conditions": .condition.text}'`
	fi

	if [ $DYNAMIC_UPDATE ]; then
		sleep $TIME_INTERVAL	
	else
		break
	fi
done
