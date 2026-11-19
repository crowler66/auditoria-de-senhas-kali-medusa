# 04 — Análise de compartilhamentos SMB

## 1. Objetivo

Verificar os compartilhamentos SMB disponibilizados pelo servidor Metasploitable 2 e avaliar o acesso anônimo aos recursos compartilhados.

## 2. Ambiente

- Máquina de auditoria: Kali Linux
- Máquina alvo: Metasploitable 2
- IP do Kali: `192.168.56.104`
- IP do alvo: `192.168.56.102`
- Serviço: SMB/Samba

## 3. Enumeração dos compartilhamentos

Foi utilizado o comando:

```bash
smbclient -L //192.168.56.102 -N
```

O parâmetro `-L` lista os compartilhamentos disponíveis e `-N` tenta realizar a conexão sem solicitar senha.

Foram identificados os seguintes compartilhamentos:

- `print$`
- `tmp`
- `opt`
- `IPC$`
- `ADMIN$`

A listagem foi realizada com autenticação anônima.

## 4. Teste de acesso ao compartilhamento tmp

Comando utilizado:

```bash
smbclient //192.168.56.102/tmp -N
```

O acesso anônimo foi aceito. Dentro do compartilhamento, o comando `ls` apresentou os seguintes itens:

- `4551.jsvc_up`
- `.ICE-unix`
- `.X11-unix`
- `.X0-lock`

## 5. Teste de acesso ao compartilhamento opt

Comando utilizado:

```bash
smbclient //192.168.56.102/opt -N
```

O servidor aceitou a sessão inicial, mas negou o acesso ao compartilhamento, retornando:

```text
NT_STATUS_ACCESS_DENIED
```

## 6. Análise dos resultados

Os testes demonstraram que o servidor permite enumeração anônima dos compartilhamentos SMB e acesso anônimo ao recurso `tmp`.

O compartilhamento `opt`, por outro lado, apresentou restrição de acesso.

Não foi realizado teste de password spraying nem enumeração de usuários SMB. Portanto, esses procedimentos não são considerados resultados deste projeto.

## 7. Recomendações de segurança

- Desabilitar acesso de convidado quando não for necessário.
- Restringir permissões de leitura e escrita nos compartilhamentos.
- Conceder acesso somente aos usuários autorizados.
- Manter o Samba atualizado.
- Desabilitar protocolos SMB antigos quando possível.
- Monitorar tentativas de autenticação e acessos anormais.
- Exigir senhas fortes e individuais.

## 8. Conclusão

A análise identificou exposição de informações sobre os compartilhamentos SMB e acesso anônimo ao recurso `tmp`. O resultado demonstra a importância de configurar corretamente as permissões e restringir o acesso aos recursos de rede.
