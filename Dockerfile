FROM ubuntu:18.04

WORKDIR /var/www/html
VOLUME /var/www/html

RUN apt-get update -y
RUN apt-get install -y gnupg tzdata

RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
    && echo "deb http://ppa.launchpad.net/nginx/development/ubuntu bionic main" > /etc/apt/sources.list.d/ppa_nginx_mainline.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C \
    && apt-get update \
    && apt-get install -y curl zip unzip git supervisor sqlite3 dos2unix vim nano htop \
    && apt-get install -y nginx php7.2-fpm php7.2-cli \
       php7.2-pgsql php7.2-sqlite3 php7.2-gd \
       php7.2-curl php7.2-memcached php7.2-redis \
       php7.2-imap php7.2-mysql php7.2-mbstring \
       php7.2-xml php7.2-zip php7.2-bcmath php7.2-soap \
       php7.2-intl php7.2-readline php7.2-mongodb \
       php7.2-msgpack php7.2-igbinary php7.2-xdebug \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && sed -i "s/user\ \=.*/user\ \= $WWWUSER/g" /etc/php/7.2/fpm/pool.d/www.conf \
    && mkdir /run/php \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

COPY xdebug.ini /etc/php/7.2/mods-available/xdebug.ini

COPY start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

EXPOSE 80
CMD ["start-container"]
