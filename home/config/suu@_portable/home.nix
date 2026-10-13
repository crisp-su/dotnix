{
  self,
  inputs,
  system,
}:

inputs.home-manager.lib.homeManagerConfiguration (
  let
    inherit (self.legacyPackages.${system}) dotnix;

    pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ self.overlays.default ];
      config.allowUnfree = true;
    };

    pkgs-weekly = import inputs.nixpkgs-weekly {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    inherit pkgs;

    extraSpecialArgs = {
      inherit
        self
        inputs
        dotnix
        pkgs-weekly
        ;
    };

    modules = [
      self.homeOptions

      inputs.sops-nix.homeManagerModules.default
      inputs.catppuccin.homeModules.default
      inputs.dotnvim.homeModules.default
      inputs.zen-browser.homeModules.default
      inputs.stylix.homeModules.default

      ./configuration.nix
    ];
  }
)
