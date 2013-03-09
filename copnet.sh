
if [ $# -eq 1 ]
then
	if [ $1 = "help" -o $1 = "man" ]
	then
		echo "==========================="
		echo "=================== get net"
		echo "==========================="
		echo "[wep/wpa] [ essid ] [ key ]"
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
  echo "1=$1"
  if [ $# -gt 1 ]; then
	if [ "$1" == "wep" ]; then
	  echo "connecting to public wep network"
	  echo "iwconfig wlan0 essid $2 key $3"
	  iwconfig wlan0 essid $2 key $3
	  connect_ok=1
    fi
	if [ "$1" == "wpa" ]; then
        echo "connecting to public wpa network"
        echo "wpa.conf file is $2"
		ip link set wlan0 up
		killall wpa_supplicant
		sleep 1
		wpa_supplicant -B Dwext -i wlan0 -c $2
		connect_ok=1
    fi
  elif [ $# -eq 1 ]; then
	if [ "$1" == "somename" ]; then
		echo "msg"
		echo "moar msg"
        ip link set wlan0 up
		killall wpa_supplicant
		sleep 1
		wpa_supplicant -B Dwext -i wlan0 -c /etc/wpa_supplicant-wut.conf
		connect_ok=1
	fi
  else
	echo "msg"
	iwconfig wlan0 essid apname key apkey
	sleep 2 
	connect_ok=1
  fi

  #connect
  echo "connect=$connect_ok"
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

