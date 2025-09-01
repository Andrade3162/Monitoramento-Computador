# Monitoramento-Computador
Monitoramento PC

````markdown
# 🔍 Monitor de Conexões de Rede com Alerta via Telegram

Este script em **PowerShell** monitora as conexões TCP ativas no computador, registra um histórico local e envia alertas para um **Bot do Telegram** sempre que detectar novas conexões.  
Além disso, também coleta informações da rede como **IP externo, Wi-Fi conectado e localização aproximada**.

---

## 🚀 Funcionalidades
- 📡 Monitora conexões TCP em estado **Established** (ativas).  
- 🖥️ Identifica o **processo responsável** pela conexão.  
- 🌐 Obtém informações da rede:  
  - IP externo  
  - Nome da rede Wi-Fi (SSID)  
  - Localização aproximada (baseada no IP externo)  
- 📂 Mantém um **histórico de conexões** em arquivo (`conexoes_anteriores.txt`).  
- 🔔 Detecta **novas conexões** comparando com a execução anterior.  
- 📲 Envia **alertas automáticos no Telegram** com detalhes.  

---

## 🛠️ Requisitos
- **Windows PowerShell 5+** ou **PowerShell Core (7+)**  
- Acesso à internet  
- Uma conta no **Telegram** com um **Bot configurado**  

---

## 📦 Como configurar
1. **Crie um bot no Telegram**:  
   - Fale com o [@BotFather](https://t.me/BotFather)  
   - Use o comando `/newbot` e siga as instruções  
   - Anote o **Token do Bot** fornecido  

2. **Descubra seu Chat ID**:  
   - Fale com o bot [@userinfobot](https://t.me/userinfobot)  
   - Ele vai te mostrar seu `chat_id`  

3. **Edite o script** e substitua:  
   ```powershell
   $botToken = "SEU_TOKEN_AQUI"
   $chatID   = "SEU_CHAT_ID_AQUI"
````

---

## ▶️ Como usar

1. Salve o script, por exemplo como `monitor.ps1`.
2. Abra o **PowerShell** e execute:

   ```powershell
   .\monitor.ps1
   ```
3. 🔹 Na **primeira execução**, ele salva o histórico de conexões.
4. 🔹 Nas próximas execuções, se houver **novas conexões**, você receberá uma mensagem no **Telegram** com os detalhes.

---

## 📊 Exemplo de alerta no Telegram

```
========================================
IP Externo: 189.xxx.xxx.xxx
Wi-Fi: MinhaRedeWiFi
Localização aproximada: São Paulo, SP, Brasil
========================================

DATA/HORA           | LOCAL ->          REMOTO             | PROCESSO
========================================
2025-09-01 14:35:22 | 192.168.0.10:50035 -> 172.217.162.78:443 | Processo: chrome
```

---

## ⚡ Possíveis usos

* 🛡️ Monitorar conexões suspeitas no PC.
* 🔎 Saber quais aplicativos estão acessando a internet.
* 📲 Receber alertas em tempo real no celular via Telegram.
* 📜 Criar um histórico de conexões para auditoria.

---

✍️ **Autor:** \[Andrade3162]
📅 **Versão:** 1.0

```
