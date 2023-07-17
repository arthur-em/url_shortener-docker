# pull official base image 
FROM python:3.9.17-slim-bookworm

# set environment variables
# Prevents Python from writing pyc files to disc (equivalent to python -B option)
ENV PYTHONDONTWRITEBYTECODE 1 

# Prevents Python from buffering stdout and stderr (equivalent to python -u option)
ENV PYTHONUNBUFFERED 1

# install nginx remove default index page
RUN apt-get update && apt-get install nginx -y && rm /etc/nginx/sites-enabled/default

# copy our nginx configuration to overwrite nginx defaults
# COPY ./nginx/url_shortener.nginx.conf /etc/nginx/conf.d/default.conf
COPY ./nginx/url_shortener.nginx.conf /etc/nginx/conf.d/virtual.conf

# link nginx logs to container stdout
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

# copy flask code
COPY ./url_shortener /flask_app/
COPY ./config /flask_app/

# set work directory
WORKDIR /flask_app/

# install dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements3.txt

EXPOSE 80

# make our entrypoint.sh executable
RUN chmod +x entrypoint.sh

# execute our entrypoint.sh file
CMD ["./entrypoint.sh"]

