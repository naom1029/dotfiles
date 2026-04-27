# ============================================
# PowerShell 7 Profile - 実用的な設定例
# ============================================


chcp 65001 > $null
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Import-Module PSReadLine

# --- 補完／予測 IntelliSense設定 ---
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle InlineView
# 色を少し見やすく調整（任意）
Set-PSReadLineOption -Colors @{
    InlinePrediction = "$([char]0x1b)[38;5;238m"  # 明るめグレーなど
}

# --- タブ補完・キー割り当て調整 ---
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
# 右矢印で予測全文受け入れを使いたいなら：
Set-PSReadLineKeyHandler -Chord "RightArrow" -Function AcceptSuggestion

# --- よく使うエイリアス ---
Set-Alias ll Get-ChildItem
Set-Alias grep Select-String
Set-Alias touch New-Item



# --- Gitブランチ表示（gitが入っている場合） ---
function Get-GitBranch {
    try {
        # 現在のブランチ名を取得
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($branch) {
            return $branch.Trim()
        }
    } catch {
        # Gitコマンドが失敗した場合、空文字列を返す
        return ""
    }
}

function Prompt {
    # カレントディレクトリのパスを取得
    $currentPath = Get-Location

    # ブランチ名を取得
    $branch = Get-GitBranch

    Write-Host "[" -NoNewline
    Write-Host $currentPath -NoNewline -ForegroundColor Cyan
    Write-Host "]" -NoNewline

    if($branch){
        Write-Host "[" -NoNewline
        Write-Host $branch -NoNewline -ForegroundColor Magenta
        Write-Host "]" -NoNewline
    }

    return " > "
}

# --- 初回起動メッセージ ---
Write-Host "✅ PowerShell 7 Profile loaded." -ForegroundColor Green

set-alias vi 'C:\Program Files\Vim\vim91\vim.exe'
set-alias vim 'C:\Program Files\Vim\vim91\vim.exe'

