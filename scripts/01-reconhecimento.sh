
#!/bin/bash

# Projeto: Auditoria de Senhas
# Etapa 01: Reconhecimento de rede
# Ferramenta: Nmap

ALVO="192.168.56.102"
PASTA="$HOME/auditoria-senhas-kali-medusa/resultados"

# Criar pasta para armazenar os resultados
mkdir -p "$PASTA"

echo "=================================="
echo " RECONHECIMENTO COM NMAP"
echo "=================================="
echo "Alvo: $ALVO"

# Verificar se o Nmap está instalado
if ! command -v nmap >/dev/null 2>&1; then
    echo "Erro: Nmap não está instalado."
    exit 1
fi

# Verificar disponibilidade do alvo
nmap -sn "$ALVO" -oN "$PASTA/01-host.txt"

# Identificar portas e versões dos serviços
nmap -sV "$ALVO" -oN "$PASTA/02-servicos.txt"

echo "=================================="
echo "Reconhecimento concluído!"
echo "Resultados salvos em: $PASTA"
