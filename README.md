# Docker FluffOs

### 0. Intro

Docker 镜像 : FluffOS v2019 的 Ubuntu 编译环境。

此项目参考了 https://github.com/lostsnow/docker-fluffos ，更新为可以编译 FluffOs v2019 。

### 1. Build compile image

建立为编译 fluffos 源码的 docker 镜像，确定已经安装了 docker 1.12+ 和 git 。
>以下的命令可能需要 `su root` 或者 `sudo` ，假设我们在 `/XXXX/` 目录下操作。真正操作时，记得将下面代码中 `/XXXX/` 替换为相应的目录，即上面代码中你建立 `docker` 目录位置的绝对目录。
```bash
cd /XXXX/
mkdir docker
cd docker 
git clone https://github.com/zero9k/docker_fluffos.git
cd docker_fluffos
docker build -t zero9k/fluffos_build ./build
```
成功后，输入 `docker images` 指令可以看到 REPOSITORY 下增加了 ubuntu 和 zero9k/fluffos_build 两个 image，类似下面这样：
```bash
$ docker images
REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
zero9k/fluffos_build   latest              3b3444136461        3 hours ago         521MB
ubuntu                 latest              47b19964fb50        4 weeks ago         88.1MB
$
```

### 2. Compile driver

下载 fluffos 源码。
```bash
cd /XXXX/docker/
git clone https://github.com/fluffos/fluffos.git
```
利用镜像 fluffos_build 编译 fluffos 源码，生成驱动, 最终产生包括 driver 的 2 个二进制文件。 

```bash
docker run --rm -v /XXXX/docker:/opt/docker zero9k/fluffos_build
```
成功后，输入 `ls -la docker_fluffos/bin/` 指令可以看到 `driver` 和 `portbind` 两个二进制文件，注意日期，看是否新生成的。
(因为此项目已经包括编译好的二进制文件，当然你也可以直接使用，忽略以上步骤。^_^)

### 3. Build driver image

  生成 fluffos 驱动镜像，实际就是把 2 个二进制文件 copy 进 docker image ，同时安装其运行需要的依赖库。
```bash
cd /XXXX/docker/
docker build -t zero9k/fluffos ./docker_fluffos
``` 
成功后，输入 `docker images` 指令可以看到 REPOSITORY 下增加了 zero9k/fluffos，类似下面这样：
```
$ docker images
REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
zero9k/fluffos         latest              cf1eda359956        2 hours ago         133MB
zero9k/fluffos_build   latest              3b3444136461        3 hours ago         521MB
ubuntu                 latest              47b19964fb50        4 weeks ago         88.1MB
$
```

### 4. run mudlib

  运行 MUD ，即用 fluffos 驱动 mudlib ，比如 fy/xkx/xyj 等(https://github.com/mudchina/ 有一些mudlib)。以下的代码以 fy4 为参考，可能需要修改源码 (那涉及到如何让 fluffos 可以跑 mudos v22 的老lib，不在本文讨论范围内，请自行学习)。
>准备好修改好的 config 文件 (fluffos 源码中有样例，根据需求修改)，假设位置为 `/home/cfg/config.fy` ，假设修改后端口为 6666。
```bash
cd docker
mkdir mudlib
cd mudlib
git clone https://github.com/huangleon/fy4.git
cp /home/cfg/config.fy fy4/config.fy
docker run -d --name fy4 \
    -p 6666:6666 \
    -v XXXX/docker/mudlib/fy4/:/opt/docker \
    zero9k/fluffos /opt/projects/config.fy
```
成功后，输入 `docker ps` 指令可以看到 `0.0.0.0:6666->6666/tcp`，失败可以输入 `docker logs -f fy4` 指令查看 log，也可以进一步查看 mudlib 的 debug.log (比如 `tail -f /XXXX/docker/mudlib/fy4/log/debug.log`)。
