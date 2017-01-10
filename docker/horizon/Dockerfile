FROM golang:1.6

RUN apt-get update && apt-get install -y \
	git \
	&& go get github.com/constabulary/gb/...

WORKDIR /vhosts

RUN git config --global url."https://attic_lab:2M42XDLqKcHBmtNECwQc@bitbucket.org/".insteadOf "https://bitbucket.org/" \
	&& git clone -b $BRANCH https://bitbucket.org/atticlab/horizon.git horizon

WORKDIR /vhosts/horizon

RUN gb vendor restore
RUN gb build

COPY ./entrypoint.sh /

CMD ["/entrypoint.sh"]