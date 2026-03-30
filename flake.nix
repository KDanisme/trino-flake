{
  description = "Trino SQL query engine";
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (ctx: {
      debug = true;
      systems = [ "x86_64-linux" ];
      imports = [
        inputs.flake-root.flakeModule
        inputs.treefmt-nix.flakeModule
        inputs.pre-commit-hooks.flakeModule
      ];
      perSystem =
        {
          pkgs,
          config,
          ...
        }:
        {
          pre-commit.settings.hooks.treefmt.enable = true;
          treefmt.config = {
            inherit (config.flake-root) projectRootFile;
            flakeCheck = false;
            programs = {
              nixfmt.enable = true;
              prettier.enable = true;
            };
          };
          packages = rec {
            trino-basic = pkgs.callPackage ./packages/trino-basic.nix { inherit trino; };
            trino-basic-minimal = pkgs.callPackage ./packages/trino-basic.nix { trino = trino-minimal; };
            trino = pkgs.callPackage ./packages/trino.nix { };
            trino-minimal = trino.override ({ minimal = true; });
            default = trino;

          };
          devShells.default = pkgs.mkShell {
            inputsFrom = [
              config.pre-commit.devShell
              config.treefmt.build.devShell
            ];
          };
        };
    });
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-root.url = "github:srid/flake-root";
  };
}
