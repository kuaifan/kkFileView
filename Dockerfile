FROM ubuntu:20.04
MAINTAINER chenjh "842761733@qq.com"
COPY docker/kkfileview-jdk/fonts/* /usr/share/fonts/chinese/
RUN apt-get clean && apt-get update &&\
	apt-get install -y locales && apt-get install -y language-pack-zh-hans &&\
	localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 && locale-gen zh_CN.UTF-8 &&\
    export DEBIAN_FRONTEND=noninteractive &&\
	apt-get install -y tzdata && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
	apt-get install -y libxrender1 && apt-get install -y libxt6 && apt-get install -y libxext-dev && apt-get install -y libfreetype6-dev &&\
	apt-get install -y wget && apt-get install -y ttf-mscorefonts-installer && apt-get install -y fontconfig &&\
	apt-get install -y ttf-wqy-microhei &&\
	apt-get install -y ttf-wqy-zenhei &&\
	apt-get install -y xfonts-wqy &&\
    apt-get install -y openjdk-8-jdk software-properties-common &&\
    add-apt-repository ppa:libreoffice/ppa -y &&\

#	安装 OpenOffice
#	wget https://kkfileview.keking.cn/Apache_OpenOffice_4.1.6_Linux_x86-64_install-deb_zh-CN.tar.gz -cO openoffice_deb.tar.gz &&\
#	tar -zxf /tmp/openoffice_deb.tar.gz && cd /tmp/zh-CN/DEBS &&\
#	dpkg -i *.deb && dpkg -i desktop-integration/openoffice4.1-debian-menus_4.1.6-9790_all.deb &&\

#	安装 libreoffice \
    apt-get install -y libreoffice &&\
    cd /usr/share/fonts/chinese &&\
    mkfontscale &&\
    mkfontdir &&\
    fc-cache -fv

ENV LANG zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
ENV KK_FILE_UPLOAD_ENABLED false
ENV KK_FILE_DIR /var/kkfileview/data
ENV KKFILEVIEW_BIN_FOLDER /opt/kkFileView/bin

ADD server/target/kkFileView-*.tar.gz /opt/
ENV KKFILEVIEW_BIN_FOLDER /opt/kkFileView-4.4.0-SNAPSHOT/bin
ENTRYPOINT ["java","-Dfile.encoding=UTF-8","-Dspring.config.location=/opt/kkFileView-4.4.0-SNAPSHOT/config/application.properties","-jar","/opt/kkFileView-4.4.0-SNAPSHOT/bin/kkFileView-4.4.0-SNAPSHOT.jar"]
