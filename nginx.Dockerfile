FROM nginx

ARG RAILS_ENV
ARG APP_NAME

RUN apt-get update -qq && apt-get -y install apache2-utils

ENV RAILS_ROOT /var/www
WORKDIR $RAILS_ROOT
RUN mkdir log

COPY "$RAILS_ENV.conf" /tmp/docker_example.nginx

RUN envsubst '$APP_NAME $RAILS_ROOT' < /tmp/docker_example.nginx > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]