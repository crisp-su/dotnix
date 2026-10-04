{
  options,
  lib,
  ...
}:

lib.mkMerge [
  (lib.optionalAttrs (options.home ? persistence) {
    home.persistence."/persist" = {
      directories = [
        ".steam"
        ".local/share/Steam"
      ];
    };
  })
]
