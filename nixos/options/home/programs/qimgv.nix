{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotnix.programs.qimgv;
in
{
  options.dotnix.programs.qimgv = {
    enable = lib.mkEnableOption "Whether to enable qimgv.";
    package = lib.mkPackageOption pkgs "qimgv" { };

    config = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "qimgv configuration (INI).";
    };

    theme = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "qimgv theme configuration (INI).";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."qimgv/qimgv.conf" = {
      text = cfg.config;
      force = true;
    };

    xdg.configFile."qimgv/theme.conf" = {
      text = cfg.theme;
      force = true;
    };
  };
}
