FROM fholzer/nginx-brotli

RUN apk add --no-cache bash certbot
RUN true \
    && apk update && apk upgrade \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \
    && rm /etc/nginx/nginx.conf

ADD ./docker/nginx/gzip.conf /etc/nginx/conf.d/
ADD ./docker/nginx/brotli.conf /etc/nginx/conf.d/
ADD ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/app.conf.template /etc/nginx/conf.d/app.conf.template
COPY ./docker/nginx/nginx-entrypoint.sh /nginx-entrypoint.sh
RUN chmod +x /nginx-entrypoint.sh \
    && dos2unix /nginx-entrypoint.sh
#The ENTRYPOINT will generate the correct configuration default.conf file, replacing the environment variables
ENTRYPOINT ["/nginx-entrypoint.sh"]


RUN echo "upstream php-upstream { server php:9000; }" > /etc/nginx/conf.d/upstream.conf

RUN set -x ; \
    addgroup -g 82 -S www-data ; \
    adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1


#RUN printf "127.0.0.1 symfony-docker.localhost" >> /etc/hosts \
#   && printf "127.0.0.1 www.symfony-docker.localhost" >> /etc/hosts

#RUN mkdir -p /etc/nginx/conf.d/ssl
#ADD ssl/cert.pem /etc/nginx/conf.d/ssl/
#ADD ssl/cert.key /etc/nginx/conf.d/ssl/

#COPY ./app /var/www/app

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
