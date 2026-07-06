{ pkgs, lib, ... }:

let
  # nix管理ツールが上流ソースに同梱している agent skill。
  # 本体パッケージと同一バージョンのソースから取得するため、常にツールとスキルが揃う。
  toolSkills = {
    herdr = "${pkgs.herdr.src}/SKILL.md";
    gh = "${pkgs.gh.src}/skills/gh/SKILL.md";
    gh-skill = "${pkgs.gh.src}/skills/gh-skill/SKILL.md";
  };

  # Claude Code は ~/.claude/skills、Codex はクロスエージェント標準の ~/.agents/skills を読む
  mkSkillLinks = prefix:
    lib.mapAttrs' (name: src:
      lib.nameValuePair "${prefix}/${name}/SKILL.md" { source = src; })
      toolSkills;
in
{
  home.file = mkSkillLinks ".claude/skills" // mkSkillLinks ".agents/skills";
}
