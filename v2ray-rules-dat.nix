{ lib, stdenvNoCC, fetchurl, }:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "v2ray-rules-dat";
  version = "2025-01-26-01-11";

  srcs = [
    (fetchurl {
      url =
        "https://github.com/techprober/v2ray-rules-dat/releases/download/${finalAttrs.version}/geoip.dat";
      hash = "sha256-L1jLQCsrYh5k5B6z/Wq4Ujzbf13Ht1i/9+h6lGNiROc=";
    })
    (fetchurl {
      url =
        "https://github.com/techprober/v2ray-rules-dat/releases/download/${finalAttrs.version}/geosite.dat";
      hash = "sha256-ubYM+IkncWOkpjg5ndDxEeFo8nP2g7pO4iOSyG1/lTU=";
    })
  ];

  dontConfigure = true;
  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 ${
      builtins.elemAt finalAttrs.srcs 0
    } $out/share/v2ray/geoip.dat
    install -Dm644 ${
      builtins.elemAt finalAttrs.srcs 1
    } $out/share/v2ray/geosite.dat

    runHook postInstall
  '';

  meta = {
    description =
      "🦄 🎃 👻 V2Ray 路由规则文件加强版，可代替 V2Ray 官方 geoip.dat 和 geosite.dat，兼容 Shadowsocks-windows、Xray-core、Trojan-Go 和 leaf。Enhanced edition of V2Ray rules dat files, compatible with Xray-core, Shadowsocks-windows, Trojan-Go and leaf. ";
    homepage = "https://github.com/techprober/v2ray-rules-dat";
    license = lib.getLicenseFromSpdxId "GPL-3.0-only";
    platforms = lib.platforms.all;
  };
})
