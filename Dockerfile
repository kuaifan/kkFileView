FROM ubuntu:24.04

RUN apt-get update &&\
    export DEBIAN_FRONTEND=noninteractive &&\
	apt-get install -y --no-install-recommends openjdk-8-jre tzdata locales xfonts-utils fontconfig libreoffice-nogui &&\
    echo 'Asia/Shanghai' > /etc/timezone &&\
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 &&\
    locale-gen zh_CN.UTF-8 &&\
    apt-get install -y --no-install-recommends ttf-mscorefonts-installer &&\
    apt-get install -y --no-install-recommends ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy &&\
	apt-get autoremove -y &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

# 内置一些常用的中文字体，避免普遍性乱码
ADD docker/kkfileview-base/fonts/* /usr/share/fonts/chinese/

RUN cd /usr/share/fonts/chinese &&\
    # 安装字体
    mkfontscale &&\
    mkfontdir &&\
    fc-cache -fv

ENV LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8

ADD server/target/kkFileView-*.tar.gz /opt/
ENV KKFILEVIEW_BIN_FOLDER=/opt/kkFileView-4.4.0/bin
ENTRYPOINT ["java","-Dfile.encoding=UTF-8","-Dspring.config.location=/opt/kkFileView-4.4.0/config/application.properties","-jar","/opt/kkFileView-4.4.0/bin/kkFileView-4.4.0.jar"]
