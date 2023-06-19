#!/bin/bash

# 获取传递给脚本的第一个参数作为仓库路径
REPO_PATH="$1"

# 检查是否提供了仓库路径参数
if [ -z "$REPO_PATH" ]; then
  echo "Usage: $0 <repo_path>"
  exit 1
fi

# 进入Git仓库目录
cd "$REPO_PATH"

# 获取一个月前的日期
ONE_MONTH_AGO=$(date -d "-1 month" +%Y-%m-%d)

# 获取所有贡献者的姓名列表和对应的添加行数
contributors=$(git log --since="$ONE_MONTH_AGO" --format="%aN" | sort -u)
declare -A additions_map

# 循环遍历每个贡献者，并计算添加行数
for contributor in $contributors; do
  additions=$(git log --since="$ONE_MONTH_AGO" --author="$contributor" --oneline --shortstat --pretty="" | awk '{print $4}' | grep -Eo '[0-9]+' | paste -sd+ - | bc)
  additions_map["$contributor"]=$additions
done

# 按添加行数排序
sorted_contributors=$(for contributor in "${!additions_map[@]}"; do
  echo "${additions_map["$contributor"]} $contributor"
done | sort -nr | awk '{print $2}')

# 输出排序后的结果
for contributor in $sorted_contributors; do
  additions=${additions_map["$contributor"]}
  deletions=$(git log --since="$ONE_MONTH_AGO" --author="$contributor" --oneline --shortstat --pretty="" | awk '{print $6}' | grep -Eo '[0-9]+' | paste -sd+ - | bc)
  total_lines=$((additions - deletions))

  echo "Contributor: $contributor"
  echo "Additions: $additions lines"
  echo "Deletions: $deletions lines"
  echo "Total Lines: $total_lines lines"
  echo
done

