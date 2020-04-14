FROM openjdk:8-jre-alpine

ENV ANSIBLE_VERSION=2.9.2

RUN set -xe \
    && apk add --no-cache --progress python3 openssl \
		ca-certificates git openssh sshpass \
	&& apk --update add --virtual build-dependencies \
		python3-dev libffi-dev openssl-dev build-base \
	\
    && pip3 install --upgrade pip \
	&& pip3 install ansible==${ANSIBLE_VERSION} boto3 \
    \
	&& apk del build-dependencies \
	&& rm -rf /var/cache/apk/*

RUN set -xe \
    && mkdir -p /etc/ansible \
    && echo -e "[local]\nlocalhost ansible_connection=local" > \
        /etc/ansible/hosts

RUN apk --no-cache add --update bash openssl

WORKDIR /flyway

ENV FLYWAY_VERSION 6.3.3

RUN wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && tar -xzf flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && mv flyway-${FLYWAY_VERSION}/* . \
  && rm flyway-commandline-${FLYWAY_VERSION}.tar.gz

RUN ln -s /flyway/flyway /usr/local/bin

