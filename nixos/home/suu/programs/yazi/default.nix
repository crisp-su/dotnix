{
  config,
  options,
  pkgs,
  lib,
  ...
}:

lib.mkMerge [
  (
    let
      yaziFilechooser = pkgs.replaceVarsWith {
        src = ./yazi-filechooser.sh;
        isExecutable = true;

        replacements = {
          bash = lib.getExe pkgs.bash;
          kitty = lib.getExe config.programs.kitty.package;
          yazi = lib.getExe config.programs.yazi.finalPackage;
        };
      };
    in
    {
      programs.yazi = {
        enable = true;
        extraPackages = with pkgs; [
          fd
          ripgrep
          jq
          imagemagick
          ffmpeg
          resvg
          poppler
          fzf
        ];

        shellWrapperName = "y";

        settings = {
          mgr = {
            show_hidden = false;
          };
        };
      };

      xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = /* ini */ ''
        [filechooser]
        cmd = ${yaziFilechooser}
        default_dir = $HOME
        open_mode = suggested
        save_mode = last
      '';
    }
  )

  (lib.optionalAttrs (options ? stylix) {
    stylix.targets.yazi.enable = lib.mkDefault true;
  })

  (lib.mkIf
    (options ? catppuccin && lib.strings.hasPrefix "catppuccin-" config.settings.theme.colorscheme)
    (
      {
        catppuccin.yazi.enable = true;
      }
      // lib.optionalAttrs (options ? stylix) {
        stylix.targets.yazi.enable = false;
      }
    )
  )
]
