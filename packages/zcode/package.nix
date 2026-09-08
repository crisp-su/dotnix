{
  appimageTools,
  fetchurl,
}:

let
  pname = "zcode";
  version = "3.11.2";

  src = fetchurl {
    url = "https://cdn-zcode.z.ai/zcode/electron/releases/${version}/linux-x64/ZCode-${version}-linux-x64.AppImage";
    hash = "sha256-/EzIUShqQOqAkM6/qsGp+b3ETqs0njbu8NOzIZ85MD8=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/zcode.desktop -t $out/share/applications/
    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/zcode.png -t $out/share/icons/hicolor/512x512/apps/
    substituteInPlace $out/share/applications/zcode.desktop --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=zcode --no-sandbox %U'
  '';

  extraPkgs =
    p: with p; [
      libnotify
      nodejs
      bash
    ];

  meta = {
    description = "ZCode Desktop App";
    mainProgram = "zcode";
    platforms = [ "x86_64-linux" ];
  };
}
