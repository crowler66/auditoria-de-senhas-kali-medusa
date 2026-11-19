# 03 - Auditoria de Autenticação FTP com Medusa

## 1. Objetivo

Realizar um teste controlado de auditoria de senhas no serviço FTP da máquina Metasploitable 2, utilizando a ferramenta Medusa e uma wordlist de senhas.

O objetivo é verificar se uma credencial fraca pode ser descoberta por meio de tentativas automatizadas de autenticação.

## 2. Ambiente

- Máquina de auditoria: Kali Linux
- Máquina alvo: Metasploitable 2
- IP do Kali Linux: `192.168.56.104`
- IP do alvo: `192.168.56.102`
- Serviço: ProFTPD 1.3.1
- Porta: 2121
- Ferramenta: Medusa 2.3
- Virtualização: Oracle VirtualBox

## 3. Lista de senhas

Foi criada uma wordlist de laboratório chamada `lista-senhas.txt`, contendo cinco senhas para utilização no teste.

Conteúdo da lista:

```text
123456
senha123
password
admin
msfadmin
```

A wordlist foi armazenada no diretório pessoal do Kali Linux:

`/home/py/lista-senhas.txt`

## 4. Comando utilizado

O seguinte comando foi executado no Kali Linux:

```bash
medusa -h 192.168.56.102 -u msfadmin -P /home/py/lista-senhas.txt -M ftp -n 2121 -t 1
```

### Descrição dos parâmetros

- `-h`: endereço IP da máquina alvo.
- `-u`: usuário utilizado no teste.
- `-P`: caminho do arquivo contendo a lista de senhas.
- `-M ftp`: seleciona o módulo de autenticação FTP.
- `-n 2121`: define a porta do serviço FTP.
- `-t 1`: executa uma tentativa por vez.

## 5. Resultado obtido

A ferramenta Medusa realizou cinco tentativas de autenticação e identificou uma credencial válida.

Resultado apresentado pelo terminal:

```text
ACCOUNT FOUND: [ftp] Host: 192.168.56.102
User: msfadmin Password: msfadmin [SUCCESS]
```

### Credencial identificada

- Usuário: `msfadmin`
- Senha: `msfadmin`
- Resultado: autenticação aceita pelo serviço FTP.

A senha encontrada estava presente na wordlist utilizada durante o teste.

## 6. Análise do resultado

O teste demonstrou que uma senha simples, igual ao nome do usuário, estava configurada na máquina vulnerável.

Essa prática representa um risco de segurança, pois facilita a descoberta de credenciais por meio de tentativas automatizadas de autenticação.

O resultado também demonstra como uma wordlist pode ser utilizada em uma auditoria para identificar senhas fracas em serviços de rede.

## 7. Recomendações de segurança

Com base no resultado obtido, são recomendadas as seguintes medidas:

- Utilizar senhas fortes e exclusivas.
- Evitar senhas iguais ao nome do usuário.
- Desabilitar contas e serviços desnecessários.
- Monitorar tentativas repetidas de autenticação.
- Aplicar mecanismos de bloqueio e limitação de tentativas.
- Utilizar SFTP ou FTPS em substituição ao FTP sem criptografia, conforme a necessidade do ambiente.
- Revisar periodicamente as configurações de autenticação dos serviços.

## 8. Monitoramento do tráfego com tcpdump

Durante a execução da auditoria, também foi utilizado o tcpdump na máquina Metasploitable 2 para observar o tráfego de rede entre as máquinas virtuais.

Foram observadas comunicações entre os seguintes endereços:

- Kali Linux: `192.168.56.104`
- Metasploitable 2: `192.168.56.102`

A captura permitiu acompanhar os pacotes transmitidos durante as tentativas de autenticação realizadas pela Medusa.

Essa atividade complementou a auditoria, demonstrando a importância do monitoramento do tráfego de rede durante testes de segurança.

**Evidência:** captura de tela mostrando a execução da Medusa no Kali Linux e o tcpdump na máquina Metasploitable 2.

## 9. Conclusão

A auditoria controlada do serviço FTP foi concluída com sucesso.

A ferramenta Medusa identificou uma credencial válida entre as cinco senhas utilizadas na wordlist.

O monitoramento com tcpdump complementou a atividade, permitindo observar a comunicação entre as máquinas durante o teste.

O exercício demonstrou a importância de políticas de senhas fortes, monitoramento de autenticação e utilização de protocolos seguros para proteger serviços de rede.

Todos os testes foram realizados exclusivamente no ambiente virtual isolado e autorizado, utilizando o Kali Linux e o Metasploitable 2.
