#!/bin/bash

while getopts ":a:p:n:" opt; do
  case $opt in
    a) addr_local="$OPTARG"
    ;;
    p) dir_path="$OPTARG"
    ;;
    n) app_name="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done

echo -e "<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin yourmail@example.com
        ServerAlias $addr_local
        DocumentRoot /var/www/$app_name/public

        <Directory /var/www/html/$app_name/public>
           Options -Indexes +FollowSymLinks +MultiViews
            AllowOverride All
            Require all granted
            <FilesMatch \.php$>
               #Change this "proxy:unix:/path/to/fpm.socket"
               #if using a Unix socket
               #SetHandler "proxy:fcgi://127.0.0.1:9000"
            </FilesMatch>
        </Directory>

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>" >> $app_name.conf

printf 'Copying config file\n'
sudo cp $app_name.conf /etc/apache2/sites-available/.

printf 'Enabling site\n'
sudo a2ensite $app_name

printf 'Reloading Apache Service\n'
sudo systemctl reload apache2

printf 'Copying directory to /var/www/\n'
sudo mkdir /var/www/$app_name
sudo cp -r  $dir_path/* /var/www/$app_name/.

printf 'Editing hosts file\n'
sudo echo "127.0.0.1 	$addr_local" | sudo tee -a /etc/hosts >/dev/null

printf "Sucessfully enabled VirtualHost for $app_name\n"
