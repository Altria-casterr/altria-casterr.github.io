# deploy.ps1 — 把本目录推送到 GitHub Pages 仓库
#
# 用法（在 personal-homepage 目录下打开 PowerShell）：
#   .\deploy.ps1 -UserName sanzhang
#   .\deploy.ps1 -UserName sanzhang -Email zhangsan@example.edu.cn -Name "张三"
#
# 首次运行会弹浏览器要求登录 GitHub，授权一次即可。
# 仓库必须先存在：https://github.com/<UserName>/<UserName>.github.io

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$UserName,

    # 提交记录里显示的作者信息，缺省沿用 git 全局配置
    [string]$Name,
    [string]$Email,

    [string]$CommitMessage = "update homepage"
)

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

$repo = "$UserName.github.io"
$remote = "https://github.com/$UserName/$repo.git"

Write-Host "==> 目标仓库: $remote" -ForegroundColor Cyan

# --- 0. 前置检查 ---------------------------------------------------------
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "未找到 git，请先安装 Git for Windows：https://git-scm.com/download/win"
}

if (-not (Test-Path "index.html")) {
    throw "当前目录下没有 index.html，请在 personal-homepage 目录内运行此脚本。"
}

# --- 1. 初始化本地仓库（已初始化则跳过） ---------------------------------
if (-not (Test-Path ".git")) {
    Write-Host "==> git init" -ForegroundColor Cyan
    git init -b main | Out-Null
}

# --- 2. 作者信息（写入本仓库，不改动全局配置） ---------------------------
if ($Name)  { git config user.name  $Name }
if ($Email) { git config user.email $Email }

if (-not (git config user.name)) {
    Write-Host "首次运行需要记录作者信息（只写入本仓库，不改动全局 git 配置）" -ForegroundColor Yellow
    $Name = Read-Host "你的名字（写进 commit 记录，拼音或中文都行）"
    if (-not $Name) { throw "名字不能为空。" }
    git config user.name $Name
}
if (-not (git config user.email)) {
    $Email = Read-Host "你的邮箱"
    if (-not $Email) { throw "邮箱不能为空。" }
    git config user.email $Email
}

# --- 3. 远端 -------------------------------------------------------------
$existing = git remote 2>$null
if ($existing -contains "origin") {
    git remote set-url origin $remote
} else {
    git remote add origin $remote
}

# --- 4. 提交 & 推送 ------------------------------------------------------
git add -A
$staged = git diff --cached --name-only
if ($staged) {
    Write-Host "==> 本次变更: $($staged -join ', ')" -ForegroundColor Cyan
    git commit -m $CommitMessage | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "git commit 失败，请检查上面的报错。" }
} else {
    Write-Host "==> 没有新的改动，跳过提交" -ForegroundColor Yellow
}

Write-Host "==> git push" -ForegroundColor Cyan
git push -u origin main
if ($LASTEXITCODE -ne 0) {
    throw @"
git push 失败。常见原因（按可能性排序）：
  1) GitHub 上还没有创建仓库 $repo
     -> 先建仓库：https://github.com/new ，名称必须是 "$repo"，可见性选 Public
  2) 用户名拼错，或当前登录的 GitHub 账号不是 $UserName
  3) 网络访问 github.com 失败（校园网/公司网络常需代理）
     -> 浏览器能打开 https://github.com 说明网络没问题，重跑本脚本并在弹窗里完成授权
"@
}

Write-Host ""
Write-Host "完成。1~2 分钟后访问： https://$UserName.github.io" -ForegroundColor Green
Write-Host "如果 404：检查 Settings -> Pages 是否选了 main / (root)。" -ForegroundColor DarkGray
