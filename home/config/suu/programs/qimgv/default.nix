{ options, lib, ... }:

lib.mkMerge [
  {
    dotnix.programs.qimgv = {
      enable = true;

      config = builtins.readFile ./qimgv.conf;
      theme = builtins.readFile ./theme.conf;
    };
  }

  (lib.optionalAttrs (options.home ? persistence) {
    home.persistence."/persist" = {
      directories = [
        ".cache/qimgv"
      ];

      files = [
        ".config/qimgv/savedState.conf"
      ];
    };
  })
]
