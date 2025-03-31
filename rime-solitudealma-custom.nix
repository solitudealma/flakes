{ lib, linkFarm, writeText, ... }:
let
  makeDict = name: dicts:
    let
      body = builtins.toJSON {
        inherit name;
        version = "1.0";
        sort = "by_weight";
        use_preset_vocabulary = false;
        import_tables = dicts;
      };
    in ''
      # Rime dictionary
      # encoding: utf-8
      ---
      ${body}
      ...
    '';
in linkFarm "rime-solitudealma-custom" (lib.mapAttrs writeText {
  "share/rime-data/default.custom.yaml" = builtins.toJSON {
    patch = {
      # 方案列表
      # __include = "rime_frost_suggestion:/";
      "schema_list" = [{ schema = "rime_frost"; }];
      "menu/page_size" = 9;
      "switcher/hotkeys" = [ "F4" ];
      "ascii_composer/switch_key" = {
        "Caps_Lock" = "noop";
        "Shift_L" = "commit_code";
        "Shift_R" = "commit_code";
        "Control_L" = "noop";
        "Control_R" = "noop";
      };
    };
  };
  "share/rime-data/rime_frost.custom.yaml" = builtins.toJSON {
    patch = {
      "switches" = [
        {
          name = "ascii_mode";
          reset = 1;
        }
        {
          name = "emoji";
          reset = 1;
        }
        {
          name = "traditionalization";
          reset = 0;
        }
      ];
      "translator/dictionary" = "solitudealma_rime_frost";
    };
  };
  "share/rime-data/solitudealma_rime_frost.dict.yaml" =
    makeDict "solitudealma_rime_frost" [
      "cn_dicts/8105" # 字表
      "cn_dicts/41448" # 大字表（按需启用）
      "cn_dicts/base" # 基础词库
      "cn_dicts/ext" # 扩展词库
      "cn_dicts/tencent" # 腾讯词向量（大词库，部署时间较长）
      "cn_dicts/others" # 一些杂项
      # 细胞词库
      "cn_dicts_cell/medication"
      "cn_dicts_cell/industry_product"
      "cn_dicts_cell/exthot"
      "cn_dicts_cell/chess"
      "cn_dicts_cell/chess2"
      "cn_dicts_cell/animal"
      "cn_dicts_cell/game"
      "cn_dicts_cell/idiom"
      "cn_dicts_cell/sport"
      "cn_dicts_cell/media"
      "cn_dicts_cell/shulihua"
      "cn_dicts_cell/food"
      "cn_dicts_cell/inputmethod"
      "cn_dicts_cell/history"
      "cn_dicts_cell/place"
      "cn_dicts_cell/geography"
      "cn_dicts_cell/name2"
      "cn_dicts_cell/literature"
      "cn_dicts_cell/music"
      "cn_dicts_cell/computer"
      "cn_dicts_cell/composite"
      "cn_dicts_cell/name"
    ];
})
