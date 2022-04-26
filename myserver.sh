#!/bin/bash
# (@)/myserver.sh

if [ $# -lt 1 ] ; then
    echo "What did you wanted!?"
     exit 1
fi
APACHE_PATH="`which apache2`"
if [ $1 = "check" ] ; then
    echo $APACHE_PATH
    if [ -z "$APACHE_PATH" ] ; then
        echo "Contact admin"	    
            exit 1
    fi
fi
if [ $1 = "start" ] ; then
    sudo service apache2 status
fi

if [ $1 = "domain" ] ; then
    if [ -z "$2" ] ; then
        echo "You didn't added domain name"
	    exit 1
    else
        sudo sed -i "1s/^/127.0.0.1   $2\n/" /etc/hosts    
	sudo mkdir -p /var/www/$2
	sudo chown -R $USER:$USER /var/www/$2
	sudo chmod -R 755 /var/www
	touch /var/www/$2/index.php
	echo -e  "<?php\n\techo phpinfo();\n?>\n" > /var/www/$2/index.php
	sudo touch /etc/apache2/sites-available/$2
	echo -e "<VirtualHost *:80>\n\tServerName $2\n\tServerAdmin yourmail@com\n\tDocumentRoot /var/www/$2\n\tErrorLog /etc/apache2/error.log\n\tCustomLog /etc/apache2/access.log combined\n</VirtualHost>" | sudo tee /etc/apache2/sites-available/$2.conf
	sudo a2ensite $2.conf
	systemctl reload apache2
	sudo ln -s /var/www /home/$USER/MySites
    fi
fi  
