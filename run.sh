#!/bin/sh
echo
echo "Universal Shell DEC 5.0"
dec() {
  cp "$1" "$(pwd)/$shuf.temp1.sh"
  chmod +x "$(pwd)/$shuf.temp1.sh"
  if grep -e 'eval' -e 'base64 -d' -e '" | sh' "$(pwd)/$shuf.temp1.sh"; then
    while true; do
      if grep eval "$(pwd)/$shuf.temp1.sh"; then
        sed 's/eval "\$/echo "\$/g' "$(pwd)/$shuf.temp1.sh" > "$(pwd)/$shuf.temp2.sh"
        bash "$(pwd)/$shuf.temp2.sh" > "$(pwd)/$shuf.temp1.sh"
        rm "$(pwd)/$shuf.temp2.sh"
      elif grep "base64 -d" "$(pwd)/$shuf.temp1.sh"; then
        sed 's/| sh$//' "$(pwd)/$shuf.temp1.sh" > "$(pwd)/$shuf.temp2.sh"
        bash "$(pwd)/$shuf.temp2.sh" > "$(pwd)/$shuf.temp1.sh"
        rm "$(pwd)/$shuf.temp2.sh"
        elif grep '" | sh' "$(pwd)/$shuf.temp1.sh"; then
        sed 's/" | sh/" > "$(pwd)\/temp1.sh"/g' "$(pwd)/$shuf.temp1.sh" > "$(pwd)/$shuf.temp2.sh"
        bash "$(pwd)/$shuf.temp2.sh"
        rm "$(pwd)/$shuf.temp2.sh"
      else
        break
      fi
    done
else
  for sec in $(seq 1 16); do
  "$(pwd)/$shuf.temp1.sh" > /dev/null 2>&1 &
  child=$!
  sleep 0.0"$sec"
  kill -STOP $child
  cmdline=$(cat /proc/$child/cmdline)
  echo "$cmdline" | sed 's/.*\(#\)/\1/; $d' > "$(pwd)/$shuf.temp2.sh"
      kill -TERM $child
      if [ -s "$(pwd)/$shuf.temp2.sh" ]; then
      mv "$(pwd)/$shuf.temp2.sh" "$(pwd)/$shuf.temp1.sh"
      break
      fi
    done
  fi
  echo ""
 }
echo ""
echo "Example:"
  echo "single /sdcard/in/example.sh"
  echo "multi /sdcard/in/*"
echo ""
printf "Enter the file location: "
read -r input
find=$(find "$input") > /dev/null 2>&1
if [ -z "$find" ]; then
  echo "Warning: Input not found."
  exit 1
fi
shuf=$(shuf -i 1-100 -n 1)
echo ""
for file in "$input"; do
  echo "Decrypting $(basename "$file")"
  dec "$file" > /dev/null 2>&1
  if [ -s "$(pwd)/$shuf.temp1.sh" ]; then
  mv "$(pwd)/$shuf.temp1.sh" "$file"
  echo "Success: Decryption of $(basename "$file") completed."
  else
  echo "Failed: Unable to decrypt $(basename "$file")."
  rm "$(pwd)/$shuf.temp1.sh"
  fi
done
