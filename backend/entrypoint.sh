#!/bin/bash

# Lancer selon APP_ENV
if [ "$APP_ENV" = "development" ]; then
    exec tail -f /dev/null
else
    exec php artisan serve --host=0.0.0.0 --port=8000
fi
