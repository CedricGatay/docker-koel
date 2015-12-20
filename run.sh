#!/usr/bin/env bash
php artisan init
echo "Fixing permissions on storage directory"
chown -R koel:koel /app/koel/storage
chmod -R g+w /app/koel/storage #to allow www-data to write logs
exec apache2-foreground