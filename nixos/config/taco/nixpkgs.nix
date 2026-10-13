{ self, lib, ... }:

{
  nixpkgs = {
    overlays = lib.mkBefore [ self.overlays.default ];
  };
}
