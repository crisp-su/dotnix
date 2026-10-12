{ pkgs, ... }:

{
  substituteDir =
    {
      name ? "subst-${baseNameOf (toString src)}",
      src,
      vars,
    }:
    pkgs.runCommand name (vars // { inherit src; }) /* bash */ ''
      cp -r "$src" "$out"
      chmod -R +w "$out"

      find "$out" -type f | while read file; do
        echo "Substituing variables in $file..."
        substituteAllInPlace "$file"
      done
    '';
}
