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
      # __include = "wanxiang_suggestion:/";
      "schema_list" = [{ schema = "wanxiang_pro"; }];
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
  "share/rime-data/wanxiang_pro.custom.yaml" = builtins.toJSON {
    patch = {
      "speller/algebra" = {
        "__patch" = [ "wanxiang_pro.schema:/小鹤双拼" "wanxiang_pro.schema:/直接辅助" ];
      };
      "cn_en/user_dict" = "en_dicts/flypy";
      "custom_phrase/user_dict" = "custom/jm_flypy";
      #生日信息：/sr或者osr，在这里定义全局替换构建你的生日查询数据库
      "birthday_reminder" =
        { # 日期格式：必须是4位数字，格式为MMDD（月份和日期），例如：1月27日 → 0127 ，#备注格式：在日期后添加逗号，然后添加任意文本作为备注，例如："0501,我的好朋友"，也可以无备注
          "solar_birthdays" = { # 公历生日, 姓名: "日期,备注" or 姓名: "日期"
            "小明" = "0501,准备礼物";
          };
          "lunar_birthdays" = { # 农历生日, 姓名: "日期,备注" or 姓名: "日期"
            "猪猪" = "0726,大笨猪生日";
          };
        };
      "translator/enable_user_dict" = false; # 关闭自动调频
      "translator/packs/+" = [
        # "solitudealma_wanxiang"
      ]; # 添加词库扩展包，在用户目录下建立 wanxiang_pack.dict.yaml 文件
    };
  };
  "share/rime-data/wanxiang_mixedcode.custom.yaml" = builtins.toJSON {
    patch = {
      "speller/algebra" = { __include = "wanxiang_mixedcode.schema:/小鹤双拼"; };
    };
  };
  "share/rime-data/wanxiang_reverse.custom.yaml" = builtins.toJSON {
    patch = {
      "speller/algebra" = { __include = "wanxiang_reverse.schema:/小鹤双拼"; };
    };
  };
  "share/rime-data/solitudealma_wanxiang.dict.yaml" =
    makeDict "solitudealma_wanxiang" [ ];
})
