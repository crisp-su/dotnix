{ lib, ... }:

{
  programs.niri = {
    settings = {
      outputs = {
        "eDP-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.00;
          };
          scale = 1.25;
        };
      };

      layout = {
        struts = {
          top = 0;
          right = 0;
          bottom = lib.mkForce 1;
          left = 0;
        };
        gaps = lib.mkForce 0;

        border.enable = lib.mkForce false;
      };

      gestures = {
        hot-corners.enable = false;
      };

      animations = {
        workspace-switch.enable = false;
      };

      window-rules = lib.mkAfter [
        {
          geometry-corner-radius = {
            top-left = 0.00;
            top-right = 0.00;
            bottom-right = 0.00;
            bottom-left = 0.00;
          };
        }
      ];
    };
  };
}
