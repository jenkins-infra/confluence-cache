FROM ubuntu:14.04
MAINTAINER Jenkins Infra team <infra@lists.jenkins-ci.org>

RUN apt-get update && apt-get install -y nginx
