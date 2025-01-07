{
  mkAstalPkg,
  pkgs,
  ...
}:
mkAstalPkg {
  pname = "astal-http";
  src = ./.;
  packages = with pkgs; [libsoup_3 glib-networking];

  libname = "http";
  authors = "Ys5g";
  gir-suffix = "Http";
  description = "Libsoup 3 wrapper";
}
