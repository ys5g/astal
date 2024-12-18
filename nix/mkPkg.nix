self: pkgs: src:
let
  inherit (builtins) replaceStrings readFile;
  readVer = file: replaceStrings ["\n"] [""] (readFile file);
  process = import ./processPkg.nix self pkgs;
  
  mkPkg' = {pname, description, libDeps ? [], cliDeps ? []}:
    pkgs.stdenv.mkDerivation {
      inherit pname src;
      version = readVer "${src}/version";
      nativeBuildInputs = with pkgs; [
        wrapGAppsHook
        gobject-introspection
        meson
        pkg-config
        ninja
        vala
        wayland
        wayland-scanner
        python3
      ];

      propagatedBuildInputs = [pkgs.glib] ++ libDeps ++ cliDeps;
      postUnpack = ''
        cp --remove-destination ${../lib/gir.py} $sourceRoot/gir.py
      '';
      outputs = ["out" "dev"];

      meta = {inherit description;};
    };
in mkPkg' (process (import src))
