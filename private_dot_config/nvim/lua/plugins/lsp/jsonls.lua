-- JSON Language Server 設定
-- schemastore を使用して JSON スキーマを自動適用

return {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}
