-- cssmodules-language-server 設定
-- CSS Modules の import に対する補完と定義ジャンプを提供する。

return {
  -- lspconfig のデフォルトは javascript/typescript も含むため、CSS Modules を
  -- 使わない素の .ts でもバッファを開くたびに node プロセスが起動していた。
  -- CSS Modules の import はコンポーネントファイルにしか現れないので
  -- *react のみに絞る。
  filetypes = {
    'javascriptreact',
    'typescriptreact',
  },
}
