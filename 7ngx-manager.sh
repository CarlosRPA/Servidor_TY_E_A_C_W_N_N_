#!/bin/bash

#########################################################

clear

echo -e "\e[32m

        ██████╗ ██╗   ██╗    ██████╗ ██████╗  █████╗ 
        ██╔══██╗╚██╗ ██╔╝    ██╔══██╗██╔══██╗██╔══██╗
        ██████╔╝ ╚████╔╝     ██████╔╝██████╔╝███████║
        ██╔══██╗  ╚██╔╝      ██╔══██╗██╔═══╝ ██╔══██║
        ██████╔╝   ██║       ██║  ██║██║     ██║  ██║
        ╚═════╝    ╚═╝       ╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝\e[0m"
echo -e "\e[32m                          BY RPA                                      \e[0m"
echo -e "\e[32m                  AUTOR ==> CARLOS FRAZÃO <==                           \e[0m"
echo -e "\e[32m\e[0m"

#########################################################

# Função para instalar Docker e Docker Compose, se necessário
install_docker() {
  if ! [ -x "$(command -v docker)" ]; then
    curl -fsSL https://get.docker.com | sh && \
    sudo usermod -aG docker $USER
  fi

  if ! [ -x "$(command -v docker-compose)" ]; then
    sudo apt-get install docker-compose -y
  fi
}

# Função para atualizar o sistema e instalar dependências
update_and_install() {
  apt update
  apt upgrade -y
  apt install -y curl sqlite3 docker.io docker-compose ufw
}

# Função para criar diretórios e rede Docker
setup_directories_and_network() {
  mkdir -p ~/nginxproxymanager/databases
  touch ~/nginxproxymanager/databases/nginxproxy.db

  if ! docker network inspect nginxproxyman &>/dev/null; then
      docker network create nginxproxyman
  fi
}

# Função para criar arquivo docker-compose.yml
create_docker_compose_file() {
  cat > ~/nginxproxymanager/docker-compose.yml <<EOL
version: '3.7'
services:
  proxy:
    image: 'jc21/nginx-proxy-manager:latest'
    container_name: nginx-proxy-manager
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    networks:
      - proxy_manager
networks:
  proxy_manager:
EOL
}

# Função para iniciar Nginx Proxy Manager
start_nginx_proxy_manager() {
  cd ~/nginxproxymanager
  docker-compose up -d
  echo "Nginx Proxy Manager instalado e configurado com sucesso."
}

clear

# Função principal
main() {
  check_root
  install_docker
  update_and_install
  setup_directories_and_network
  create_docker_compose_file
  start_nginx_proxy_manager

  # Exiba os contêineres em execução
  sudo docker ps -a

  echo "A instalação do Nginx Proxy Manager foi concluída. Acesse http://SEU_IP_SERVER/ para configurá-lo."
  echo "Use o seguinte login inicial:"
  echo "Email: admin@example.com"
  echo "Senha: changeme"
}

# Chama a função principal
main

###############################################################

cd

clear

cd /home/ubuntu/install_P_T_TY_N_E_W_C_/Servidor_TY_E_A_C_W_N_N_

# Retorna para o servidor.sh
# Exibe uma mensagem de confirmação
read -p "Deseja voltar para o MENU PRINCIPAL? (Y/N): " choice

# Verifica a escolha do usuário
if [ "$choice" == "Y" ] || [ "$choice" == "y" ]; then
  sudo chmod +x servidor.sh && ./servidor.sh
  echo "Comando executado."
elif [ "$choice" == "N" ] || [ "$choice" == "n" ]; then
  echo "Comando não executado. Continuando..."
else
  echo "Escolha inválida. Saindo."
fi
