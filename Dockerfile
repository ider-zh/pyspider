FROM python:3.7-stretch
MAINTAINER binux <roy@binux.me>

# install phantomjs
# RUN mkdir -p /opt/phantomjs \
#         && cd /opt/phantomjs \
#         && wget -O phantomjs.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
#         && tar xavf phantomjs.tar.bz2 --strip-components 1 \
#         && ln -s /opt/phantomjs/bin/phantomjs /usr/local/bin/phantomjs \
#         && rm phantomjs.tar.bz2


# install nodejs
ENV NODEJS_VERSION=8.15.0 \
    PATH=$PATH:/opt/node/bin

WORKDIR "/opt/node"

RUN apt-get -qq update && apt-get -qq install -y curl ca-certificates libx11-xcb1 libxtst6 libnss3 libasound2 libatk-bridge2.0-0 libgtk-3-0 --no-install-recommends && \
    curl -sL https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz | tar xz --strip-components=1 && \
    rm -rf /var/lib/apt/lists/*

# install requirements
COPY requirements.txt /opt/pyspider/requirements.txt
RUN pip install -r /opt/pyspider/requirements.txt -i https://mirrors.ustc.edu.cn/pypi/web/simple

# add all repo
ADD ./ /opt/pyspider

# run test
WORKDIR /opt/pyspider
RUN pip install -e .[all]
     
# isntall your package
RUN pip install arrow bs4 html5lib deep-diff dataset

RUN npm i cnpm -g \
    && cnpm i puppeteer express

VOLUME ["/opt/pyspider"]
ENTRYPOINT ["pyspider"]

EXPOSE 5000 23333 24444 25555 22222
