location="Poznan"
while [ "$1" != "" ]; do
	case $1 in
		-l )  shift
			location=$1
		        ;;
		* )   usage
		      exit 1
      esac
      shift
done
echo `curl -X GET "https://api.apixu.com/v1/current.json?key=e8638be80de848e9ad062301171912&q=$location" > "/tmp/$location.json"`
