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

chcp 65001
Set-Alias bash "C:\Program Files\Git\bin\bash.exe"
