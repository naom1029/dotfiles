━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  tmux Cheatsheet  (Prefix = Ctrl+g)        q to close
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【セッション】 シェルから
  tmux                  新規セッション
  tmux a                直近セッションへアタッチ
  tmux ls               セッション一覧
  tmux new -s NAME      名前付きで作成
  tmux a -t NAME        名前指定でアタッチ
  tmux kill-server      全部終了（緊急用）

【セッション】 prefix
  Ctrl+g d              デタッチ（抜ける）
  Ctrl+g s              セッション一覧から選択
  Ctrl+g $              セッション名変更

【ウィンドウ（タブ）】 prefix不要
  Alt+]    /  Alt+[     次 / 前のタブ
  Alt+w                 タブを閉じる（確認あり）

【ウィンドウ（タブ）】 prefix
  Ctrl+g c              新規タブ
  Ctrl+g ,              タブ名変更
  Ctrl+g w              全ウィンドウ一覧から選択
  Ctrl+g 1〜9           番号でジャンプ

【ペイン】 prefix不要
  Alt+-    /  Alt+|     水平 / 垂直 分割（CWD継承）
  Alt+h/j/k/l           ペイン移動
  Alt+x                 ペインを閉じる（確認あり）
  Alt+\                 ズームトグル（最大化）

【ペイン】 prefix
  Ctrl+g z              ズームトグル
  Ctrl+g {  /  Ctrl+g } ペイン入れ替え
  Ctrl+g Space          レイアウト切替
  Ctrl+g !              ペインを別ウィンドウへ昇格
  Ctrl+g x              ペインを閉じる（確認あり）

【コピーモード（vi）】
  Ctrl+g [              コピーモード開始
    h/j/k/l, w, b       移動（vim相当）
    /  ?                検索（前方/後方）
    Ctrl+u / Ctrl+d     半画面スクロール
    g  / G              先頭 / 末尾
    v                   選択開始
    Ctrl+v              矩形選択トグル
    y                   コピーしてモード終了
    q                   モード終了
  Ctrl+g ]              ペースト

【設定 / プラグイン】
  Ctrl+g r              tmux.conf リロード
  Ctrl+g ?              全キーバインド一覧（組み込み）
  Ctrl+g I              プラグイン インストール
  Ctrl+g U              プラグイン 更新
  Ctrl+g Alt+u          未使用プラグイン削除
  Ctrl+g Ctrl+s         セッション保存（resurrect）
  Ctrl+g Ctrl+r         セッション復元（resurrect）

【便利】
  Ctrl+g :              コマンドプロンプト
  Ctrl+g t              時計表示（q で閉じる）
  Ctrl+g ~              直近のメッセージ履歴

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
