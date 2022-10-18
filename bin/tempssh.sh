#!/bin/bash

# 1. 生成随机用户名
TEMP_USER="tmp_$(shuf -i 1000-9999 -n 1)"
TEMP_PASS="1111"  # 生成随机密码
EXPIRE_TIME="2 hours"

# 2. 创建用户并设置密码
sudo useradd -m -s /bin/bash "$TEMP_USER"
echo "$TEMP_USER:$TEMP_PASS" | sudo chpasswd

# 3. 设定定时删除用户任务（使用 `at` 命令）
echo "sudo userdel -r $TEMP_USER" | at now + "$EXPIRE_TIME"

# 4. 获取 SSH 服务器 IP 和端口
SSH_IP=$(hostname -i | awk '{print $1}')  # 获取本机 IP
SSH_PORT=$(grep -E '^Port ' /etc/ssh/sshd_config | awk '{print $2}')
SSH_PORT=${SSH_PORT:-22}  # 如果未配置端口，则默认为 22

# 5. 输出 SSH 登录命令
echo "临时用户创建成功！"
echo "用户名: $TEMP_USER"
echo "密码: $TEMP_PASS"
echo "SSH 连接命令:"
echo "ssh $TEMP_USER@$SSH_IP -p $SSH_PORT"
echo "（请在 $EXPIRE_TIME 内使用，超时后用户将自动删除）"
