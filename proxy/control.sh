#!/bin/bash

# Nome do projeto baseado no diretório atual
PROJECT_NAME=$(basename "$(pwd)")

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

function build_services() {
    echo -e "${GREEN}>>> Construindo as imagens Docker...${NC}"
    docker-compose -p $PROJECT_NAME build
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Imagens construídas com sucesso!${NC}"
    else
        echo -e "${RED}Erro ao construir as imagens.${NC}"
    fi
}

function start_services() {
    echo -e "${GREEN}>>> Iniciando os containers (detached mode)...${NC}"
    docker-compose -p $PROJECT_NAME up -d
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Serviços iniciados com sucesso!${NC}"
        echo ""
        echo "A infraestrutura está rodando."
        echo "Para testar, configure o DNS do seu host para o IP do container DNS (172.20.0.2)."
        echo "Ou use o comando: dig @127.0.0.1 -p 53 www.natanael.asa.br"
        echo "Acesse: http://www.natanael.asa.br e http://mail.natanael.asa.br"
    else
        echo -e "${RED}Erro ao iniciar os serviços.${NC}"
    fi
}

function stop_services() {
    echo -e "${RED}>>> Parando os containers...${NC}"
    docker-compose -p $PROJECT_NAME stop
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Serviços parados com sucesso.${NC}"
    else
        echo -e "${RED}Erro ao parar os serviços.${NC}"
    fi
}

function remove_services() {
    echo -e "${RED}>>> Removendo containers, volumes e redes...${NC}"
    docker-compose -p $PROJECT_NAME down -v
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Infraestrutura removida com sucesso.${NC}"
    else
        echo -e "${RED}Erro ao remover a infraestrutura.${NC}"
    fi
}

function usage() {
    echo "Uso: $0 [comando]"
    echo ""
    echo "Comandos disponíveis:"
    echo "  build   : Constrói as imagens Docker."
    echo "  up      : Constrói (se necessário) e inicia todos os serviços em segundo plano (Modo 'detached')."
    echo "  start   : Inicia containers que estão parados."
    echo "  stop    : Para os containers em execução."
    echo "  down    : Para e remove containers, redes e volumes (Infraestrutura completa)."
    echo ""
    echo "Exemplo: ./control.sh up"
}

# Lógica principal do script
case "$1" in
    build)
        build_services
        ;;
    up)
        build_services
        start_services
        ;;
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    down)
        remove_services
        ;;
    *)
        usage
        exit 1
        ;;
esac

exit 0


