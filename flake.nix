{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-weekly.url = "github:nixos/nixpkgs/567a49d1913ce81ac6e9582e3553dd90a955875f";

    flake-parts.url = "github:hercules-ci/flake-parts/main";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quadlet-nix = {
      url = "github:SEIAROTg/quadlet-nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    niri = {
      url = "github:sodiboo/niri-flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };

    matugen = {
      url = "github:/InioX/matugen/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotnvim = {
      url = "github:OuOich/dotnvim/master";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit self inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        inputs.home-manager.flakeModules.home-manager
      ];

      perSystem =
        {
          self',
          inputs',
          pkgs,
          ...
        }:
        {
          legacyPackages = {
            lib = import ./library {
              inherit pkgs;
              inherit (pkgs) lib;
            };

            dotnix = {
              inherit (self'.legacyPackages) lib;
              pkgs = self'.packages;
            };
          };

          packages = {
            wallpapers = import ./packages/wallpapers/package.nix {
              inherit pkgs;
              inherit (pkgs) lib;
            };

            zcode = pkgs.callPackage ./packages/zcode/package.nix { };
          };

          devShells.default = import ./shell.nix {
            inherit inputs' pkgs;
          };
        };

      flake = {
        overlays = import (self + /nixos/overlays) {
          inherit inputs self;
          inherit (inputs.nixpkgs) lib;
        };

        nixosOptions = import (self + /nixos/options/system);

        nixosConfigurations = {
          mochi = import (self + /nixos/hosts/mochi/system.nix) { inherit self inputs; };
          taco = import (self + /nixos/hosts/taco/system.nix) { inherit self inputs; };
          vps-rainyun-gofer = import (self + /nixos/hosts/vps-rainyun-gofer/system.nix) {
            inherit self inputs;
          };
        };

        homeOptions = import (self + /nixos/options/home);

        deploy = import (self + /nixos/deploy.nix) { inherit inputs self; };
      };
    };
}
