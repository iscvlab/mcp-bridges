# MCP Bridges — Universal Installer (Windows PowerShell)
# Copies the 7 creative, CAD & spatial MCP bridge skills into host skill roots on this machine.

param(
    [switch]$Antigravity,
    [switch]$Claude,
    [switch]$Grok,
    [switch]$Agents,
    [switch]$All,
    [string]$Workspace = ""
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $PSScriptRoot
$SkillsSrc = Join-Path $ScriptDir "skills"

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  ⚡ MCP Bridges (7 Skills) — Windows Installer" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Source: $SkillsSrc"

function Install-Skills([string]$TargetDir, [string]$PlatformName) {
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }
    Write-Host "`nInstalling into $PlatformName ($TargetDir)..." -ForegroundColor Yellow

    Get-ChildItem -Directory $SkillsSrc | ForEach-Object {
        $skillName = $_.Name
        $dest = Join-Path $TargetDir $skillName

        if (Test-Path $dest) {
            Remove-Item $dest -Recurse -Force
        }

        # Copy as real directory to prevent nested junction recursion limits
        Copy-Item $_.FullName $dest -Recurse -Force
        Write-Host "  ✓ Installed /$skillName" -ForegroundColor Green
    }
}

$noHostFlag = -not $Antigravity.IsPresent -and -not $Claude.IsPresent -and -not $Grok.IsPresent -and -not $Agents.IsPresent -and [string]::IsNullOrEmpty($Workspace)
$installAll = $All.IsPresent -or $noHostFlag

# 1. Google Antigravity
$geminiDir = Join-Path $env:USERPROFILE ".gemini\config\skills"
if ($Antigravity.IsPresent -or $All.IsPresent -or ($noHostFlag -and (Test-Path (Join-Path $env:USERPROFILE ".gemini")))) {
    Install-Skills $geminiDir "Gemini / Antigravity"
}

# 2. Claude Code
$claudeDir = Join-Path $env:USERPROFILE ".claude\skills"
if ($Claude.IsPresent -or $All.IsPresent -or ($noHostFlag -and (Test-Path (Join-Path $env:USERPROFILE ".claude")))) {
    Install-Skills $claudeDir "Claude Code"
}

# 3. Grok
$grokHome = if ($env:GROK_HOME) { $env:GROK_HOME } else { Join-Path $env:USERPROFILE ".grok" }
$grokDir = Join-Path $grokHome "skills"
if ($Grok.IsPresent -or $All.IsPresent -or ($noHostFlag -and (Test-Path $grokHome))) {
    Install-Skills $grokDir "Grok"
}

# 4. Cursor / Codex / Windsurf (~/.agents/skills)
$agentsDir = Join-Path $env:USERPROFILE ".agents\skills"
if ($Agents.IsPresent -or $All.IsPresent -or ($noHostFlag -and (Test-Path (Join-Path $env:USERPROFILE ".agents")))) {
    Install-Skills $agentsDir "Cursor / Codex / Windsurf (.agents)"
}

# 5. Workspace
if (-not [string]::IsNullOrEmpty($Workspace) -and (Test-Path $Workspace)) {
    $wsTarget = Join-Path $Workspace ".agents\skills"
    Install-Skills $wsTarget "Workspace .agents ($Workspace)"
    $wsGrok = Join-Path $Workspace ".grok\skills"
    if (Test-Path (Join-Path $Workspace ".grok") -or $Grok.IsPresent) {
        Install-Skills $wsGrok "Workspace .grok ($Workspace)"
    }
}

Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host "  ✓ Installation Complete! All 7 skills ready to trigger." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
