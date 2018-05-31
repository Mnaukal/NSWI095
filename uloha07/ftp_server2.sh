#!/bin/sh

rand_port() {
	local x
	x=$(($RANDOM % 65536))
	while [ $x -lt 1024 ]; do
		x=$(($RANDOM % 65536))
	done
	echo $x
}

upper() {
	echo "$1" | tr "[[:lower:]]" "[[:upper:]]"
}

parse() {
	local line
	line=`echo "$1" | sed -e 's|\r$||'`
	CMD=`echo "$line" | sed -e 's| .*$||'`
	ARG=`echo "$line" | sed -e 's|^[^ ]\+ *||'`
}

need_password() {
	[ "$1" != "anonymous" ]
	return $?
}

do_help() {
	echo "214-The following commands are recognized."
	echo " USER PASS QUIT HELP"
	echo "214 Help OK."
}

serve() {
	local CMD ARG logged_in has_user user nc_pid FIFO_IN FIFO_OUT port \
		is_ascii
	logged_in=0
	has_user=0
	user=""
	nc_pid=0
	FIFO_IN=""
	FIFO_OUT=""
	port=0
	is_ascii=0

	echo "220 Hello, World!"

	IFS=`printf "\n"`
	while read line; do
		parse "$line"

		case `upper $CMD` in
			USER)
				user="$ARG"
				if need_password "$user"; then
					echo "331 Please specify the password"
				else
					echo "230 Logged in as \"$user\""
					logged_in=1
					break
				fi
				has_user=1
				;;
			PASS)
				if [ $has_user -eq 1 ]; then
					if log_in "$user" "$arg"; then
						echo "230 Logged in as \"$user\""
						logged_in=1
						break
					else
						echo "530 Login incorrect"
						user=""
						has_user=0
					fi
				else
					echo "503 Login as USER first"
				fi
				;;
			QUIT)
				echo "221 Goodbye."
				return 0
				;;
			HELP)
				do_help
				;;
			*)
				echo "500 Bad command"
				;;
		esac
	done

	while read line; do
		parse "$line"

		case "$CMD" in
			USER)
				if [ "$ARG" == "$user" ]; then
					echo "331 Any password will do"
				else
					echo "530 Can't change to another user"
				fi
				;;
			PASS)
				echo "230 Already logged in"
				;;
			HELP)
				do_help
				;;
			EPSV)
				if [ $nc_pid -gt 0 ]; then
					exec 3<&- 4>&-
					rm "$FIFO_IN" "$FIFO_OUT"
					port=0
					kill $nc_pid
					wait $nc_pid
					nc_pid=0
				fi
				FIFO_IN=/tmp/ftp_fifo_in.$RANDOM
				FIFO_OUT=/tmp/ftp_fifo_out.$RANDOM
				mkfifo "$FIFO_IN" "$FIFO_OUT"
				port=`rand_port`
				exec 3<>"$FIFO_OUT"
				nc -l -p $port <"$FIFO_IN" >"$FIFO_OUT" 2>/dev/null &
				nc_pid=$!
				trap "rm $FIFO_IN $FIFO_OUT; kill $nc_pid" INT HUP QUIT
				exec 4>"$FIFO_IN"
				sleep 0.1
				printf "229 Entering Extended Passive Mode (|||%d|).\r\n" $port
				;;
			PWD)
				echo "257 \"`pwd`\""
				;;
			CWD)
				if cd "$ARG" 2>/dev/null; then
					echo "250 Directory successfully changed"
				else
					echo "550 Failed to change directory"
				fi
				;;
			TYPE)
				if [ "$ARG" == "I" -o "$ARG" == "L8" -o "$ARG" == "L 8" ]; then
					is_ascii=0
					echo "200 Switching to Binary mode"
				elif [ "$ARG" == "A" -o "$ARG" == "A N" ]; then
					is_ascii=1
					echo "200 Switching to ASCII mode"
				else
					echo "500 Unrecognized TYPE command"
				fi
				;;
			LIST)
				if [ $nc_pid -eq 0 ]; then
					echo "425 Use PORT or PASV first"
				else
					echo "150 Here comes the directory listing"
					ls -al | tail -n +2 >&4
					echo "226 Directory send OK"
					exec 3<&- 4>&-
					rm "$FIFO_IN" "$FIFO_OUT"
					port=0
					kill $nc_pid
					wait $nc_pid
					nc_pid=0
				fi
				;;
			QUIT)
				echo "221 Goodbye."
				return 0
				;;
			*)
				echo "500 Bad command"
				;;
		esac
	done

	return 0
}


#set -x
if [ "$1" = "--serve" ]; then
	serve
	exit $?
fi

nc --continuous --listen --port=10021 --exec=\""$0 --serve"\"
exit 0
