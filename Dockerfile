FROM phusion/baseimage:0.9.12
MAINTAINER Luis Arias <luis@balsamiq.com>

ENV HOME /root

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget nginx-full apache2-utils supervisor

WORKDIR /opt
RUN wget --no-check-certificate -O- https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz | tar xvfz -
ADD config/config.js /opt/kibana-3.1.0/config.js
RUN mkdir /etc/kibana # This is where the htpasswd file is placed by the run script

ADD nginx_config /opt/nginx_config
RUN chmod +x /opt/nginx_config

ADD config/etc /etc
RUN rm /etc/nginx/sites-enabled/*
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ENV KIBANA_SECURE true
ENV KIBANA_USER kibana
ENV KIBANA_PASSWORD kibana

### Configure runit
RUN mkdir /etc/service/nginx
ADD runit/nginx.sh /etc/service/nginx/run

EXPOSE 80

CMD ["/sbin/my_init"]
