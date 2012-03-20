
if [ $# -eq 1 ]
then
	if [ $1 = "help" -o $1 = "man" ]
	then
		echo "=================="
		echo "========== get net"
		echo "=================="
		echo "[ essid ] [ key ]"
	fi
fi
connect_success=0
while [ $connect_success -eq 0 ]; 
do 
  #prepare
  killall dhcpcd # refresh
  ifconfig wlan0 down
  sleep 1
  ifconfig wlan0 up 
  iwconfig wlan0 mode managed

  #office or home public
  if [ $# -eq 2 ]; then
	echo "connecting to public network"
	echo "iwconfig wlan0 essid $1 key $2"
	iwconfig wlan0 essid $1 key $2
	connect_ok=1
  elif [ $# -eq 1 ]; then
	if [ "$1" == "cottage" ]; then
		echo "welcome home"
		echo "devices ready, prepare to connect..."
		ip link set wlan0 up
		killall wpa_supplicant
		sleep 1
		wpa_supplicant -B Dwext -i wlan0 -c /etc/wpa_supplicant.conf
		connect_ok=1
	fi
  else
	# office
	echo "start programming NOW"
	iwconfig wlan0 essid Line key 0000000000
	sleep 2 # trying to fix the first-attempt fail at the office
	connect_ok=1
  fi

  #connect
  if [ $connect_ok -eq 1 ]; then
	dhcpcd wlan0
	status=`echo $?`
	#echo "status is $status"
	if [ $status -eq 0 ]; then
		echo "connected successfuly"
		connect_success=1
	fi
  fi
done

