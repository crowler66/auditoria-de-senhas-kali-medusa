
#!/bin/bash

# Projeto: Auditoria de Senhas
# Etapa 02: Auditoria de autenticação FTP
# Ferramenta: Medusa

ALVO="192.168.56.102"
PASTA="$HOME/auditoria-senhas-kali-medusa/resultados"
USUARIOS="$HOME/auditoria-senhas-kali-medusa/wordlists/users.txt"
SENHAS="$HOME/auditoria-senhas-kali-medusa/wordlists/pass.txt"

mkdir -p "$PASTA"

echo "=================================="
echo " AUDITORIA FTP COM MEDUSA"
echo "=================================="

# Verificar dependências
for ferramenta in medusa; do
    if ! command -v "$ferramenta" >/dev/null 2>&1; then
        echo "Erro: $ferramenta não está instalado."
        exit 1
    fi
done

# Verificar as wordlists
if [[ ! -f "$USUARIOS" || ! -f "$SENHAS" ]]; then
    echo "Erro: arquivos de wordlists não encontrados."
    exit 1
fi

# Executar auditoria controlada
medusa -h "$ALVO" \
-U "$USUARIOS" \
-P "$SENHAS" \
-M ftp \
-t 2 \
-O "$PASTA/03-auditoria-ftp.txt"

echo "Auditoria FTP finalizada."
