#!/bin/bash
#stegbrute.sh v0.1
#Last edit 07-05-2016 12:30
#steghide must be installed
#having trouble with Nevermore's cool perl steghide bruter and needed a simple alterntive. 
#credits for the idea to Nevermore !
#usage stegbrute.sh -i stegfile -w wordlist
#
#
#
#						TEH COLORZ :D
########################################################################
STD=$(echo -e "\e[0;0;0m")		#Revert fonts to standard colour/format
REDN=$(echo -e "\e[0;31m")		#Alter fonts to red normal
GRNN=$(echo -e "\e[0;32m")		#Alter fonts to green normal
BLUN=$(echo -e "\e[0;36m")		#Alter fonts to blue normal
#
#						VARIABLES
########################################################################
COLORZ=1
#
#						HELP
########################################################################
f_help() {
echo "Usage
./$0 -i <input jpg file> -w <wordlist file>
./$0 <input jpg file> <wordlist file>"

echo ""
echo "Options
-b  --  boring colorless output
-h  --  this help
-i  --  input file
-w  --  wordlist file"
exit
}
#
#						OPTION FUNCTIONS
########################################################################
while getopts ":bhi:w:" opt; do
  case $opt in
	b) COLORZ=0 ;;
	h) f_help ;;
	i) INFILE=$OPTARG ;;
	w) WORDLIST=$OPTARG ;;
  esac
done
#						INPUT CHECKS
########################################################################
#
SHEXIST=$(locate steghide)
if [ "$SHEXIST" == "" ] ; then
	echo $REDN"[!]$STD steghide not found; steghide required for the script to work."
fi
if [ "$COLORZ" == "0" ] ; then
read RED REDN GRN GRNN ORN ORNN BLU BLUN  <<< ""
fi
if [ $# -eq 0 ] ; then 
f_help
fi
#
if [[ -z $INFILE && -z $WORDLIST ]] ; then 
	INFILE=$1
	WORDLIST=$2
fi
#						START SCRIPT
########################################################################
echo $BLUN"[+]$STD Testing file: $INFILE" 
while read WORD ; do
	echo -ne $BLUN"[+]$STD Testing password: $REDN$WORD\r$STD"
	CCOUNT=$(echo $WORD | wc -c)
	RESULT=$(steghide extract -sf $INFILE -p "$WORD" -f 2>&1)
	if [[ "$RESULT" =~ "already" || "$RESULT" =~ "extracted" ]] ; then
		echo $GRNN"[+]$STD Password retrieved: $GRNN$WORD$STD for $INFILE"
		echo
		exit
	else
		SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
		echo -ne $BLUN"[+]$STD Testing password: $SPACE\r"

	fi
done < $WORDLIST
echo $REDN"[-]$STD No passwords retrieved for $INFILE"
echo
exit

#
