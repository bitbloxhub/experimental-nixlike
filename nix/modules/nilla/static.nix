{ config, ... }:
let
  staticPkgs = builtins.mapAttrs (_: pkgs: pkgs.pkgsStatic) config.inputs.nixpkgs.result;
in
{
  config.packages.static-bash = {
    systems = [ "x86_64-linux" ];
    settings.pkgs = staticPkgs;
    package =
      { bash, ... }:
      bash;
  };

  config.packages.static-patchelf = {
    systems = [ "x86_64-linux" ];
    settings.pkgs = staticPkgs;
    package =
      {
        lib,
        patchelf,
        stdenv,
        ...
      }:
      patchelf.overrideAttrs (_: {
        # https://github.com/NixOS/nixpkgs/pull/515157/changes#r3979777238
        preCheck = lib.optionalString stdenv.hostPlatform.isStatic ''
          export NIX_CFLAGS_LINK="''${NIX_CFLAGS_LINK//-static/}"
        '';
      });
  };
}
