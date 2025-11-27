FROM nginx:latest

RUN rm /etc/nginx/conf.d/default.conf

# Copia o arquivo de configuração do reverse proxy
COPY proxy/proxy.conf /etc/nginx/conf.d/proxy.conf

EXPOSE 80