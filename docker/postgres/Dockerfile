FROM postgres:9.5
ENV http_proxy http://10.78.17.6:3128
ENV https_proxy http://10.78.17.6:3128
COPY scripts/init.sh /docker-entrypoint-initdb.d/
