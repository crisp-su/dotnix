{
  config,
  options,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [
  {
    home.packages = with pkgs; [ wakatime-cli ];
  }

  (lib.optionalAttrs (options ? sops) {
    sops.secrets.wakatime_api_key = {
      key = "wakatime/api_key";
      path = "%r/wakatime_api_key";
    };

    sops.templates."wakatime.cfg" = {
      path = "${config.home.homeDirectory}/.wakatime.cfg";
      mode = "0600";
      content = /* ini */ ''
        [settings]
        api_key = ${config.sops.placeholder.wakatime_api_key}
      '';
    };
  })
]
