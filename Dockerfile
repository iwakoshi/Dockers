FROM debian:latest

MAINTAINER Fabio Iwakoshi <fabio.iwakoshi@gmail.com>

ENV RELEASE_ECLIPSE http://download.eclipse.org/technology/epp/downloads/release/
ENV ECLIPSE_JEE /eclipse-jee-
ENV ECLIPSE_LINUX -linux-gtk.tar.gz
ENV INSTALLATION_DIR /opt/

RUN apt-get update \
 && apt-get install curl -y \
 \
 && curl -s https://raw.githubusercontent.com/iwakoshi/linux/master/add-apt-repository.sh -o /usr/sbin/apt-add-repository \
 && chmod +x /usr/sbin/apt-add-repository \
 \
 && apt-add-repository ppa:webupd8team/java -y \
 && apt-get update \
 && echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections \
 && apt-get install oracle-java8-installer oracle-java8-set-default oracle-java8-unlimited-jce-policy libxml2-utils -y \
 \
 && RELEASE=$(curl -s -G -L "$RELEASE_ECLIPSE"release.xml | xmllint --xpath '//present' - | sed '/^\/ >/d' | sed 's/<[^>]*.//g') \
 && RELEASE_HIFEN=$(echo $RELEASE | sed -e "s/\//-/g") \
 && curl "$RELEASE_ECLIPSE$RELEASE$ECLIPSE_JEE$RELEASE_HIFEN$ECLIPSE_LINUX" | tar vxz -C $INSTALLATION_DIR \
 && adduser --disabled-password --quiet --gecos '' eclipse \
 && chown -R root:eclipse $INSTALLATION_DIR/eclipse \
 && chmod -R 775 $INSTALLATION_DIR/eclipse \
 \
 && rm /usr/sbin/apt-add-repository \
 && apt-get --purge autoremove -y curl libxml2-utils \
 && apt-get clean

USER eclipse
ENTRYPOINT INSTALLATION_DIR/eclipse/eclipse