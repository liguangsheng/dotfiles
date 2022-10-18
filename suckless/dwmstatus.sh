#!/usr/bin/env bash

upt(){
  upt="$(uptime | awk -F'( |,|:)+' '{d=h=m=0; if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0"d,"h+0"h,"m+0"m"}')"
  echo -e "$upt"
}

mem(){
  mem="$(free | head -n 2 | tail -n 1 | awk '{printf "%2.2f%%(%.0fM)\n", $3/$2*100, $3/1000}')"
  echo -e "$mem"
}

dte(){
  dte="$(date +"%F %T %A")"
  echo -e "$dte"
}

cpu(){
  cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "%02.1f%%" , 100 - $1}') 
  echo -e "$cpu"
}

kel(){
  kel="$(uname -r)"
  echo -e "$kel"
}

KEL_CACHE=$(kel)

while true; do
  xsetroot -name "  $KEL_CACHE |  $(upt) | ﬙ $(cpu) |  $(mem) |  $(dte) |"
  sleep 1s
done
