FROM alpine:3.10

RUN apk --no-cache add \ 
      bash \
      curl \
      less \
      groff \
      jq \
      git \
      python \
      py-pip \
      py2-pip \
      mysql-client \
      gzip && \
      pip install --upgrade pip awscli s3cmd && \
      mkdir /root/.aws

ENV MYSQLDUMP_OPTIONS --quote-names --quick --add-drop-table --add-locks --allow-keywords --disable-keys --extended-insert --single-transaction --create-options --comments --net-buffer-length=16384
ENV MYSQLDUMP_DATABASES **All**
ENV MYSQLDUMP_TABLES **All**

ENV AWS_BUCKET **None**

ENV PREFIX **None**

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
