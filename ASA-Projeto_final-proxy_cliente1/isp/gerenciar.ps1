param (
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet("up", "down", "restart")]
    $Comando,

    [Parameter(Mandatory=$true, Position=1)]
    [ValidateSet("core", "clientes", "tudo", "c1", "c2", "c3")]
    $Alvo
)

# Força o caminho absoluto da pasta onde o script está
$Raiz = Get-Location

function Executar-Docker {
    param ($Cmd, $NomeArquivo, $NomeServico)
    
    # Construção manual do caminho para evitar erros de Join-Path
    $CaminhoArquivo = "$Raiz\deploy\$NomeArquivo"
    
    if (!(Test-Path $CaminhoArquivo)) {
        Write-Host "ERRO: Nao encontrei o arquivo em: $CaminhoArquivo" -ForegroundColor Red
        return
    }

    Write-Host "--- $Cmd em $NomeServico ---" -ForegroundColor Blue
    
    if ($Cmd -eq "up") {
        docker compose -f "$CaminhoArquivo" up -d
    } elseif ($Cmd -eq "restart") {
        docker compose -f "$CaminhoArquivo" restart
    } else {
        docker compose -f "$CaminhoArquivo" $Cmd
    }
}

switch ($Alvo) {
    "core"     { Executar-Docker $Comando "compose-core.yml" "ISP CORE" }
    "clientes" {
        Executar-Docker $Comando "compose-cliente1.yml" "C1"
        Executar-Docker $Comando "compose-cliente2.yml" "C2"
        Executar-Docker $Comando "compose-cliente3.yml" "C3"
    }
    "tudo"     {
        Executar-Docker $Comando "compose-core.yml" "CORE"
        Executar-Docker $Comando "compose-cliente1.yml" "C1"
        Executar-Docker $Comando "compose-cliente2.yml" "C2"
        Executar-Docker $Comando "compose-cliente3.yml" "C3"
    }
    "c1"       { Executar-Docker $Comando "compose-cliente1.yml" "C1" }
    "c2"       { Executar-Docker $Comando "compose-cliente2.yml" "C2" }
    "c3"       { Executar-Docker $Comando "compose-cliente3.yml" "C3" }
}