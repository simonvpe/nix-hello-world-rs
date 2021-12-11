{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
  };

  outputs = { self, nixpkgs, flake-utils, naersk }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages."${system}";
        naersk-lib = naersk.lib."${system}";
      in
        rec {
          # `nix build`
          packages.nix-hello-world-rs = naersk-lib.buildPackage {
            pname = "nix-hello-world-rs";
            root = ./.;
          };
          defaultPackage = packages.nix-hello-world-rs;

          # `nix run`
          apps.hello-world = flake-utils.lib.mkApp {
            drv = packages.nix-hello-world-rs;
          };
          defaultApp = apps.hello-world;

          # `nix develop`
          devShell = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              rustc
              cargo
              rust-analyzer
              clippy
            ];
          };
        }
    );
}
