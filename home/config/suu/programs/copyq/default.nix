{ options, lib, ... }:

lib.mkMerge [
  {
    dotnix.programs.copyq = {
      enable = true;

      config = builtins.readFile ./copyq.conf;
    };
  }

  (lib.optionalAttrs (options.home ? persistence) {
    home.persistence."/persist" = {
      directories = [
        ".local/share/copyq"
      ];
    };
  })
]
