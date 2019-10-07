for line in $(cat $1)
do
	echo $line
	nslookup $line | tail -n +3 | grep Address
	echo
done
