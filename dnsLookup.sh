for line in $(cat hostnames.txt)
do
	echo $line
	nslookup $line | tail -n +3 | grep Address
	echo
done
