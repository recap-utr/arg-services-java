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
      }: {
        packages = {
          releaseEnv = pkgs.buildEnv {
            name = "release-env";
            paths = with pkgs; [nodejs];
          };
          bufGenerate = pkgs.writeShellApplication {
            name = "buf-generate";
            text = ''
              ${lib.getExe pkgs.buf} mod update
              ${lib.getExe pkgs.buf} generate --include-imports buf.build/recap/arg-services
            '';
          };
        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [gradle];
          shellHook = ''
            ${lib.getExe pkgs.gradle} wrapper
          '';
        };
      };
    };
}
