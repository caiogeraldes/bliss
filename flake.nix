{
  description = "Flake for building bliss";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      rust-overlay,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];

        pkgs = import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };

        # minimal set of packages
        rustTools = with pkgs; [
          (rust-bin.stable.latest.default.override {
            extensions = [ "rust-src" ];
          })
          clippy
          rust-analyzer
          cargo
          just
          gcc
          openssl
          pkg-config
        ];

      in
      {
        devShells.default = pkgs.mkShell {
          name = "dev";

          buildInputs = rustTools;

          PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
          # LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath ((if roles.linux then linuxLdLibraryPath else [ ]));

        };
      }
    );
}
