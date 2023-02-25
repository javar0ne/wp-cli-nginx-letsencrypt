#!/bin/bash -e

HOST=$(echo $WORDPRESS_DB_HOST | cut -d: -f1)
PORT=$(echo $WORDPRESS_DB_HOST | cut -d: -f2)

until mysql -h $HOST -P $PORT -D $WORDPRESS_DB_NAME -u $WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD -e '\q'; do
  echo "mysql is not up yet!"
  echo "sleeping..."
  sleep 5
done

echo "mysql is up!"
echo "Trying to install wp, plugins and themes.."

wp core install \
  --path=$WORDPRESS_PATH \
  --url=$WORDPRESS_HOST \
  --title=$WORDPRESS_TITLE \
  --admin_user=$WORDPRESS_ADMIN_USER \
  --admin_password=$WORDPRESS_ADMIN_PASSWORD \
  --admin_email=$WORDPRESS_ADMIN_EMAIL
  --locale=$WORDPRESS_LOCALE

#install parent theme
#wp theme install $WORDPRESS_THEME_NAME
if !(wp theme is-installed $WORDPRESS_THEME_NAME) then
  wp theme install $WORDPRESS_THEME_NAME
else
  echo "Theme $WORDPRESS_THEME_NAME already installed!"
fi
#child-theme creation
#wp scaffold child-theme $WORDPRESS_THEME_CHILD_NAME --parent_theme=$WORDPRESS_THEME_NAME --activate

#activate child theme
#wp theme activate $WORDPRESS_THEME_CHILD_NAME

#if !(wp plugin is-installed yith-woocommerce-quick-view) then
#  wp plugin install /plugins/yith-woocommerce-quick-view.zip
#else
#  echo "Plugin yith-woocommerce-quick-view already installed!"
#fi
