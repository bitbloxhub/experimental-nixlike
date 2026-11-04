{ config, ... }:
let
  staticOverlay = import ../../overlays/static.nix;
in
{
  config.packages.static-bash = {
    systems = [ "x86_64-linux" ];
    settings = {
      pkgs = builtins.mapAttrs (
        _: pkgs: pkgs.pkgsStatic.extend staticOverlay
      ) config.inputs.nixpkgs.result;
    };
    package =
      { bash, ... }:
      bash;
  };

  config.shells.default = {
    systems = [ "x86_64-linux" ];

    shell =
      {
        pkgs,
        ...
      }:
      let
        makeShellOverlay = config.inputs.make-shell.result.overlays.default;
        makeShellPkgs = pkgs.extend (
          final: prev:
          (makeShellOverlay final prev)
          // {
            mkshell-minimal = config.inputs.mkshell-minimal.result final;
            nilla-cli =
              config.inputs.nilla-cli.result.packages.nilla-cli.result.${final.stdenv.hostPlatform.system};
          }
        );
      in
      makeShellPkgs.make-shell {
        imports = [ ../shell ];
      };
  };
}
