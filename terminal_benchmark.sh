#!/usr/bin/env bash

count=${1:-100000}

start=$(date +%s%3N)

for ((i = 1; i <= count; i++)); do
  echo -e '\r'
  echo -e '\033[0K\033[1mBold\033[0m \033[7mInvert\033[0m \033[4mUnderline\033[0m'
  echo -e '\033[0K\033[1m\033[7m\033[4mBold & Invert & Underline\033[0m'
  echo
  echo -e '\033[0K\033[31m Red \033[32m Green \033[33m Yellow \033[34m Blue \033[35m Magenta \033[36m Cyan \033[0m'
  echo -e '\033[0K\033[1m\033[4m\033[31m Red \033[32m Green \033[33m Yellow \033[34m Blue \033[35m Magenta \033[36m Cyan \033[0m'
  echo
  echo -e '\033[0K\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
  echo -e '\033[0K\033[1m\033[4m\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
  echo
  echo -e '\033[0K\033[30m\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
  echo -e '\033[0K\033[30m\033[1m\033[4m\033[41m Red \033[42m Green \033[43m Yellow \033[44m Blue \033[45m Magenta \033[46m Cyan \033[0m'
done

end=$(date +%s%3N)
runtime=$((end - start))
seconds=$((runtime / 1000))
milliseconds=$((runtime % 1000))
echo 
echo "执行耗时：$seconds 秒 $milliseconds 毫秒"
