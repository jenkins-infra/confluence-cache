FROM ubuntu:14.04
MAINTAINER Jenkins Infra team <infra@lists.jenkins-ci.org>

# Where to proxy the request to?
ENV TARGET http://backend:8080

RUN apt-get update \
    && apt-get install -y nginx \
    && rm -rf /var/lib/apt/lists/* \
    && echo "\ndaemon off;" >> /etc/nginx/nginx.conf

ADD site.conf /etc/nginx/sites-enabled/default
ADD cache.conf /etc/nginx/conf.d/cache.conf
ADD launch.bash /

WORKDIR /etc/nginx
VOLUME ["/cache"]
CMD ["/launch.bash"]
EXPOSE 8080