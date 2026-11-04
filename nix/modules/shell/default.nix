{
  pkgs,
  ...
}:
{
  packages = [
    pkgs.nilla-cli
    pkgs.nixfmt
    pkgs.npins
  ];
  stdenv = (pkgs.mkshell-minimal { }).stdenv;
}
