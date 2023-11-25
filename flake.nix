{
  description = "SCJ's NixOS Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    parinfer-rust-src = {
      type = "github";
      owner = "eraserhd";
      repo = "parinfer-rust";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, parinfer-rust-src }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [ nil ];
      };

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [ ./configuration.nix ];
        };
      };
    };
}
