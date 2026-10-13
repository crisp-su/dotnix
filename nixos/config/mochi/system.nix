{ self, inputs, ... }:

inputs.nixpkgs.lib.nixosSystem (
  let
    system = "x86_64-linux";

    inherit (self.legacyPackages.${system}) dotnix;

    pkgs-weekly = import inputs.nixpkgs-weekly {
      inherit system;
      config.allowUnfree = true;
    };
  in
  rec {
    specialArgs = {
      inherit
        self
        inputs
        dotnix
        pkgs-weekly
        ;
    };

    modules = [
      self.nixosOptions

      inputs.home-manager.nixosModules.default
      inputs.impermanence.nixosModules.default
      inputs.sops-nix.nixosModules.default
      inputs.stylix.nixosModules.default
      inputs.niri.nixosModules.niri
      inputs.noctalia.nixosModules.default

      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          extraSpecialArgs = specialArgs;

          sharedModules = [
            self.homeOptions

            inputs.sops-nix.homeManagerModules.default
            inputs.catppuccin.homeModules.default
            inputs.plasma-manager.homeModules.plasma-manager
            inputs.noctalia.homeModules.default
            inputs.dotnvim.homeModules.default
            inputs.zen-browser.homeModules.default

            # NOTE: Impermanence, stylix, and niri Home Manager modules are
            # automatically imported by the corresponding NixOS modules.
          ];

          # `home-manager.users` defined in ./users.nix
        };
      }

      ./configuration.nix
    ];
  }
)
