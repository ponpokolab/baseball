# 大谷サイト同期: tibiboard/ohtani-site の最新生成物を ponpokolab/baseball へ押し込む
# GitHub側cronが止まっても公開サイトが古くならないための保険(2026-07-31設置)
$ErrorActionPreference = 'Stop'
$src = 'F:\projects\ohtani-site'
$dst = 'F:\projects\baseball-mirror'

Set-Location $src
git fetch origin 2>$null
git checkout origin/main -- index.html seiseki.html genki.html app.html gen_ohtani.py seen_videos.json manifest.json

foreach ($f in 'index.html','seiseki.html','genki.html','app.html','gen_ohtani.py','seen_videos.json','manifest.json') {
  Copy-Item (Join-Path $src $f) (Join-Path $dst $f) -Force
}

Set-Location $dst
git pull --rebase 2>$null
git add -A
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
  git commit -m "auto sync from ohtani-site"
  git push
  Add-Content -Path (Join-Path $dst 'sync_log.txt') -Value ("{0} synced" -f (Get-Date -Format 'yyyy-MM-dd HH:mm'))
} else {
  Add-Content -Path (Join-Path $dst 'sync_log.txt') -Value ("{0} no change" -f (Get-Date -Format 'yyyy-MM-dd HH:mm'))
}
