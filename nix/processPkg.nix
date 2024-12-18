self: pkgs:
let
  inherit (pkgs.lib) hasPrefix removePrefix;
  fixInputs = map
    (input:
      if hasPrefix "astalPkgs" input
      then self.packages.${pkgs.system}.${removePrefix "astalPkgs." input}
      else pkgs.${input}
    );
in
{pname, description, libDeps ? [], cliDeps ? []}: {
  inherit pname description;
  cliDeps = fixInputs cliDeps;
  libDeps = fixInputs libDeps;
}
