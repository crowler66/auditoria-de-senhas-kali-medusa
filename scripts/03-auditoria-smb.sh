
#!/bin/bash

# Projeto: Auditoria de Senhas
# Etapa 03: Análise do serviço SMB
# Ferramentas: Nmap e Enum4linux

ALVO="192.168.56.102"
PASTA="$HOME/auditoria-senhas-kali-medusa/resultados"

mkdir -p "$PASTA"

echo "=================================="
echo " AUDITORIA SMB"
echo "=================================="
echo "Alvo: $ALVO"

# Verificar ferramentas necessárias
for ferramenta in nmap enum4linux; do
    if ! command -v "$ferramenta" >/dev/null 2>&1; then
        echo "Erro: $ferramenta não está instalado."
        exit 1
    fi
done

# Identificar serviços SMB
echo "[1/2] Verificando portas SMB..."

nmap -p 139,445 -sV "$ALVO" \
-oN "$PASTA/04-resultado-smb-nmap.txt"

# Enumerar compartilhamentos SMB
echo "[2/2] Enumerando compartilhamentos..."

enum4linux -S "$ALVO" \
| tee "$PASTA/05-enumeracao-smb.txt"

echo "=================================="
echo "Análise SMB concluída!"
echo "Resultados salvos em: $PASTA"
