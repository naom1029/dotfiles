-- markdown-oxide 設定
-- Obsidian 風のノート機能（wikilink, デイリーノート, バックリンク）を提供する。

return {
  -- lspconfig のデフォルトは root_markers に '.git' を含むため、
  -- ただの README を開いただけでも marksman と二重に起動していた。
  -- ノート機能が意味を持つのは Vault の中だけなので Vault マーカーに限定する。
  -- 通常のリポジトリの Markdown は marksman が担当する。
  root_markers = {
    '.obsidian',
    '.moxide.toml',
  },
  workspace_required = true,
}
