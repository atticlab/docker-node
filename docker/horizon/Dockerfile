FROM golang:1.6

#ENV http_proxy http://10.78.17.6:3128
#ENV https_proxy http://10.78.17.6:3128

RUN apt-get update && apt-get install -y \
	git \
	&& go get github.com/constabulary/gb/...

WORKDIR /vhosts

RUN git clone -b nbu0.2 --depth 1 https://github.com/atticlab/horizon.git horizon

WORKDIR /vhosts/horizon

RUN gb vendor restore
RUN gb build

COPY ./entrypoint.sh /

ENV http_proxy=
ENV https_proxy=

CMD ["/entrypoint.sh"]
