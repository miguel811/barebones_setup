FROM nginx
COPY ./default.conf /etc/nginx/conf.d/default.conf


RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "vim"]
