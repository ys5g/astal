{
  self,
  pkgs,
}: let
  toTOML = (pkgs.formats.toml {}).generate;

  docgen = pkgs.gi-docgen.overrideAttrs {
    patches = [../nix/doc/gi-docgen.patch];
  };

  process = import ../nix/processPkg.nix self pkgs;

  genLib = {
    flakepkg,
    gir,
    api-ver ? "0.1",
    authors ? "Aylur",
    dependencies ? {},
    browse ? flakepkg,
    website ? flakepkg,
  }: let
    name = "Astal${gir}-${api-ver}";
    pkg = self.packages.${pkgs.system}.${flakepkg};
    src = pkg.dev;

    data = toTOML gir {
      library = {
        inherit authors;
        inherit (pkg) version;
        inherit (pkg.meta) description;
        license = "LGPL-2.1";
        browse_url = "https://github.com/Aylur/astal/tree/main/lib/${browse}";
        repository_url = "https://github.com/aylur/aylur.git";
        website_url = "https://aylur.github.io/astal/guide/libraries/${website}";
        dependencies = ["GObject-2.0"] ++ (builtins.attrNames dependencies);
      };

      extra.urlmap_file = urlmap;
      dependencies = {inherit (dependency) "GObject-2.0";} // dependencies;
    };
  in pkgs.runCommand flakepkg
  {
    nativeBuildInputs = with pkgs; (process (import pkg.src)).libDeps ++ [
      docgen
      glib
      gobject-introspection
    ];
  } 
  ''
    mkdir $out
    gi-docgen generate -C ${data} ${src}/share/gir-1.0/${name}.gir
    cp -r ${name}/* $out
  '';

  dependency = {
    "GObject-2.0" = {
      name = "GObject";
      description = "The base type system library";
      docs_url = "https://docs.gtk.org/gobject/";
    };
    "Gtk-3.0" = {
      name = "Gtk";
      description = "The GTK toolkit";
      docs_url = "https://docs.gtk.org/gtk3/";
    };
    "Gtk-4.0" = {
      name = "Gtk";
      description = "The GTK toolkit";
      docs_url = "https://docs.gtk.org/gtk4/";
    };
    "AstalIO-0.1" = {
      name = "AstalIO";
      description = "Astal Core library";
      docs_url = "https://aylur.github.io/libastal/io";
    };
    "NM-1.0" = {
      name = "NetworkManager";
      description = "The standard Linux network configuration tool suite";
      docs_url = "https://networkmanager.dev/docs/libnm/latest/";
    };
    "WP-0.5" = {
      name = "WirePlumber";
      description = "Modular session/policy manager for PipeWire";
      docs_url = "https://pipewire.pages.freedesktop.org/wireplumber/";
    };
  };

  urlmap = pkgs.writeText "urlmap" ''
    baseURLs = ${builtins.toJSON [
      ["GLib" "https://docs.gtk.org/glib/"]
      ["GObject" "https://docs.gtk.org/gobject/"]
      ["Gio" "https://docs.gtk.org/gio/"]
      ["Gdk" "https://docs.gtk.org/gdk3/"]
      ["Gtk" "https://docs.gtk.org/gtk3/"]
      ["GdkPixbuf" "https://docs.gtk.org/gdk-pixbuf/"]
      ["AstalIO" "https://aylur.github.io/libastal/io"]

      # FIXME: these are not gi-docgen generated, therefore links are broken
      ["NM" "https://networkmanager.dev/docs/libnm/latest/"]
      ["WP" "https://pipewire.pages.freedesktop.org/wireplumber/"]
    ]}
  '';
  # Modified from linkFarmFromDrvs in nixpkgs
  link = name: drvs:
    let convertLib = lib: { name = "libastal/${lib.name}"; path = lib; };
    in pkgs.linkFarm name (map convertLib drvs);
in
(link "reference" (with pkgs; [
  (genLib {
    flakepkg = "io";
    gir = "IO";
    api-ver = "0.1";
    browse = "astal/io";
  })
  (genLib {
    flakepkg = "astal3";
    gir = "";
    api-ver = "3.0";
    browse = "astal/gtk3";
    # extraInputs = [io gtk3 gtk-layer-shell];
    dependencies = {inherit (dependency) "AstalIO-0.1" "Gtk-3.0";};
  })
  (genLib {
    flakepkg = "astal4";
    gir = "";
    api-ver = "4.0";
    browse = "astal/gtk4";
    # extraInputs = [io gtk4 gtk4-layer-shell];
    dependencies = {inherit (dependency) "AstalIO-0.1" "Gtk-4.0";};
  })
  (genLib {
    flakepkg = "apps";
    gir = "Apps";
    # extraInputs = [json-glib];
  })
  (genLib {
    flakepkg = "auth";
    gir = "Auth";
    authors = "kotontrion";
    # extraInputs = [pam];
  })
  (genLib {
    flakepkg = "battery";
    gir = "Battery";
  })
  (genLib {
    flakepkg = "bluetooth";
    gir = "Bluetooth";
  })
  (genLib {
    flakepkg = "cava";
    gir = "Cava";
    authors = "kotontrion";
  })
  (genLib {
    flakepkg = "greet";
    gir = "Greet";
    # extraInputs = [json-glib];
  })
  (genLib {
    flakepkg = "hyprland";
    gir = "Hyprland";
    # extraInputs = [json-glib];
  })
  (genLib {
    flakepkg = "mpris";
    gir = "Mpris";
  })
  (genLib {
    flakepkg = "network";
    gir = "Network";
    # extraInputs = [networkmanager];
    dependencies = {inherit (dependency) "NM-1.0";}; # FIXME: why does this not work?
  })
  (genLib {
    flakepkg = "notifd";
    gir = "Notifd";
    # extraInputs = [json-glib gdk-pixbuf];
  })
  (genLib {
    flakepkg = "powerprofiles";
    gir = "PowerProfiles";
  })
  (genLib {
    flakepkg = "river";
    gir = "River";
    authors = "kotontrion";
  })
  (genLib {
    flakepkg = "tray";
    gir = "Tray";
    authors = "kotontrion";
    # extraInputs = [gtk3 gdk-pixbuf libdbusmenu-gtk3 json-glib];
  })
  (genLib {
    flakepkg = "wireplumber";
    gir = "Wp";
    authors = "kotontrion";
    dependencies = {inherit (dependency) "WP-0.5";}; # FIXME: why does this not work?
    # extraInputs = [wireplumber];
  })
])) // {meta.description = "Documentation for all libraries generated by gi-docgen";}
