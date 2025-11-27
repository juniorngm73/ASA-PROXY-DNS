FROM ubuntu:latest

# Instala Bind9 e ferramentas DNS
RUN apt update -y && apt install bind9 dnsutils -y
RUN chown -R bind:bind /var/cache/bind
RUN chown -R bind:bind /var/lib/bind

# Copia os arquivos de configuração de zona e local
COPY dns/named.conf.local /etc/bind/named.conf.local
COPY dns/db.natanael.asa.br /etc/bind/db.natanael.asa.br
COPY dns/named.conf.options /etc/bind/named.conf.options

# Permite acesso externo (Host) à porta 53 TCP/UDP
EXPOSE 53/tcp
EXPOSE 53/udp

# Configuração para que o Bind escute em todas as interfaces
RUN sed -i 's/OPTIONS="-u bind"/OPTIONS="-u bind -4 -L 0.0.0.0"/' /etc/default/named

# Comando de inicialização
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]