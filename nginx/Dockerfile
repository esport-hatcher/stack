FROM nginx
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./nginx-selfsigned.crt /etc/nginx/conf.d/nginx-selfsigned.crt
COPY ./nginx-selfsigned.key /etc/nginx/conf.d/nginx-selfsigned.key
COPY ./dhparam.pem /etc/nginx/conf.d/dhparam.pem