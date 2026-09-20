{
  options,
  lib,
  ...
}:

lib.mkMerge [
  {
    programs.gpg = {
      enable = true;

      settings = {
        default-key = "38E2F1CFF70F668D24312B33CC5F4B00AB3FF84B";
      };
    };
  }

  (lib.mkIf (options.home ? persistence) {
    home.persistence."/persist" = {
      directories = [
        {
          directory = ".gnupg";
          mode = "0700";
        }
      ];
    };
  })
]
