#!/bin/bash
echo ">> Entry point to CKG Docker"

echo ">> Running jupyterHub"
jupyterhub -f /etc/jupyterhub/jupyterhub.py --no-ssl &

echo ">> Running redis-server"
service redis-server start

echo ">> Running celery queues"
cd ckg/report_manager
celery -A ckg.report_manager.worker worker --loglevel=INFO --concurrency=1 -E -Q creation --uid 1500 --gid nginx &
celery -A ckg.report_manager.worker worker --loglevel=INFO --concurrency=3 -E -Q compute  --uid 1500 --gid nginx &
celery -A ckg.report_manager.worker worker --loglevel=INFO --concurrency=1 -E -Q update   --uid 1500 --gid nginx &

echo ">> Initiating CKG app"
touch /var/log/uwsgi/uwsgi.log && tail -f /var/log/uwsgi/uwsgi.log &
cd /CKG
nginx && uwsgi --ini /etc/uwsgi/apps-enabled/uwsgi.ini --uid 1500 --gid nginx