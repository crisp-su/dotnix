{
  config,
  pkgs,
  lib,
  ...
}:

lib.mkMerge [
  {
    qt = {
      enable = true;

      platformTheme = {
        name = "kde";
      };

      style = {
        name = "breeze";
        package = with pkgs; [
          kdePackages.breeze
          kdePackages.breeze.qt5
        ];
      };
    };

    xdg.configFile."kdeglobals".text = /* ini */ ''
      ${builtins.readFile "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors"}
    '';
  }

  (
    let
      sessionVariables = {
        QT_QPA_PLATFORMTHEME = lib.mkForce "xdgdesktopportal";
        QT_QPA_PORTAL_FALLBACK_THEME = config.qt.platformTheme.name;
      };
    in
    {
      systemd.user.sessionVariables = sessionVariables;
      home.sessionVariables = sessionVariables;
    }
  )
]
