# Script para automatizar git add, commit e push
# Autor: Sistema de Gestão BacBo
# Data: $(Get-Date -Format "yyyy-MM-dd")

Write-Host "=== Script de Upload para Git ===" -ForegroundColor Green
Write-Host "Iniciando processo de upload..." -ForegroundColor Yellow

# Verificar se estamos em um repositório git
try {
    $gitStatus = git status 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erro: Este diretório nao e um repositorio git!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Erro: Git nao esta instalado ou nao esta no PATH!" -ForegroundColor Red
    exit 1
}

# Verificar se há mudanças para commitar
$changes = git status --porcelain
if ([string]::IsNullOrEmpty($changes)) {
    Write-Host "Nenhuma mudanca detectada para commitar." -ForegroundColor Yellow
    exit 0
}

Write-Host "Mudancas detectadas:" -ForegroundColor Cyan
git status --short

# Git Add - Adicionar todas as mudanças
Write-Host "`nExecutando git add..." -ForegroundColor Yellow
try {
    git add .
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Arquivos adicionados com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "[ERRO] Erro ao adicionar arquivos!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "[ERRO] Erro ao executar git add: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Git Commit - Criar commit com mensagem
Write-Host "`nExecutando git commit..." -ForegroundColor Yellow
$commitMessage = "Atualizacao automatica - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
try {
    git commit -m $commitMessage
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Commit criado com sucesso!" -ForegroundColor Green
        Write-Host "Mensagem: $commitMessage" -ForegroundColor Cyan
    } else {
        Write-Host "[ERRO] Erro ao criar commit!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "[ERRO] Erro ao executar git commit: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Git Push - Enviar para o repositório remoto
Write-Host "`nExecutando git push..." -ForegroundColor Yellow
try {
    git push
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Push realizado com sucesso!" -ForegroundColor Green
        Write-Host "`n=== Upload concluido com sucesso! ===" -ForegroundColor Green
    } else {
        Write-Host "[ERRO] Erro ao fazer push!" -ForegroundColor Red
        Write-Host "Verifique se o repositorio remoto esta configurado corretamente." -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "[ERRO] Erro ao executar git push: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`nProcesso finalizado!" -ForegroundColor Green
