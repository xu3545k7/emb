#!/bin/bash

# 檢查是否提供了日志文件作為參數
if [ $# -eq 0 ]; then
  echo "Usage: $0 <log_file>"
  exit 1
fi

LOG_FILE=$1

# 檢查日志文件是否存在
if [ ! -f "$LOG_FILE" ]; then
  echo "Log file not found!"
  exit 1
fi

# 顯示Top 10登錄失敗的IP地址
echo "Top 10 Failed login attempts by IP:"
grep -E "Failed password for (invalid user )?[a-zA-Z0-9_-]+ from [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" "$LOG_FILE" \
  | grep -oE "from [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | awk '{print $2}' | sort | uniq -c | sort -nr | head -n 10

# 顯示Top 10無效的用戶名
echo ""
echo "Top 10 Invalid user login attempts by username:"
grep -E "Invalid user [a-zA-Z0-9_-]+ from [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+|Failed password for (invalid user )?[a-zA-Z0-9_-]+ from [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" "$LOG_FILE" \
  | grep -oE "Invalid user [a-zA-Z0-9_-]+" | awk '{print $NF}' | sort | uniq -c | sort -nr | head -n 10