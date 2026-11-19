
#!/bin/bash

# Projeto: Auditoria de Senhas
# Etapa 04: Auditoria de autenticação WEB
# Ferramenta: Medusa
# Ambiente: DVWA - Laboratório controlado

ALVO="192.168.56.102"
PASTA="$HOME/auditoria-senhas-kali-medusa/resultados"

mkdir -p "$PASTA"

echo "=================================="
echo " AUDITORIA WEB - DVWA"
echo "=================================="

# Verificar dependência
if ! command -v medusa >/dev/null 2>&1; then
    echo "Erro: Medusa não está instalado."
    exit 1
fi

# Verificar conectividade HTTP
if ! curl -s --connect-timeout 5 \
"http://$ALVO/dvwa/login.php" >/dev/null; then
    echo "Erro: DVWA não respondeu."
    exit 1
fi

echo "DVWA está acessível."
echo "Página: http://$ALVO/dvwa/login.php"

echo "=================================="
echo "Preparação concluída."
echo "Configure a sessão e os parâmetros"
echo "do formulário antes da auditoria."
echo "=================================="

