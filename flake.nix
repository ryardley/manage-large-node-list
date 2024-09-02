# After this has installed to create a new project you must run: 
#
#   `forge init --force`
#
# This is because the flake is already within the folder.
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    solc = {
      url = "github:ryardley/solc.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    foundry.url = "github:shazow/foundry.nix/monthly"; # Use monthly branch for permanent releases
  };

  outputs = { self, nixpkgs, utils, foundry, solc }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ 
            foundry.overlay 
            solc.overlay
          ];
        };
      in {

        devShell = with pkgs; mkShell {
          buildInputs = [
            # From the foundry overlay
            # Note: Can also be referenced without overlaying as: foundry.defaultPackage.${system}
            foundry-bin
            just
            solc_0_8_9
            solc_0_8_12
            (solc.mkDefault pkgs solc_0_8_12)
          ];

        };
      });
}
