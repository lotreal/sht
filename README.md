### 1.1
* * *
### hg2c-docker-compose

当存在环境变量: ${DOCKER_COMPOSE_BRIDGE} 时，生成网络配置

### 1.2
* * *
### hg2c-exec

命令机制：在 docker ps 的输出里，grep FITER，搜索到容器的 cid （如有多个搜索结果，使用第一个）。docker exec -it 进去，附加指定的 COMMAND

例如：

>- hg2c-exec go
>- hg2c-exec go bash


### 1.3
* * *
### hg2c-golang

### 1.4
* * *
### hg2c-mvn

### 1.5
* * *
### hg2c-pull

docker pull 时，如果镜像以 hg2c/ 开头，就去阿里云容器镜像服务器拉取。

### 1.6
* * *
### hg2c-sync

>- hg2c-sync ub alpine

### 1.7
* * *
### hg2c-tomcat
