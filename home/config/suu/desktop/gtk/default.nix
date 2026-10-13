{ pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    colorScheme = "dark";

    gtk3 = {
      extraCss = /* css */ ''
        @import "colors.css";
      '';
    };

    gtk4 = {
      extraCss = /* css */ ''
        @import "colors.css";
      '';
    };
  };

  systemd.user.sessionVariables.GTK_USE_PORTAL = "1";
}
