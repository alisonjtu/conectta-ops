# /opt/conecttaops/n8n-custom/Dockerfile
FROM n8nio/n8n:latest-debian

USER root

# Quebramos os comandos em camadas isoladas para garantir a execução
# Camada 1: Atualiza a lista de pacotes
RUN apt-get update -y

# Camada 2: Instala dependências básicas de rede e descompactação
RUN apt-get install -y wget unzip

# Camada 3: Tenta instalar a dependência do Oracle (com fallback sequencial)
RUN apt-get install -y libaio1 || apt-get install -y libaio1t64

# Camada 4: Limpa o cache do apt para manter a imagem leve
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /opt/oracle

# Camada 5: Download silencioso (-q) e extração do Oracle Instant Client
RUN wget -q https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-basic-linux.x64-21.12.0.0.0dbru.zip \
    && unzip -q instantclient-basic-linux.x64-21.12.0.0.0dbru.zip \
    && rm instantclient-basic-linux.x64-21.12.0.0.0dbru.zip

ENV ORACLE_HOME=/opt/oracle/instantclient_21_12
ENV LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH
ENV PATH=$ORACLE_HOME:$PATH

WORKDIR /data
USER node
