FROM debian:latest

MAINTAINER Fabio Iwakoshi <fabio.iwakoshi@gmail.com>

ENV INSTALLATION_DIR /opt

RUN apt-get update \
 && apt-get install curl -y \
 && curl -s https://raw.githubusercontent.com/iwakoshi/linux/master/add-apt-repository.sh -o /usr/sbin/apt-add-repository \
 && chmod +x /usr/sbin/apt-add-repository \
 && apt-add-repository ppa:webupd8team/java

RUN apt-get update \
 && echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections \
 && apt-get install oracle-java8-installer oracle-java8-set-default oracle-java8-unlimited-jce-policy libxml2-utils -y

RUN RELEASE=$(curl -s -G -L http://download.eclipse.org/technology/epp/downloads/release/release.xml | xmllint --xpath '//present' - | sed '/^\/ >/d' | sed 's/<[^>]*.//g') \
 && RELEASE_HIFEN=$(echo $RELEASE | sed -e "s/\//-/g") \
 && curl "http://download.eclipse.org/technology/epp/downloads/release/${RELEASE}/eclipse-jee-${RELEASE_HIFEN}-linux-gtk-x86_64.tar.gz" | tar vxz -C $INSTALLATION_DIR

RUN export uid=1000 gid=1000 \
 && echo "eclipse:x:${uid}:${gid}:Developer,,,:/home/eclipse:/bin/bash" >> /etc/passwd \
 && echo "eclipse:x:${uid}:" >> /etc/group \
 && echo "eclipse ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && chmod 0440 /etc/sudoers \
 && chown -R ${uid}:${gid} $INSTALLATION_DIR/eclipse \
 && chmod -R 775 $INSTALLATION_DIR/eclipse \
 && $(sed -i -e s/'--launcher.appendVmargs'/'--launcher.GTK_version\n2\n--launcher.appendVmargs'/g $INSTALLATION_DIR/eclipse/eclipse.ini) \
 \
 && rm /usr/sbin/apt-add-repository \
 && apt-get --purge autoremove -y curl libxml2-utils \
 && apt-get clean

RUN apt-get install libswt-gtk-3-java -y \
 && mkdir -p /home/eclipse/workspace \
 && chown -R ${uid}:${gid} /home/eclipse/workspace

VOLUME ["/home/eclipse/workspace"]

# Autorun
ENTRYPOINT $INSTALLATION_DIR/eclipse/eclipse
