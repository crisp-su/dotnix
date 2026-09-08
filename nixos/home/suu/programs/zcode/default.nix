{
  dotnix,
  options,
  lib,
  ...
}:

lib.mkMerge [
  {
    home.packages = [ dotnix.pkgs.zcode ];
  }

  (lib.mkIf (options.home ? persistence) {
    home.persistence."/persist" = {
      directories = [
        ".zcode"
        ".config/ZCode"
      ];
    };
  })
]
