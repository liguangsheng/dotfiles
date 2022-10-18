# colors
NC='\033[0m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT_GRAY='\033[0;37m'
DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_PURPLE='\033[1;35m'
LIGHT_CYAN='\033[1;36m'
WHITE='\033[1;37m'

# 进程按占用内存大小排序
function pss {
    n=20
    if [[ $# -eq 1 ]]; then
        n=$1
    fi
    ((n=n+1))
    ps -eo comm,pid,size,rss,vsize,maj_flt,min_flt,pmem,pcpu,time --sort -rss | numfmt --header --to=iec --field 6-7 | numfmt --header --from-unit=1024 --to=iec --field 3-5 | column -t | head -n $n
}

# 进制转换
# eg.binconv 123 10 2
# 将123从10进制转换到2进制
function binconv() {
    echo "obase=$3; ibase=$2; $1" | bc
}

# gentoo 更新系统
function update_gentoo() {
    sudo emerge --ask --verbose --update --newuse --deep @world
}

# 打印一个分割线
function hr() {
    str=$(date "+%Y-%m-%d %H:%M:%S")

    str=" $str "
    sep="─"
    width=$(tput cols)

    prefix=""
    for ((i = 0; i < $((($width - ${#str}) / 2)); i++)); do
        prefix=$prefix$sep
    done
    echo "$prefix$str$prefix"
}

# 生成随即字符串
# param:
# - $1: 字符串长度
function randstr() {
    head -c $((($1 + 1) / 2)) /dev/urandom | hexdump -e '"%x"' | cut -c 1-$1
}

function until_success() {
    ROUND=0
    while true; do
        echo "$GREEN\rCURRENT ROUND$NC: $ROUND"
        if eval "$@"; then
            return
        fi
        ROUND=$(($ROUND + 1))
        echo "$GREEN\rNEXT ROUND$NC: $ROUND"
        sleep 5s
    done
    ROUND=
}

function until_fail() {
    until ! eval "$@"; do; done
}

function until_count() {
    ROUND=0
    while [ $ROUND -lt $1 ]; do
        ROUND=$(($ROUND + 1))
        eval ${@:2}
    done
    ROUND=
}

function weather() {
    curl -s "wttr.in/$1?m1"
}

function count() {
    total=$1
    for ((i = total; i > 0; i--)); do
        printf "Time remaining $i secs"
        sleep 1
        printf "\r"
    done
    echo -e "\a"
}

function extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2) tar xvjf $1 ;;
            *.tar.gz) tar xvzf $1 ;;
            *.tar.xz) tar Jxvf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.rar) rar x $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xvf $1 ;;
            *.tbz2) tar xvjf $1 ;;
            *.tgz) tar xvzf $1 ;;
            *.zip) unzip -d $(echo $1 | sed 's/\(.*\)\.zip/\1/') $1 ;;
            *.Z) uncompress $1 ;;
            *.7z) 7z x $1 ;;
            *) echo "don't know how to extract '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

function compress() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: compress source_file_or_directory target_file"
    echo "Supported formats: tar.gz, tar.bz2, tar.xz, zip, rar, gz, tar, tbz2, tgz, 7z"
    return 1
  fi

  if [ ! -e "$1" ]; then
    echo "Error: source file or directory does not exist"
    return 1
  fi

  source_file="$1"
  target_file="$2"
  format="${target_file##*.}"  # 提取目标文件的后缀

  case $format in
    tar.gz) tar czvf "$target_file" "$source_file" ;;
    tar.bz2) tar cjvf "$target_file" "$source_file" ;;
    tar.xz) tar cJvf "$target_file" "$source_file" ;;
    zip) zip -r "$target_file" "$source_file" ;;
    rar) rar a "$target_file" "$source_file" ;;
    gz) gzip -k "$source_file" -c > "$target_file" ;;
    tar) tar cvf "$target_file" "$source_file" ;;
    tbz2) tar cjvf "$target_file" "$source_file" ;;
    tgz) tar czvf "$target_file" "$source_file" ;;
    7z) 7z a "$target_file" "$source_file" ;;
    *)
      echo "Error: unsupported format"
      echo "Supported formats: tar.gz, tar.bz2, tar.xz, zip, rar, gz, tar, tbz2, tgz, 7z"
      return 1
      ;;
  esac

  echo "Compression complete: $target_file"
}

