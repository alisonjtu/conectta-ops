#!/bin/bash

# Adiciona todas as alterações
git add .

# Cria um commit com a data e hora atuais
COMMIT_MSG="Update: $(date +'%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MSG"

# Envia para o GitHub (requer autenticação prévia configurada por SSH ou Token)
git push origin main

echo "Sincronização concluída com sucesso: $COMMIT_MSG"
