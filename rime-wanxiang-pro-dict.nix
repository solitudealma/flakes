{ stdenv, lib, fetchurl, unzip }:
stdenv.mkDerivation (finalAttrs: {
  pname = "rime-wanxiang-pro-dict";
  version = "nightly";

  src = fetchurl {
    url =
      "https://github.com/amzxyz/rime_wanxiang/releases/download/dict-nightly/1-pro-moqi-fuzhu-dicts.zip";
    hash = "sha256-DnXPot6TbmYVn/RpKrJKnNwjfpxSDxEOGzSZ3qwndDY=";
  };

  nativeBuildInputs = [ unzip ];
  unpackPhase = ''
    unzip -UU $src -d .
  '';

  # buildPhase = ''
  #   runHook preBuild

  #   mv default.yaml wanxiang_suggestion.yaml # mutil schema

  #   runHook postBuild
  # '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/rime-data/dicts
    cp -r pro-moqi-fuzhu-dicts/* $out/share/rime-data/dicts

    runHook postInstall
  '';
  meta = with lib; {
    description = "万象拼音——基于深度优化的词库和语言模型";
    homepage = "https://github.com/amzxyz/rime_wanxiang";
    license = licenses.unlicense;
  };
})
