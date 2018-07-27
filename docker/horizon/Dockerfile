FROM golang:1.6

RUN apt-get update && apt-get install -y \
	git \
	&& go get github.com/constabulary/gb/...

WORKDIR /vhosts

RUN git clone -b smar2.0 --depth 1 https://github.com/atticlab/horizon horizon

WORKDIR /vhosts/horizon

RUN gb vendor restore
RUN go get github.com/visionmedia/go-debug
RUN gb build

COPY ./entrypoint.sh /

CMD ["/entrypoint.sh"]
