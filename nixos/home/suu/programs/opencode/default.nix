{
  options,
  pkgs,
  pkgs-weekly,
  lib,
  ...
}:

lib.mkMerge [
  {
    programs.opencode = {
      enable = true;
      package = pkgs-weekly.opencode;

      settings = lib.mkMerge [
        (lib.importJSON ./opencode.json)
        {
          mcp.nix.command = [ "${pkgs.mcp-nixos}/bin/mcp-nixos" ];
        }
      ];

      tui = lib.importJSON ./tui.json;
    };
  }

  (lib.optionalAttrs (options.home ? persistence) {
    home.persistence."/persist" = {
      directories = [
        ".local/share/opencode"
      ];
    };
  })

  (lib.optionalAttrs (options ? stylix) {
    stylix.targets.opencode.enable = lib.mkDefault true;
  })
]
