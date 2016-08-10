# Dockerfile to build a pynini container image

FROM ubuntu:16.04

MAINTAINER Arne Neumann <pynini.programming@arne.cl>

RUN apt-get update
RUN apt-get install wget build-essential git python2.7-dev python-pycurl python2.7-setuptools -y


# install geturl script to retrieve the most current download URLs (of Pynini, OpenFST)
WORKDIR /opt/
RUN git clone https://github.com/foutaise/grepurl.git


# install latest OpenFST release
WORKDIR /opt/
RUN wget $(/opt/grepurl/grepurl -r 'gz$' -a http://openfst.org/twiki/bin/view/FST/FstDownload | head -n 1)
RUN tar xfz openfst*.tar.gz
RUN mv $(ls -d openfst*/) openfst
WORKDIR /opt/openfst/
RUN ./configure --enable-far --enable-pdt --enable-mpdt --enable-static=no
RUN make
RUN make install


# install re2 directly from the repo
WORKDIR /opt/
RUN git clone https://github.com/google/re2.git
WORKDIR /opt/re2/
RUN make
RUN make test
RUN make install
RUN make testinstall
RUN ldconfig # otherwise pynini won't find libre2.so.0


# install latest pynini release
WORKDIR /opt/
RUN wget $(/opt/grepurl/grepurl -r 'gz$' -a http://openfst.cs.nyu.edu/twiki/bin/view/GRM/PyniniDownload | head -n 1)
RUN tar xfz pynini*.tar.gz
RUN mv $(ls -d pynini*/) pynini
WORKDIR /opt/pynini/
RUN python setup.py install
RUN python setup.py test

