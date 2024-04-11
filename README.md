# Namada auto unjail script
Script is checking that validator isn't jailed and unjail it if it is jailed and is synced.
# Usage
## Install dependencies
~~~
sudo apt update && sudo apt upgrade -y
sudo apt install curl git expect -y
~~~
Add VALIDATOR_ADDRESS and MEMO to unjail.sh file
## Run script
~~~
unjail.sh
~~~
