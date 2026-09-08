{
  perSystem =
    { pkgs, ... }:
    {
      packages.zcode = pkgs.callPackage ../../packages/zcode/package.nix { };
    };
}
