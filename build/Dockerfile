#FROM ubuntu
FROM ubuntu:latest

RUN sed -i 's#archive.ubuntu.com#mirrors.aliyun.com#' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y git build-essential bison libevent-dev libjemalloc-dev libmysqlclient-dev libpcre3-dev libpq-dev libsqlite3-dev libssl-dev libz-dev libgtest-dev cmake libicu-dev \
        --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
