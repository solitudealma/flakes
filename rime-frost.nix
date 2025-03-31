{ stdenv, lib, fetchFromGitHub, }:
stdenv.mkDerivation {
  pname = "rime-frost";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "gaboolic";
    repo = "rime-frost";
    rev = "f85dbcad825020a1322a82147f5d6ed1fdc6e0aa";
    sha256 = "sha256-WTarFbZOvWxH+Nw2/i0esh/gsDnXV7OEiwclPn0S+fY=";
  };

  # buildPhase = ''
  #   runHook preBuild

  #   mv default.yaml rime_frost_suggestion.yaml # mutil schema

  #   runHook postBuild
  # '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data
    cp -r * $out/share/rime-data/

    runHook postInstall
  '';
  meta = with lib; {
    description = "Fcitx 5 PinyinDictionary from rime-frost";
    homepage = "https://github.com/gaboolic/rime-frost";
    license = licenses.unlicense;
  };
}
