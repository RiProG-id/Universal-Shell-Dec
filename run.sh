#!/bin/bash
pattern=###########################################################
ulimit -s unlimited >/dev/null 2>&1
echo ""
echo "Universal Shell DEC 7.5"
dec() {
  if grep -q -e '=.*;.*=.*;' -e 'base64 -d | sh$' -e '" | sh' -e "$pattern" "$(pwd)/$shuf.temp1.sh"; then
    while true; do
      if grep '=.*;.*=.*;' "$(pwd)/$shuf.temp1.sh"; then
        counter=$((counter + 1))
        echo "$counter. Eval"
        sed 's/eval "\$/echo "\$/g; s/\[ "$(id -u)" -ne 2000 \]/! true/' "$(pwd)/$shuf.temp1.sh" > "$(pwd)/$shuf.temp2.sh"
        bash "$(pwd)/$shuf.temp2.sh" > "$(pwd)/$shuf.temp1.sh"
        rm "$(pwd)/$shuf.temp2.sh"
      elif grep -q 'base64 -d | sh$' "$(pwd)/$shuf.temp1.sh"; then
        counter=$((counter + 1))
        echo "$counter. Base64"
        sed 's/base64 -d | sh/base64 -d/; s/\[ "$(id -u)" -ne 2000 \]/! true/' "$(pwd)/$shuf.temp1.sh" > "$(pwd)/$shuf.temp2.sh"
        bash "$(pwd)/$shuf.temp2.sh" > "$(pwd)/$shuf.temp1.sh"
        rm "$(pwd)/$shuf.temp2.sh"
      elif grep -q '" | sh' "$(pwd)/$shuf.temp1.sh"; then
        counter=$((counter + 1))
        echo "$counter. Other"
        sed 's/\" | sh/\" > \"\$(pwd)\/$shuf.temp1.sh\"/g; s/\[ "$(id -u)" -ne 2000 \]/! true/" "$(pwd)/$shuf.temp1.sh' > "$(pwd)/$shuf.temp2.sh"
        bash "$(pwd)/$shuf.temp2.sh"
        rm "$(pwd)/$shuf.temp2.sh"
      elif grep -q "$pattern" "$(pwd)/$shuf.temp1.sh"; then
        counter=$((counter + 1))
        echo "$counter. Pattern"
        cp "$(pwd)/$shuf.temp1.sh" "$(pwd)/$shuf.temp2.sh"
        cat "$(pwd)/$shuf.temp2.sh" | grep -v '###########################################################' > "$(pwd)/$shuf.temp1.sh"
        rm "$(pwd)/$shuf.temp2.sh"
      else
        break
      fi
    done
else
  counter=$((counter + 1))
  echo "$counter. SHC"
  for sec in $(seq 1 16); do
    exec="$(pwd)/$shuf.temp1.sh"
    "$exec" > /dev/null 2>&1 &
    child=$!
    sleep 0.0"$sec"
    kill -STOP $child
    cmdline=$(cat /proc/$child/cmdline)
    echo "$cmdline" | sed 's/.*\(#!\)/\1/' | head -c "-$(echo "$exec" | wc -c)" > "$(pwd)/$shuf.temp2.sh"
    kill -TERM $child
    if grep -q '#!/' "$(pwd)/$shuf.temp2.sh"; then
      break
    else
      rm "$(pwd)/$shuf.temp2.sh"
      touch "$(pwd)/$shuf.temp2.sh"
    fi
  done
fi
mv "$(pwd)/$shuf.temp2.sh" "$(pwd)/$shuf.temp1.sh"
echo ""
     }
echo ""
echo "Example:"
echo "Single Input is a file"
echo "/sdcard/in/example.sh"
echo "Multi Input is a directory"
echo "/sdcard/in"
echo ""
printf "Enter the location: "
read -r input
shuf=$(shuf -i 1-100 -n 1)
echo ""
if [ -z "$(find "$input" -maxdepth 1 -type f)" ]; then
  echo "Warning: Input not found."
  exit 1
fi

find "$input" -maxdepth 1 -type f | while IFS= read -r file; do
  counter=0
  cp "$file" "$(pwd)/$shuf.temp1.sh"
  chmod +x "$(pwd)/$shuf.temp1.sh"
  echo "Decrypting $(basename "$file")"
  dec > /dev/null 2>&1
  if grep -q -e '=.*;.*=.*;' -e 'base64 -d | sh$' -e '" | sh' -e "$pattern" "$(pwd)/$shuf.temp1.sh"; then
  dec > /dev/null 2>&1
  fi
  if [ -s "$(pwd)/$shuf.temp1.sh" ]; then
  mv "$(pwd)/$shuf.temp1.sh" "$file"
  echo "Success: Decryption of $(basename "$file") completed."
  else
  echo "Failed: Unable to decrypt $(basename "$file")."
  rm "$(pwd)/$shuf.temp1.sh"
  fi
done
echo ""
