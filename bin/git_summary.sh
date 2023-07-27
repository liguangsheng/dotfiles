
#!/bin/bash

# 设置默认值
REPO_PATH="."
START_DATE=$(date -d "-1 month" +%Y-%m-%d)
END_DATE=$(date +%Y-%m-%d)
SORT_TYPE="total_lines"

# 解析参数
while getopts ":r:s:e:t:" opt; do
  case $opt in
    r)
      REPO_PATH="$OPTARG"
      ;;
    s)
      START_DATE="$OPTARG"
      ;;
    e)
      END_DATE="$OPTARG"
      ;;
    t)
      SORT_TYPE="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# 移除解析过的参数
shift $((OPTIND-1))

# 进入Git仓库目录
cd "$REPO_PATH"

# 获取所有贡献者的姓名列表和对应的总行数、添加行数或删除行数
contributors=$(git log --since="$START_DATE" --until="$END_DATE" --format="%aN" | sort -u)
declare -A lines_map

# 循环遍历每个贡献者，并计算相应的行数
for contributor in $contributors; do
  case $SORT_TYPE in
    total_lines)
      lines_count=$(git log --since="$START_DATE" --until="$END_DATE" --author="$contributor" --oneline --shortstat --pretty="" | awk '{add+=$4; del+=$6} END {print add+del}')
      ;;
    additions)
      lines_count=$(git log --since="$START_DATE" --until="$END_DATE" --author="$contributor" --oneline --shortstat --pretty="" | awk '{print $4}' | grep -Eo '[0-9]+' | paste -sd+ - | bc)
      ;;
    deletions)
      lines_count=$(git log --since="$START_DATE" --until="$END_DATE" --author="$contributor" --oneline --shortstat --pretty="" | awk '{print $6}' | grep -Eo '[0-9]+' | paste -sd+ - | bc)
      ;;
    *)
      echo "Invalid sort type: $SORT_TYPE. Use 'total_lines', 'additions', or 'deletions'." >&2
      exit 1
      ;;
  esac

  lines_map["$contributor"]=$lines_count
done

# 根据指定的排序类型排序
case $SORT_TYPE in
  total_lines | additions | deletions)
    sorted_contributors=$(for contributor in "${!lines_map[@]}"; do
      echo "${lines_map["$contributor"]} $contributor"
    done | sort -nr | awk '{print $2}')
    ;;
esac

# 输出排序后的结果
for contributor in $sorted_contributors; do
  lines_count=${lines_map["$contributor"]}
  additions=$(git log --since="$START_DATE" --until="$END_DATE" --author="$contributor" --oneline --shortstat --pretty="" | awk '{print $4}' | grep -Eo '[0-9]+' | paste -sd+ - | bc)
  deletions=$(git log --since="$START_DATE" --until="$END_DATE" --author="$contributor" --oneline --shortstat --pretty="" | awk '{print $6}' | grep -Eo '[0-9]+' | paste -sd+ - | bc)
  commit_count=$(git log --since="$START_DATE" --until="$END_DATE" --author="$contributor" --oneline | wc -l)

  echo "Contributor: $contributor"
  echo "Total Lines: $lines_count lines"
  echo "Additions: $additions lines"
  echo "Deletions: $deletions lines"
  echo "Commits: $commit_count"
  echo
done

