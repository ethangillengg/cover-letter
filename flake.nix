{
  description = "My cover letter";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        system = "x86_64-linux"; # or something else
        config = {allowUnfree = true;};
      };

      watcher = pkgs.writeScriptBin "watch" ''
        tectonic -X build --open & tectonic -X watch
      '';
    in {
      devShell = pkgs.mkShell {
        nativeBuildInputs = [pkgs.bashInteractive];
        buildInputs = with pkgs; [
          rubber
          texlab
          tectonic
        ];
      };

      apps = {
        watch = {
          type = "app";
          program = "${watcher}/bin/watch";
        };
      };
    });
}
