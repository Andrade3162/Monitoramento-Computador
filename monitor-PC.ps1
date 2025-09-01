# ============================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Caminho onde o histórico será salvo
$logPath = "$env:TEMP\conexoes_anteriores.txt"

# Token do Bot do Telegram
$botToken = "SEU_TOKEN_AQUI"  # Altere para o seu TOKEN do Bot
# ID do Chat (pode ser seu ID de usuário ou o ID de um grupo)
$chatID = "SEU_CHAT_ID_AQUI"  # Altere para o seu ID de chat

# Função para enviar mensagem via Telegram com codificação UTF-8 correta
function Send-TelegramMessage {
    param(
        [string]$message
    )
    
    $url = "https://api.telegram.org/bot$botToken/sendMessage"
    $params = @{
        chat_id    = $chatID
        text       = $message
        parse_mode = "Markdown"
    }

    try {
        # Converte o objeto para JSON
        $json = $params | ConvertTo-Json -Depth 3
        # Converte o JSON para bytes UTF8
        $utf8Bytes = [System.Text.Encoding]::UTF8.GetBytes($json)
        # Envia a requisição POST com o corpo UTF8
        Invoke-RestMethod -Uri $url -Method Post -ContentType "application/json" -Body $utf8Bytes

        Write-Output "Mensagem enviada com sucesso."
    } catch {
        Write-Output "Erro ao enviar mensagem para o Telegram: $_"
    }
}

# Função para pegar conexões ativas com nome do processo e data/hora
function Get-ConexoesAtivas {
    Get-NetTCPConnection | Where-Object { $_.State -eq "Established" } | ForEach-Object {
        $proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
        $dataHora = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "$dataHora | $($_.LocalAddress):$($_.LocalPort) -> $($_.RemoteAddress):$($_.RemotePort) | Processo: $($proc.Name)"
    }
}

# Obter IP externo
try {
    $ipExterno = Invoke-RestMethod -Uri "https://api.ipify.org"
} catch {
    $ipExterno = "IP externo não detectado"
}

# Obter nome da rede Wi-Fi conectada (SSID)
try {
    $wlan = netsh wlan show interfaces | Select-String ' SSID' | Select-Object -First 1
    $ssid = ($wlan -replace '^\s*SSID\s*:\s*', '').Trim()
    if ($ssid -eq "") { $ssid = "Desconectado" }
} catch {
    $ssid = "Erro ao identificar Wi-Fi"
}

# Obter localização baseada no IP externo
try {
    $geo = Invoke-RestMethod -Uri "http://ip-api.com/json/$ipExterno"
    $localizacao = "$($geo.city), $($geo.regionName), $($geo.country)"
} catch {
    $localizacao = "Localização não identificada"
}

# Informações da rede para o cabeçalho da mensagem
$infoRede = @"
========================================
IP Externo: $ipExterno
Wi-Fi: $ssid
Localização aproximada: $localizacao
========================================
"@

# Obtem conexões atuais
$conexoesAtuais = Get-ConexoesAtivas

# Se for a primeira execução, salva e sai
if (-not (Test-Path $logPath)) {
    $conexoesAtuais | Set-Content $logPath
    Write-Output "Primeira execução: conexões salvas para comparação futura."
    Send-TelegramMessage -message "$infoRede`nPrimeira execução: conexões salvas para comparação futura."
    exit
}

# Lê conexões anteriores
$conexoesAntigas = Get-Content $logPath

# Compara e identifica conexões novas
$conexoesNovas = Compare-Object -ReferenceObject $conexoesAntigas -DifferenceObject $conexoesAtuais | 
                 Where-Object { $_.SideIndicator -eq "=>"} | 
                 Select-Object -ExpandProperty InputObject

# Se houver novas conexões, mostra e envia para o Telegram
if ($conexoesNovas.Count -gt 0) {
    # Cabeçalho para a tabela de conexões
    $header = @"
DATA/HORA           | LOCAL ->          REMOTO             | PROCESSO
========================================
"@
    
    # Corpo com as novas conexões
    $corpo = $conexoesNovas -join "`n"
    
    # Mensagem final com dados da rede + conexões novas
    $message = "$infoRede`n$header`n$corpo"
    
    Write-Output $message
    Send-TelegramMessage -message $message
} else {
    Write-Output "Nenhuma conexão nova detectada."
}

# Atualiza o histórico
$conexoesAtuais | Set-Content $logPath
