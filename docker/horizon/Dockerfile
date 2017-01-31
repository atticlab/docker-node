FROM golang:1.6

ENV http_proxy http://10.78.17.6:3128
ENV https_proxy http://10.78.17.6:3128

RUN apt-get update && apt-get install -y \
	git \
	&& go get github.com/constabulary/gb/...

WORKDIR /vhosts

RUN git config --global url."https://attic_lab:2M42XDLqKcHBmtNECwQc@bitbucket.org/".insteadOf "https://bitbucket.org/" \
	&& git clone -b nbu0.1 --depth 1 https://bitbucket.org/atticlab/horizon.git horizon

WORKDIR /vhosts/horizon

RUN gb vendor restore
RUN gb build

COPY ./entrypoint.sh /

CMD ["/entrypoint.sh"]
