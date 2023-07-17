#!/bin/bash

echo "Initiating database"
sleep 10
flask db init
flask db migrate -m "initial migration"
flask db upgrade

echo "Starting to trigger gunicorn"
gunicorn --bind 0.0.0.0:8000 app:app --daemon &
sleep 5

echo "Starting Nginx Service"
nginx -g 'daemon off;'
