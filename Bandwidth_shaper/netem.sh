#!/bin/bash
INTERFACE="$1"
CMD="$2"

 # exit on errors
set -e

printhelp() {
    echo "Usage: netem.sh INAME CMD"
    echo "Valid CMDs are:"
    echo
    echo "INAME tc [CONFIGURATION_FILE] [SWITCH_TIME]"
    echo "  set traffic control paramerers:"
    echo
    echo "  CONFIGURATION_FILE file with the configuration parameter of the probability and bitrate values"
    echo "  SWITCH_TIME is in second"
    echo
    echo "INAME init"
    echo "  initializes the given INAME for netem"
    echo
    echo "INAME deinit"
    echo "  deinitializes netem on the given INAME"
    echo
    echo "INAME ls"
    echo "  lists qdiscs on the given INAME"
}

# second argument is "ls", print qdiscs on given INAME
if [[ "$CMD" == "ls" ]]; then
    tc -s qdisc ls dev "$INTERFACE"

# second argument is "init", init netem on given INAME
elif [[ "$CMD" == "init" ]]; then
    # check root privilegies
    if [[ "$(whoami)" != "root" ]]; then
        echo "This action needs root privilegies. Please re-run as root."
        exit 1
    fi

    # outgoing traffic netem
    tc qdisc add dev $INTERFACE root netem

    # incoming traffic netem
    modprobe ifb
    ip link set dev ifb0 up
    tc qdisc add dev $INTERFACE ingress
    tc filter add dev $INTERFACE parent ffff: \
        protocol ip u32 match u32 0 0 flowid 1:1 action mirred egress redirect dev ifb0

    tc qdisc add dev ifb0 root netem

# second argument is "deinit", deinit netem on given INAME
elif [[ "$CMD" == "deinit" ]]; then
    # check root privilegies
    if [[ "$(whoami)" != "root" ]]; then
        echo "This action needs root privilegies. Please re-run as root."
        exit 1
    fi

    rmmod ifb
    tc qdisc del dev $INTERFACE ingress
    tc qdisc del dev $INTERFACE root netem

elif [[ "$CMD" == "tc" ]]; then
    # delay/loss arguments are mandatory in tc command
    if [[ -z "$4" ]]; then
        echo "ERROR: Not enough arguments for tc command."
        echo
        printhelp
        exit 1
    elif [[ ! -z "$5" ]]; then
    	echo "ERROR: Too many arguments for tc command."
        echo
        printhelp
        exit 1
    else
		filename="$3"
		wait_time="$4"
		counter=0
		while read -r line
			do
				element=$(echo $line | tr " " "\n")	
				for i in $element ; do
					if [[ $i != node* ]] && [[ $i != arch* ]]; then
						array[$counter]=$i;
						#echo ${array[$counter]}
						let counter=counter+1;
					fi
				done
			done < "$filename"
	fi

	#configuration parameter saved now creating markov chain
	echo "executing marcov chain"
	nodeNumber=${array[0]}
	archNumber=${array[1]}
	#always start with node 1
	start=0
	jump=0
	while true
		do
			#generating probability
			probability=$(( $RANDOM % 100 ))
			echo "----------------"
			#echo "$probability"	

			#retriving the probability boundaries per node
			if [[ $start == "0" ]]; then
				#echo "FIRST"
				stayLW=$((2 * (nodeNumber + 1))); stayLWprob=${array[$stayLW]}
				stayUP=$((stayLW + 1)); stayUPprob=${array[$stayUP]}
				nextLW=$((stayLW + 2)); nextLWprob=${array[$nextLW]}
				nextUP=$((stayLW + 3)); nextUPprob=${array[$nextUP]}
			
				if [[ $probability -ge $stayLWprob && $probability -le $stayUPprob ]]; then
					#echo "STAY"
					jump=$start
				else
					#echo "NEEEEXT"
					jump=$(( start + 1 ))
				fi
				#echo "----------------"
				#echo "$stayLWprob"
				#echo "$stayUPprob"
				#echo "----------------"
				#echo "$nextLWprob"
				#echo "$nextUPprob"
				#echo "----------------"
			elif [[ $start == "$((nodeNumber-1))" ]]; then
				#echo "LAST"
				stayUP=$((counter-1)); stayUPprob=${array[$stayUP]}
				stayLW=$((stayUP-1));  stayLWprob=${array[$stayLW]}
				prevUP=$((stayUP-2));  prevUPprob=${array[$prevUP]}
				prevLW=$((stayUP-3));  prevLWprob=${array[$prevLW]}

				if [[ $probability -ge $stayLWprob && $probability -le $stayUPprob ]]; then
					#echo "STAY"
					jump=$start
				else
					#echo "PREVIOUS"
					jump=$(( start - 1 ))
				fi
				#echo "----------------"
				#echo "$stayLW"
				#echo "$stayUP"
				#echo "----------------"
				#echo "$nextLW"
				#echo "$nextUP"
				#echo "----------------"
			else
				#echo "MIDDLE"
				prevLW=$((2 * (nodeNumber + 3) + 6 * (start -1) )); prevLWprob=${array[$prevLW]}
				prevUP=$((prevLW + 1)); prevUPprob=${array[$prevUP]}
				stayLW=$((prevLW + 2)); stayLWprob=${array[$stayLW]}
				stayUP=$((prevLW + 3)); stayUPprob=${array[$stayUP]}
				nextLW=$((prevLW + 4)); nextLWprob=${array[$nextLW]}
				nextUP=$((prevLW + 5)); nextUPprob=${array[$nextUP]}
				
				if [[ $probability -ge $prevLWprob && $probability -le $prevUPprob ]]; then
					#echo "PREVIOUS"
					jump=$(( start - 1 ))
				elif [[ $probability -ge $stayLWprob && $probability -le $stayUPprob ]]; then
					#echo "STAY"
					jump=$start
				else
					#echo "NEXT"
					jump=$(( start + 1 ))
				fi

				#echo "----------------"
				#echo "$prevLW"
				#echo "$prevUP"
				#echo "----------------"
				#echo "$stayLW"
				#echo "$stayUP"
				#echo "----------------"
				#echo "$nextLW"
				#echo "$nextUP"
				#echo "----------------"
			fi
			#selecting the bandwith value
			indexLw=$((2 * (start + 1)))
			indexUp=$((indexLw + 1))
			lowerbBound=${array[$indexLw]}
			upperBound=${array[$indexUp]}
			range=$(( upperBound - lowerbBound ))
			randomBW=$(( $RANDOM % $range + $lowerbBound ))
			beginning='rate '
			units='kbit'
			RATE=$beginning$randomBW$units
			#echo $RATE

			#star the bandwith shaper
			LATENCY="delay 0ms"
			LOSS="loss 0%"

		echo "$LATENCY"
    		echo "$LOSS"
    		echo "$RATE"

    		tc qdisc change dev "$INTERFACE" root netem $LATENCY $LOSS $RATE
    		tc qdisc change dev "ifb0" root netem $LATENCY $LOSS $RATE

			#setting neext node
			start=$jump

			#sleeping time
			sleep $wait_time
		done

# at least three args must be given
else
    printhelp
    exit 1
fi
