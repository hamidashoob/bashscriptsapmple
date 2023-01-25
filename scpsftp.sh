#! /bin/bash 
function valid_ip() 
{ 
    local  ip=$1 
    local  stat=1 
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then 
        OIFS=$IFS 
        IFS='.' 
        ip=($ip) 
        IFS=$OIFS 
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]] 
        stat=$? 
    fi 
    return $stat 
} 
#printf "%-20s: %s\n" "$ip" "$stat" 
function iscp() 
{ 
        local LPATH=$1 
        local USER=$2 
        local RIP=$3 
        local RPATH=$4 
        scp $LPATH $USER@$RIP:$RPATH 
} 

while [ -n "$1" ] 
do 
case "$1" in 
-i)     echo "use Authorized_key for scp" 
        echo "---------------------------" 
        read -p  "please enter path local: " LPATH 
        read -p "please enter remote user: " RUSER 
        while [ -z $IP ] 
        do 
                read -p "please enter remote ip: " IP 
                if valid_ip $IP 
                then 
                        ping -c 1 $IP >> /dev/null 
                        if [ $? -eq 0 ] 
                        then 
                                echo "server is reachable by ping" 
                        else 
                                echo "server isn't reachable by ping" 
                        fi 
                else 
                        unset IP 
                fi 
        done 
        read -p "please enter remote path:" RPATH 
        iscp $LPATH $RUSER $IP $RPATH 
        ;; 

-t) param="$2" 
	echo "Found the -t option, with parameter value $param" 
	read -p "Please enter your Host IP: " HOST
	read -p "Please enter Port: " PORT
	read -p "please enter UserName: " USER
	read -s -p "please enter PassWord: " PASSWORD
	read -p "please enter source file/path: " LPATH
       	read -p "please enter remote file/path: " RPATH

	spawn /usr/bin/sftp -o Port=$PORT $USER@$HOST 
	sleep 2 	
	expect "password:" 
	send "$PASSWORD\r" 
	expect "sftp>" 
	send "put $SOURCE_FILE $TARGET_DIR\r" 
	expect "sftp>" 
	send "bye\r" 
	expect ""
	

shift ;; 

-p) USE="$2" 
echo "Found the -p option value is $USE" 
shift;; 

--) shift 
break ;; 

*) echo "$1 is not an option";; 
esac 
shift 

done 

function iscp() 
{ 
        local LPATH=$1 
        local USER=$2 
        local RIP=$3 
        local RPATH=$4 
        scp $LPATH $USER@$RIP:$RPATH 
} 
