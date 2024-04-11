#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
NODE="http://127.0.0.1:26657"
VALIDATOR_ADDRESS="<>"
MEMO="<>"
DELAY=3600 #Delay time in seconds

read -s -p "Enter your validator decryption password (for self-restaking): " VAL_PASSWORD
echo ""


for (( ;; )); do
        JAIL=$(namadac validator-state --validator ${VALIDATOR_ADDRESS} | grep "is jailed");
        if [[ "${JAIL}" == "" ]]; then
            echo -e "${GREEN}Jailed: false${NC}\n"
        else
            echo -e "${GREEN}Jailed: true${NC}\n"
			CATCHING_UP=$(curl ${NODE}/status |  jq -r '.result.sync_info.catching_up')
			if [[ ${CATCHING_UP} == *"false"* ]]; then
				echo -e "Node is sync. Trying to unjail. \n"
				$(expect -c "set timeout -1
					spawn namadac unjail-validator --validator "${VALIDATOR_ADDRESS}" --memo "${MEMO}"
					expect \"Enter your decryption password: \"
					send -- \"$VAL_PASSWORD\r\"
					expect eof")
				for (( timer=30; timer>0; timer-- ))
				do
					printf "* sleep for ${RED}%02d${NC} sec\r" $timer
					sleep 1
				done

				JAIL=$(namadac validator-state --validator ${VALIDATOR_ADDRESS} | grep "is jailed");
				if [[ "${JAIL}" == "" ]]; then
					echo -e "${GREEN}Node is still jailed${NC}\n"
				else
					echo -e "${GREEN}Node unjailed${NC}\n"
				fi
		else
			echo -e "Node isn't sync. Waiting... \n"
		fi
	fi
	for (( timer=${DELAY}; timer>0; timer-- ))
	do
		printf "* sleep for ${RED}%02d${NC} sec\r" $timer
		sleep 1
	done
done
