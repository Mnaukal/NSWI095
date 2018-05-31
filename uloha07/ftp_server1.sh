#!/bin/sh

random_port() {
	local x
	x=$(($RANDOM % 65536))
	while [ $x -lt 1024 -o $x -gt 65535 ]; do
		x=$((RANDOM % 65536))
	done
	echo $x
}

echo "220 ahoj"

prihlaseny=0
nc_pid=0

while read CMD ARG; do
	echo "$CMD $ARG" >&2
	case $CMD in
		USER)
			if [ "$ARG" == "anonymous" ]; then
				echo "230 login success"
				prihlaseny=1
			else
				echo "530 bad login"
			fi
			;;
		PASS)
			if [ $prihlaseny -eq 1 ]; then
				echo "230 already logged in"
			else
				echo "503 use USER first"
			fi
			;;
		PWD)
			echo "257" `pwd`
			;;
		CWD)
			if cd "$ARG" 2>/dev/null; then
				echo "250 success"
			else
				echo "550 fail"
			fi
			;;
		EPSV)
			FIFO=/tmp/ftp_fifo.$RANDOM
			mkfifo $FIFO
			port=`random_port`
			nc -l -p $port <$FIFO 2>/dev/null &
			exec 3<>$FIFO
			nc_pid=$!
			echo "229 Entering Extended Passive Mode (|||$port|)."
			;;
		TYPE)
			echo "200 ok"
			;;
		LIST)
			if [ $nc_pid -eq 0 ]; then
				echo "425 pripoj sa"
			else
				echo "150 sending directory"
				ls -l | tail -n +2 >&3
				echo "226 sent"
				exec 3>&-
				kill $nc_pid
				nc_pid=0
				rm $FIFO
			fi
			;;
		QUIT)
			echo "221 goodbye"
			break
			;;
		*)
			echo "500 unknown command"
			;;
	esac
done

exit 0

