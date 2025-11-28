FROM ubuntu:latest

# Instala Bind9 e ferramentas DNS
RUN apt update -y && apt install bind9 dnsutils -y

# Cria e garante que os diretórios essenciais (cache e lib) sejam de propriedade do usuário 'bind'
# O BIND precisa gravar no cache, e o usuário 'bind' é quem executa o processo.

RUN mkdir -p /var/cache/bind 
RUN chown -R bind:bind /var/cache/bind /etc/bind
RUN chmod 775 /var/cache/bind

# Copia os arquivos de configuração. Eles são copiados como 'root'.
COPY dns/named.conf.local /etc/bind/named.conf.local
COPY dns/db.natanael.asa.br /etc/bind/db.natanael.asa.br
COPY dns/named.conf.options /etc/bind/named.conf.options

# *** CORREÇÃO CRÍTICA ***
# Altera a propriedade dos arquivos de configuração para o usuário 'bind'
# Isso resolve o erro 'parsing failed: permission denied' no /etc/bind/
RUN chown -R bind:bind /etc/bind/
RUN chmod -R a+rX /etc/bind/

# Permite acesso externo (Host) à porta 53 TCP/UDP
EXPOSE 53/tcp
EXPOSE 53/udp

# Comando de inicialização


CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]