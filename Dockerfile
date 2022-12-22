ARG CLAAT_VERSION=2.2.5

FROM tkhoa2711/debian-curl as claat

ARG CLAAT_VERSION
ENV CLAAT "${CLAAT_VERSION}"

COPY ["codelabs", "/codelabs/"]

RUN curl -SL "https://github.com/googlecodelabs/tools/releases/download/v$CLAAT/claat-linux-amd64" -o /usr/local/bin/claat && \
chmod u+x /usr/local/bin/claat && \
mkdir /exports && \
cd /exports && claat export /codelabs/*.md

FROM tkhoa2711/debian-curl as curl

ARG CLAAT_VERSION
ENV CLAAT ${CLAAT_VERSION}

RUN curl -SLO "https://github.com/googlecodelabs/tools/archive/refs/tags/v$CLAAT.tar.gz" && \
tar -xvzf "v$CLAAT_VERSION.tar.gz" -C /

FROM node:14.21.2-buster-slim

ARG CLAAT_VERSION

COPY --from=curl ["/tools-${CLAAT_VERSION}/site", "/site/"]
COPY --from=claat ["/exports/", "/site/codelabs/"]

WORKDIR /site

RUN npm install && \
npm install -g gulp-cli && \
npm cache clear --force

COPY opts.js /site/tasks/helpers/opts.js

EXPOSE 8000

ENTRYPOINT [ "gulp", "serve", "--codelabs-dir=codelabs" ]
