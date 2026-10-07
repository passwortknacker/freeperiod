# Starts Codex round N detached. Fresh: -Model <m>. Resume: -Resume <thread-id>. Review only: -ReadOnly.
param([Parameter(Mandatory)][int] $N, [string] $Model = 'gpt-6.1-sol', [string] $Resume, [switch] $ReadOnly)
$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$cache = Join-Path $env:USERPROFILE 'dev-tools\gradle-home'
$r = "aufpasser\runden"
$common = @('-m', $Model, '-c', 'model_reasoning_effort=high', '-c', 'approval_policy=never', '--json', '-o', "$r\runde-$N.md")
if ($Resume) {
    # TOML literal string (single quotes): survives PowerShell's native argument quoting.
    $roots = "sandbox_workspace_write.writable_roots=['$cache']"
    $cx = @('exec', 'resume', $Resume) + $common + @('-c', 'sandbox_mode=workspace-write', '-c', $roots, '-')
} elseif ($ReadOnly) {
    $cx = @('exec') + $common + @('-C', $repo, '-s', 'read-only', '-')
} else {
    $cx = @('exec') + $common + @('-C', $repo, '-s', 'workspace-write', '--add-dir', $cache, '-')
}
$job = {
    param($repo, $r, $N, $cx)
    Set-Location $repo
    Get-Content -Raw -Encoding utf8 "$r\prompt-$N.txt" | & codex @cx > "$r\runde-$N.jsonl" 2> "$r\runde-$N.log"
}
$enc = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes(
    "& { $job } '$repo' '$r' $N @(" + (($cx | ForEach-Object { "'" + $_.Replace("'", "''") + "'" }) -join ',') + ")"))
Start-Process powershell -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-EncodedCommand', $enc -WindowStyle Hidden
"started round $N"
