{
  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux"; # TODO: other architectures
    pkgs = nixpkgs.legacyPackages.${system} // { libcava = pkgs.callPackage ./nix/libcava.nix {}; };

    mkPkg = import ./nix/mkPkg.nix self pkgs;
  in {
    devShells.${system} = import ./nix/devshell.nix {
      inherit self pkgs;
    };

    lib = {
      mkLuaPackage = import ./nix/lua.nix {
        inherit pkgs;
        astal = self;
      };
    };

    packages.${system} = with pkgs; {
      docs = import ./docs {inherit self pkgs;};
      default = self.packages.${system}.io;

      io = mkPkg ./lib/astal/io;
      astal3 = mkPkg ./lib/astal/gtk3;
      astal4 = mkPkg ./lib/astal/gtk4;
      apps = mkPkg ./lib/apps;
      auth = mkPkg ./lib/auth;
      battery = mkPkg ./lib/battery;
      bluetooth = mkPkg ./lib/bluetooth;
      cava = mkPkg ./lib/cava;
      greet = mkPkg ./lib/greet;
      hyprland = mkPkg ./lib/hyprland;
      mpris = mkPkg ./lib/mpris;
      network = mkPkg ./lib/network;
      notifd = mkPkg ./lib/notifd;
      powerprofiles = mkPkg ./lib/powerprofiles;
      river = mkPkg ./lib/river;
      tray = mkPkg ./lib/tray;
      wireplumber = mkPkg ./lib/wireplumber;

      gjs = pkgs.stdenvNoCC.mkDerivation {
        src = ./lang/gjs;
        name = "astal-gjs";
        nativeBuildInputs = [
          meson
          ninja
          pkg-config
          self.packages.${system}.io
          self.packages.${system}.astal3
        ];

        meta.description = "gjs bindings for AstalIO, Astal3, and Astal4";
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
}
