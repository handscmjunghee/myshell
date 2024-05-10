#!/bin/bash

# 定义变量
MYSQL_ROOT_PASSWORD="123456"
MYSQL_PORT=13306

# 拉取 MySQL 镜像
#docker pull mysql:latest

# 启动 MySQL 容器
docker run -d \
    --name mysql_container \
    -p $MYSQL_PORT:3306 \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
    my-mysql

# 输出启动成功信息
echo "MySQL容器已启动，端口号: $MYSQL_PORT，root密码: $MYSQL_ROOT_PASSWORD"

