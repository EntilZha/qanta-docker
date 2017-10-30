FROM continuumio/anaconda3:4.4.0

RUN mkdir /qanta
RUN mkdir /qanta/bin
RUN mkdir /qanta/software
RUN mkdir /qanta/conf

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y texlive-latex-base texlive-latex-extra texlive-fonts-extra texlive-fonts-recommended
RUN apt-get install -y pdftk poppler-utils
RUN apt-get install -y build-essential cmake python-software-properties
RUN apt-get install -y libboost-program-options-dev libboost-python-dev libtool libboost-all-dev
RUN apt-get install -y liblzma-dev libpq-dev liblz4-tool zlib1g-dev
RUN apt-get install -y default-jre default-jdk
RUN apt-get install -y git wget vim tmux unzip

RUN conda install -y numpy scipy matplotlib nltk scikit-learn seaborn
ADD requirements.txt /qanta/requirements.txt
RUN pip install -r /qanta/requirements.txt

WORKDIR /qanta/software
RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz
RUN tar xzf spark-2.2.0-bin-hadoop2.7.tgz
RUN rm spark-2.2.0-bin-hadoop2.7.tgz

ENV JAVA_HOME /usr/lib/jvm/default-java
RUN git clone https://github.com/JohnLangford/vowpal_wabbit.git
WORKDIR /qanta/software/vowpal_wabbit
RUN git checkout 98b8038
RUN make
RUN make install
WORKDIR /qanta/software

RUN wget https://github.com/jgm/pandoc/releases/download/1.17.2/pandoc-1.17.2-1-amd64.deb
RUN ar p pandoc-1.17.2-1-amd64.deb data.tar.gz | tar xvz --strip-components 2 -C /usr/local
RUN rm pandoc-1.17.2-1-amd64.deb

RUN curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.2.tar.gz
RUN tar -xvf elasticsearch-5.6.2.tar.gz

RUN pip install glances gpustat

RUN conda install -y pytorch torchvision cuda80 -c soumith

ADD bin /qanta/bin
ADD conf /qanta/conf

RUN cp /qanta/conf/spark-defaults.conf /qanta/software/spark-2.2.0-bin-hadoop2.7/conf
RUN mkdir ~/.aws
RUN cp /qanta/conf/aws-config ~/.aws/config
RUN mkdir /var/log/luigi
RUN mkdir /etc/luigi
RUN cp /qanta/conf/client.cfg /etc/luigi/client.cfg

ENV QB_ROOT /qanta/qb
ENV QB_API_DOMAIN ""
ENV QB_API_USER_ID 1
ENV QB_API_KEY ""
ENV PYTHONPATH="${PYTHONPATH}:/qanta/qb:/qanta/software/spark-2.2.0-bin-hadoop2.7/python"
ENV SPARK_HOME /qanta/software/spark-2.2.0-bin-hadoop2.7

RUN mkdir /qanta/qb
WORKDIR /qanta/qb
VOLUME /qanta/qb

