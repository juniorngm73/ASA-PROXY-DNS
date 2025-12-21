Atividade Proxy-DNS

Neste repositório, foi criada uma infraestrutura containerizada composta por:

Um servidor DNS (BIND9);
Um proxy reverso HTTP/HTTPS (Nginx);
Dois servidores web (Nginx):
web_mail; ─web_www. 
script para automação das tarefas (control.sh). 
Conforme  a arvore de diretórios.

    control.sh
│   docker-compose.yml
│   README.md
│
├───dns
│       db.natanael.asa.br
│       Dockerfile
│       named.conf.local
│       named.conf.options
│
├───proxy
│       Dockerfile
│       proxy.conf
│
├───web_mail
│       Dockerfile
│       index.html
│
└───web_www
        Dockerfile
        index.html
O ambiente foi orquestrado usando Docker Compose, permitindo rodar todos os serviços de forma isolada;
porém conversando por meio de uma rede Docker interna.


1. docker-compose.yml
Orquestra todos os serviços (DNS, proxy e web servers) em uma rede Docker interna. Define IPs estáticos e mapeamento de portas.

2. dns
Dockerfile: cria a imagem Ubuntu com BIND9 instalado.
named.conf.options: configurações globais.
named.conf.local: define a zona natanael.asa.br como master.
db.natanael.asa.br : arquivo de zona DNS contendo registros SOA, NS e A para cada subdomínio.

3. proxy
Dockerfile: cria a imagem Nginx-Latest com configuração nginx.conf.
proxy.conf: define blocos server separados para cada subdomínio em HTTP.

4. web
Pasta contendo 2 subdiretórios.
web_mail / web_www
Dockerfile: cria a imagem Nginx-Latest
index.html: página HTML personalizada para a cada pagina.

5. script control.sh automatiza as tarefas conforme os comandos:
    build   : Constrói as imagens Docker.
    up      : Constrói (se necessário) e inicia todos os serviços em segundo plano.
    start   : Inicia containers que estão parados.
    stop    : Para os containers em execução.
    down    : Para e remove containers e redes (Infraestrutura completa).
    