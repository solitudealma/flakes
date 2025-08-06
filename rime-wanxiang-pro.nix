{ stdenv, lib, fetchurl, unzip }:
stdenv.mkDerivation (finalAttrs: {
  pname = "rime-wanxiang-pro";
  version = "10.0.8";

  src = fetchurl {
    url =
      "https://github.com/amzxyz/rime_wanxiang/releases/download/v${finalAttrs.version}/rime-wanxiang-moqi-fuzhu.zip";
    hash = "sha256-RPYj3cHvQKnPKNEtxSv+T+cfcRNZGbRlbJ/OrqWEKSM=";
  };

  nativeBuildInputs = [ unzip ];
  unpackPhase = ''
    unzip -UU $src
  '';

  # buildPhase = ''
  #   runHook preBuild

  #   mv default.yaml wanxiang_suggestion.yaml # mutil schema

  #   runHook postBuild
  # '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data
    rm -r dicts
    cp -r * $out/share/rime-data/

    runHook postInstall
  '';
  meta = with lib; {
    description = "万象拼音——基于深度优化的词库和语言模型";
    homepage = "https://github.com/amzxyz/rime_wanxiang";
    license = licenses.unlicense;
  };
})
