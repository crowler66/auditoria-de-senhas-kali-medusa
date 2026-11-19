# 02 - Reconhecimento de Rede

## 1. Objetivo

Realizar o reconhecimento dos serviços disponíveis na máquina Metasploitable 2, utilizando o Nmap a partir da máquina Kali Linux.

O objetivo é identificar portas abertas, serviços ativos e suas respectivas versões, para definir quais serão analisados nas próximas etapas da auditoria.

## 2. Informações do ambiente

| Item | Informação |
|---|---|
| Máquina de auditoria | Kali Linux |
| Máquina alvo | Metasploitable 2 |
| IP da máquina de auditoria | 192.168.56.104 |
| IP da máquina alvo | 192.168.56.102 |
| Ferramenta | Nmap 7.98 |

## 3. Comando utilizado

```bash
nmap -sV -sC -oN resultado-nmap.txt 192.168.56.102
```

Parâmetros:

- `-sV`: identifica versões dos serviços.
- `-sC`: executa scripts padrão do Nmap.
- `-oN`: salva o resultado em formato de texto normal.
- `192.168.56.102`: endereço IP da máquina alvo.

## 4. Resultado do reconhecimento

A máquina alvo foi identificada como ativa. O Nmap encontrou 23 portas TCP abertas.

| Porta | Serviço | Versão ou identificação |
|---|---|---|
| 21 | FTP | vsftpd 2.3.4 |
| 22 | SSH | OpenSSH 4.7p1 |
| 23 | Telnet | Linux telnetd |
| 25 | SMTP | Postfix smtpd |
| 53 | DNS | ISC BIND 9.4.2 |
| 80 | HTTP | Apache 2.2.8 |
| 111 | RPC | rpcbind |
| 139 | NetBIOS/SMB | Samba |
| 445 | SMB | Samba 3.0.20 |
| 512 | exec | netkit-rsh rexecd |
| 513 | login | rlogind |
| 514 | shell | Netkit rshd |
| 1099 | Java RMI | GNU Classpath rmiregistry |
| 1524 | bindshell | Metasploitable root shell |
| 2049 | NFS | NFS 2-4 |
| 2121 | FTP | ProFTPD 1.3.1 |
| 3306 | MySQL | 5.0.51a |
| 5432 | PostgreSQL | 8.3.0 - 8.3.7 |
| 5900 | VNC | Protocolo 3.3 |
| 6000 | X11 | Acesso negado |
| 6667 | IRC | UnrealIRCd |
| 8009 | AJP13 | Apache Jserv |
| 8180 | HTTP | Apache Tomcat 5.5 |

## 5. Observações relevantes

Durante o reconhecimento, foram identificadas algumas configurações que merecem investigação:

- O serviço FTP da porta 21 permite autenticação anônima, conforme identificado pelo script `ftp-anon` do Nmap.
- Existe outro serviço FTP na porta 2121, identificado como ProFTPD 1.3.1.
- O serviço SMB utiliza Samba 3.0.20 e apresentou assinatura de mensagens desabilitada.
- Foram identificados serviços antigos de SSH, Telnet, Apache, MySQL e PostgreSQL.

Essas informações representam indícios técnicos observados durante o reconhecimento. A confirmação de vulnerabilidades exige testes específicos.

## 6. Conclusão

O reconhecimento confirmou uma quantidade significativa de serviços ativos na máquina Metasploitable 2.

Todos os testes serão realizados exclusivamente no ambiente virtual isolado e autorizado.

## 7. Evidência

Relatório original do Nmap: `resultado-nmap.txt`.
## 8. Verificação de acesso anônimo ao FTP

Foi realizada uma conexão com o serviço FTP da porta 21 da máquina Metasploitable 2.

Comando utilizado:

```bash
ftp 192.168.56.102
```

Credencial utilizada:

- Usuário: `anonymous`
- Senha: `anonymous`

Resultado observado:

```text
220 (vsFTPd 2.3.4)
230 Login successful.
```

A autenticação foi aceita pelo servidor sem utilização de uma conta individual.

O comando `pwd` informou que o diretório remoto atual era `/`. O comando `ls` não apresentou arquivos ou diretórios na listagem.

**Conclusão:** foi confirmado que o serviço FTP permite autenticação anônima. Essa configuração pode representar um risco caso o acesso anônimo não seja necessário.
## 9. Verificação do segundo serviço FTP

Foi realizada uma conexão com o serviço ProFTPD na porta 2121.

Comando utilizado:

```bash
ftp 192.168.56.102 2121
```

Identificação do servidor:

```text
220 ProFTPD 1.3.1 Server (Debian)
```

Foi realizada uma tentativa de autenticação com o usuário `anonymous`.

Resultado:

```text
331 Password required for anonymous
530 Login incorrect.
```

**Conclusão:** o servidor ProFTPD recusou a autenticação anônima testada. Diferentemente do serviço vsftpd da porta 21, não foi possível confirmar acesso anônimo na porta 2121.

## 10. Enumeração de compartilhamentos SMB

Foi realizada uma consulta aos compartilhamentos SMB utilizando o smbclient.

Comando utilizado:

```bash
smbclient -L //192.168.56.102 -N
```

Resultado observado:

```text
Anonymous login successful

Sharename       Type
---------       ----
print$          Disk
tmp             Disk
opt             Disk
IPC$            IPC
ADMIN$          IPC
```

O servidor aceitou a conexão anônima e apresentou os compartilhamentos disponíveis.

**Conclusão:** foi confirmada a possibilidade de enumeração anônima dos compartilhamentos SMB. A permissão de acesso aos arquivos de cada compartilhamento ainda precisa ser verificada.



## 11. Verificação de acesso ao compartilhamento SMB tmp

Após identificar os compartilhamentos disponíveis, foi realizado um teste de conexão anônima ao compartilhamento `tmp`.

Comando utilizado:

```bash
smbclient //192.168.56.102/tmp -N
```

Resultado da autenticação:

```text
Anonymous login successful
```

Em seguida, foi executado o comando `ls` para listar o conteúdo.

Arquivos e diretórios encontrados:

```text
4551.jsvc_up
.ICE-unix
.X11-unix
.X0-lock
```

**Conclusão:** foi confirmado que um usuário anônimo consegue acessar o compartilhamento `tmp` e visualizar seu conteúdo sem fornecer credenciais.

O teste confirmou permissão de leitura/listagem. A permissão de escrita não foi verificada.
