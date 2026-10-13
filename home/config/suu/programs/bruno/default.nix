{
  options,
  pkgs,
  lib,
  ...
}:

lib.mkMerge [
  {
    home.packages = with pkgs; [ bruno ];
  }

  (lib.optionalAttrs (options.home ? persistence) {
    home.persistence."/persist" = {
      directories = [
        "bruno"
        ".config/bruno"
        ".local/share/bruno"
      ];
    };
  })
]
