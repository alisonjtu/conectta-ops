# Utiliza a imagem oficial do Node.js baseada no Debian 11 (Bullseye)
FROM node:20-bullseye

USER root

# Atualiza os repositórios e instala dependências e o Oracle Instant Client
RUN apt-get update && apt-get install -y libaio1 wget unzip && \
    mkdir -p /opt/oracle && \
    cd /opt/oracle && \
    wget https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-basic-linux.x64-21.12.0.0.0dbru.zip && \
    unzip instantclient-basic-linux.x64-21.12.0.0.0dbru.zip && \
    rm instantclient-basic-linux.x64-21.12.0.0.0dbru.zip && \
    sh -c "echo /opt/oracle/instantclient_21_12 > /etc/ld.so.conf.d/oracle-instantclient.conf" && \
    ldconfig && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala a versão mais recente do n8n globalmente
RUN npm install -g n8n

# Retorna para o usuário 'node' (nativo da imagem) por segurança
USER node
WORKDIR /home/node

# Comando de inicialização do serviço
CMD ["n8n", "start"]
