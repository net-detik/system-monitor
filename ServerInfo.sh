#/!bash

for row in $(cat /var/www/html/api/source/ConfigServerInfo.json | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }	
	if [ $(_jq '.type') = "ssh" ]; 
	then
		ssh -i$(_jq '.keygen') $(_jq '.user')@$(_jq '.ip') -p $(_jq '.port')  free > $(_jq '.fileNameMemory')
		ssh -i$(_jq '.keygen') $(_jq '.user')@$(_jq '.ip') -p $(_jq '.port')  df -h > $(_jq '.fileNameHardisk')
		ssh -i$(_jq '.keygen') $(_jq '.user')@$(_jq '.ip') -p $(_jq '.port')  uptime > $(_jq '.fileNameUptime')
		ssh -i$(_jq '.keygen') $(_jq '.user')@$(_jq '.ip') -p $(_jq '.port')  systemctl | grep running > $(_jq '.fileNameServiceStatus')
		
		if [ $(_jq '.fileNameMailStat') = "-" ]; 
		then
			echo "None SSH"
		else	
		 ssh -i$(_jq '.keygen') $(_jq '.user')@$(_jq '.ip') -p $(_jq '.port')  mailstat > $(_jq '.fileNameMailStat')
		fi
		
		if [ $(_jq '.fileNameMailq') = "-" ]; 
		then
			echo "None SSH"
		else	
		 ssh -i$(_jq '.keygen') $(_jq '.user')@$(_jq '.ip') -p $(_jq '.port')  mailq|grep ^[A-F0-9]|cut -c 42-80|sort |uniq -c|sort -n|tail > $(_jq '.fileNameMailq')
		fi
	else
		free > $(_jq '.fileNameMemory')
		df -h > $(_jq '.fileNameHardisk')
		uptime > $(_jq '.fileNameUptime')
		systemctl | grep running > $(_jq '.fileNameServiceStatus')
		if [ $(_jq '.fileNameMailStat') = "-"]; 
		then
			echo "None Local"
		else
			mailstat > $(_jq '.fileNameMailStat')
		fi
		
		if [ $(_jq '.fileNameMailq') = "-" ]; 
		then
			echo "None Local"
		else	
		 mailq|grep ^[A-F0-9]|cut -c 42-80|sort |uniq -c|sort -n|tail > $(_jq '.fileNameMailq')
		fi
	fi
done
