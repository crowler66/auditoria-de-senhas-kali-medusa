# 01 - Configuração do Ambiente

## 1. Objetivo

Preparar um laboratório controlado para estudar técnicas de auditoria de autenticação e segurança de redes.

## 2. Infraestrutura

| Sistema | Função |
|---|---|
| Debian | Sistema hospedeiro e documentação |
| Kali Linux | Máquina de auditoria |
| Metasploitable 2 | Máquina vulnerável |
| VirtualBox | Virtualização |

## 3. Configuração de rede

Rede utilizada: Host-only

| Máquina | Endereço IP |
|---|---|
| Kali Linux | 192.168.56.104 |
| Metasploitable 2 | 192.168.56.102 |

## 4. Teste de conectividade

Comando utilizado no Kali:

```bash
ping -c 3 192.168.56.102
```

Resultado observado:

- 3 pacotes transmitidos.
- 3 pacotes recebidos.
- 0% de perda.

## 5. Conclusão

A comunicação entre as máquinas virtuais foi confirmada. O ambiente está preparado para iniciar a etapa de reconhecimento de serviços.

Os testes serão realizados exclusivamente no laboratório isolado.

