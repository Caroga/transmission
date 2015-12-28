FROM phusion/baseimage:0.9.15
MAINTAINER roberto@caro.ga

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Set correct environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV HOME            /root
ENV LC_ALL          C.UTF-8
ENV LANG            en_US.UTF-8
ENV LANGUAGE        en_US.UTF-8
ENV USERNAME="transmission" \
    PASSWORD="password"
# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

#########################################
##  FILES, SERVICES AND CONFIGURATION  ##
#########################################

RUN add-apt-repository -y ppa:transmissionbt/ppa && \
    apt-get -q update && \
    apt-get install -qy --force-yes transmission-daemon ca-certificates wget tar curl unrar-free procps && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

ADD ./start.sh /start.sh
ADD ./settings.json /var/lib/transmission-daemon/info/settings.json
RUN chmod u+x  /start.sh

#########################################
##         EXPORTS AND VOLUMES         ##
#########################################

VOLUME ["/downloads", "/incomplete", "/watch", "/config"]

EXPOSE 9091 45555

#########################################
##                 RUN                 ##
#########################################

CMD ["/start.sh"]