{
  inputs,
  lib,
  self,
  ...
}:

let
  overlayFiles = builtins.filter (f: f != ./default.nix && lib.hasSuffix ".nix" (toString f)) (
    lib.filesystem.listFilesRecursive ./.
  );

  loadOverlay =
    file:
    let
      imported = import file;
      args = builtins.functionArgs imported;
    in
    if args ? inputs || args ? lib || args ? self then
      imported { inherit inputs lib self; }
    else
      imported;
in

{
  default = lib.foldl' lib.composeExtensions (_final: _prev: { }) (map loadOverlay overlayFiles);
}
