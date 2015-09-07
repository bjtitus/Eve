FROM ubuntu:14.04
MAINTAINER Brandon Titus <b@titus.io>
ADD . /eve
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    git \
    curl
RUN npm install -g typescript
RUN /eve/install-multirust.sh
RUN ln -s "$(which nodejs)" /usr/bin/node
RUN cd /eve/ui && tsc
RUN cd /eve/runtime && multirust override nightly-2015-08-10
RUN cd /eve/runtime && RUST_BACKTRACE=1 cargo build --bin=server --release
EXPOSE 8080
EXPOSE 2794
#ENTRYPOINT ["cargo", "run", "/eve/runtime", "--bin", "server", "--release"]
WORKDIR /eve/runtime
ENTRYPOINT ["./target/release/server"]
