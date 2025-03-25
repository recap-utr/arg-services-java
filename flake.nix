{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };
  outputs =
    inputs@{
      flake-parts,
      systems,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      perSystem =
        {
          pkgs,
          lib,
          ...
        }:
        {
          packages = {
            buf-generate = pkgs.writeShellApplication {
              name = "buf-generate";
              text = ''
                ${lib.getExe pkgs.buf} generate
              '';
            };
          };
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ gradle ];
            shellHook = ''
              ${lib.getExe pkgs.gradle} wrapper
            '';
          };
        };
    };
}
