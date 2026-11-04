# MCP Bridges — Universal Installer (Windows PowerShell)
# Copies the 7 creative, CAD & spatial MCP bridge skills into host skill roots on this machine.

param(
    [switch]$Antigravity,
    [switch]$Claude,
    [switch]$Grok,
    [switch]$Agents,
    [switch]$Codex,
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

$installedPhysicalDirs = @{}

function Resolve-PhysicalPath([string]$PathToResolve) {
    $full = [System.IO.Path]::GetFullPath($PathToResolve)
    $parts = @()
    $curr = $full
    while (-not [string]::IsNullOrEmpty($curr)) {
        if (Test-Path -LiteralPath $curr) {
            $item = Get-Item -LiteralPath $curr -Force
            if (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -and $item.Target) {
                $targetVal = if ($item.Target -is [array]) { $item.Target[0] } else { $item.Target }
                if (-not [System.IO.Path]::IsPathRooted($targetVal)) {
                    $targetVal = Join-Path (Split-Path -Parent $curr) $targetVal
                }
                $curr = [System.IO.Path]::GetFullPath($targetVal)
                continue
            }
        }
        $parent = Split-Path -Parent $curr
        if ([string]::IsNullOrEmpty($parent) -or $parent -eq $curr) {
            $parts = ,$curr + $parts
            break
        }
        $leaf = Split-Path -Leaf $curr
        $parts = ,$leaf + $parts
        $curr = $parent
    }
    $resolved = $parts[0]
    for ($i = 1; $i -lt $parts.Count; $i++) {
        $resolved = Join-Path $resolved $parts[$i]
    }
    return [System.IO.Path]::GetFullPath($resolved).TrimEnd('\', '/').ToLowerInvariant()
}

function Install-Skills([string]$TargetDir, [string]$PlatformName) {
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }
    $physTarget = Resolve-PhysicalPath $TargetDir
    $physSrc = Resolve-PhysicalPath $SkillsSrc
    if ($physTarget -eq $physSrc) {
        Write-Host "`nSkipping $PlatformName ($TargetDir) — source and destination resolve to the same physical directory." -ForegroundColor DarkGray
        return
    }
    if ($installedPhysicalDirs.ContainsKey($physTarget)) {
        Write-Host "`nSkipping $PlatformName ($TargetDir) — physical directory already updated via $($installedPhysicalDirs[$physTarget])." -ForegroundColor DarkGray
        return
    }
    $installedPhysicalDirs[$physTarget] = $PlatformName

    Write-Host "`nInstalling into $PlatformName ($TargetDir)..." -ForegroundColor Yellow

    Get-ChildItem -Directory $SkillsSrc | ForEach-Object {
        $skillName = $_.Name
        $dest = Join-Path $TargetDir $skillName

        if ((Test-Path $dest) -and ((Resolve-PhysicalPath $_.FullName) -eq (Resolve-PhysicalPath $dest))) {
            Write-Host "  ✓ Skipped /$skillName (source == destination)" -ForegroundColor DarkGray
            return
        }

        if (Test-Path $dest) {
            Remove-Item $dest -Recurse -Force
        }

        # Copy as real directory to prevent nested junction recursion limits
        Copy-Item $_.FullName $dest -Recurse -Force
        Write-Host "  ✓ Installed /$skillName" -ForegroundColor Green
    }
}

$noHostFlag = -not $Antigravity.IsPresent -and -not $Claude.IsPresent -and -not $Grok.IsPresent -and -not $Agents.IsPresent -and -not $Codex.IsPresent -and [string]::IsNullOrEmpty($Workspace)
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

# 4. Cursor / Codex / Windsurf (~/.agents/skills & ~/.codex/skills)
$agentsDir = Join-Path $env:USERPROFILE ".agents\skills"
if ($Agents.IsPresent -or $All.IsPresent -or ($noHostFlag -and (Test-Path (Join-Path $env:USERPROFILE ".agents")))) {
    Install-Skills $agentsDir "Cursor / Codex / Windsurf (.agents)"
}
$codexDir = Join-Path $env:USERPROFILE ".codex\skills"
if ($Codex.IsPresent -or $All.IsPresent -or ($noHostFlag -and (Test-Path (Join-Path $env:USERPROFILE ".codex")))) {
    Install-Skills $codexDir "Codex (.codex)"
}

# 5. Workspace
if (-not [string]::IsNullOrEmpty($Workspace) -and (Test-Path $Workspace)) {
    $wsTarget = Join-Path $Workspace ".agents\skills"
    Install-Skills $wsTarget "Workspace .agents ($Workspace)"
    $wsClaude = Join-Path $Workspace ".claude\skills"
    if (Test-Path (Join-Path $Workspace ".claude") -or $Claude.IsPresent -or $All.IsPresent) {
        Install-Skills $wsClaude "Workspace .claude ($Workspace)"
    }
    $wsGrok = Join-Path $Workspace ".grok\skills"
    if (Test-Path (Join-Path $Workspace ".grok") -or $Grok.IsPresent) {
        Install-Skills $wsGrok "Workspace .grok ($Workspace)"
    }
}

Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host "  ✓ Installation Complete! All 7 skills ready to trigger." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
