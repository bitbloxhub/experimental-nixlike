let
  pins = import ./npins;
  nilla = import pins.nilla;
in
nilla.create (
  {
    lib,
    ...
  }:
  {
    includes = [ ./nix/modules/nilla/shell.nix ];
    config = {
      inputs = lib.modules.merge [
        (builtins.mapAttrs (name: value: { src = value; }) pins)
        {
          make-shell.loader = "flake";
          mkshell-minimal.loader = "legacy";
          nilla-cli.loader = "nilla";
        }
      ];
    };
  }
)
