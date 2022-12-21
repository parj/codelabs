FROM debian:11.6

ENV NODE_VERSION 14.21.2
ENV NPM_VERSION 9.2.0
ARG CLAAT_VERSION 2.2.5
ENV CLAAT_VERSION 2.2.5

RUN apt update && apt install -y --install-recommends python gpg curl dirmngr \
	&& apt-get clean autoclean \
	&& apt-get autoremove --yes \
	&& rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN gpg --batch --keyserver keyserver.ubuntu.com --recv-keys B9E2F5981AA6E0CD28160D9FF13993A75599653C C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
 	&& curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt" \
	&& curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.sig" \
	&& gpg --verify SHASUMS256.txt.sig SHASUMS256.txt \
	&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
	&& tar xvzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
	&& npm install -g npm@"$NPM_VERSION" \
	&& npm cache clear --force 

ENV PATH $PATH:/nodejs/bin

RUN curl -SLO "https://github.com/googlecodelabs/tools/releases/download/v$CLAAT_VERSION/claat-linux-amd64" && \
mv claat-linux-amd64 claat && \
chmod u+x claat && \
mv claat /usr/local/bin && \
curl -SLO "https://github.com/googlecodelabs/tools/archive/refs/tags/v$CLAAT_VERSION.tar.gz" && \
tar -xvzf "v$CLAAT_VERSION.tar.gz" -C /

WORKDIR /tools-${CLAAT_VERSION}/site

RUN npm install && \
npm install -g gulp-cli && \
npm cache clear --force

COPY opts.js /tools-2.2.5/site/tasks/helpers/opts.js

COPY ["codelabs", "/tools-${CLAAT_VERSION}/site/codelabs"]

RUN cd codelabs && claat export how-to-write-a-codelab.md

EXPOSE 8000

ENTRYPOINT [ "gulp", "serve", "--codelabs-dir=codelabs" ]
