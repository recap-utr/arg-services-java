{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    systems,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;
      perSystem = {
        pkgs,
        system,
        lib,
        self',
        ...
      }: let
        packages = with pkgs; [gradle buf];
      in {
        packages = {
          releaseEnv = pkgs.buildEnv {
            name = "release-env";
            paths = packages ++ (with pkgs; [nodejs]);
          };
        };
        devShells.default = pkgs.mkShell {
          inherit packages;
          shellHook = ''
            ${lib.getExe pkgs.gradle} wrapper
          '';
        };
      };
    };
}
