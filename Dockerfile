FROM ubuntu:14.04
MAINTAINER Jenkins Infra team <infra@lists.jenkins-ci.org>

RUN apt-get update \
    && apt-get install -y nginx \
    && rm -rf /var/lib/apt/lists/* \
    && echo "\ndaemon off;" >> /etc/nginx/nginx.conf

ADD site.conf /etc/nginx/sites-enabled/default

WORKDIR /etc/nginx
CMD ["nginx"]
EXPOSE 8080