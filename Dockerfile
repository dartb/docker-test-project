FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive

# Install base packages
RUN apt-get update
RUN apt-get install -y python-software-properties software-properties-common
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2 -y && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y && apt-get update
RUN apt-get install -y --allow-unauthenticated \
	apache2 \
	libapache2-mod-php7.0 \
	php7.0 \
	php7.0-cli && \
    rm -rf /var/lib/apt/lists/*

#Copy apache configuration
ADD container_support/000-default.conf /etc/apache2/sites-available/000-default.conf

#Copy shell script and make executable
ADD container_support/run.sh /run.sh
RUN chmod 755 /*.sh

#Make web root if it does not exist and copy contents of app directory to web root
RUN mkdir -p /var/www/html
ADD app/*  /var/www/html/

#Set permissions on web root
RUN chown www-data:www-data /var/www/html -R
RUN chmod a+x /var/www/html -R

EXPOSE 80
WORKDIR /var/www/html/
CMD ["/run.sh"]
