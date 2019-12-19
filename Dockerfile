FROM openjdk:8u191-jdk-alpine

MAINTAINER sabatmonk
LABEL version=1.2

RUN apk update

RUN	apk add --no-cache curl wget zip unzip git bash \
    git \
    graphviz \
    python \
    ruby \
    py-pygments \
    libc6-compat \
    openssh \
    ttf-dejavu && \
    gem install rdoc --no-document && \
    gem install pygments.rb

RUN git clone --recursive https://github.com/docToolchain/docToolchain.git docToolchain && \
    cd docToolchain && \
    rm -rf .git && \
    rm -rf resources/asciidoctor-reveal.js/.git && \
    rm -rf resources/reveal.js/.git && \
    PATH="/docToolchain/bin:${PATH}"

ENV PATH="/docToolchain/bin:${PATH}"
#this initialise gradle to latest version, so the execution is quicker later
WORKDIR /docToolchain
RUN ./gradlew -b init.gradle initArc42EN -PnewDocDir=/project

RUN rm -R /project/*
WORKDIR /project

VOLUME /project

ENTRYPOINT ["/docToolchain/bin/doctoolchain"]
