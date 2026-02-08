FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y

RUN apt install -y \
    postfix \
    dovecot-imapd \
    dovecot-pop3d \
    vim \
    dnsutils \
    iputils-ping \
    telnet \
    sudo

# --- CRIAÇÃO DO USUÁRIO ---
# Criamos o usuário com diretório home para persistência de e-mails
RUN useradd -m aluno && echo "aluno:123456" | chpasswd

# Copia as configurações do Postfix
COPY main.cf /etc/postfix/main.cf

# CORREÇÃO DE PERMISSÕES POSTFIX:
RUN mkfifo /var/spool/postfix/public/pickup \
    && chown root:postdrop /var/spool/postfix/public/pickup \
    && chmod 622 /var/spool/postfix/public/pickup

# CRIAÇÃO DO SCRIPT DE INICIALIZAÇÃO MELHORADO:
# O script agora configura o Dovecot para o Webmail automaticamente
RUN echo '#!/bin/bash\n\
# Ajustes de segurança para permitir Webmail (Plaintext)\n\
sed -i "s/#disable_plaintext_auth = yes/disable_plaintext_auth = no/" /etc/dovecot/conf.d/10-auth.conf\n\
sed -i "s/auth_mechanisms = plain/auth_mechanisms = plain login/" /etc/dovecot/conf.d/10-auth.conf\n\
sed -i "s/ssl = yes/ssl = no/" /etc/dovecot/conf.d/10-ssl.conf\n\
\n\
# Corrigir permissões e iniciar serviços\n\
postfix set-permissions\n\
service dovecot start\n\
postfix start-fg' > /start.sh && chmod +x /start.sh

# Usamos o script para iniciar o container
CMD ["/start.sh"]