{
  description = "SCJ's NixOS Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    parinfer-rust-src = {
      type = "github";
      owner = "eraserhd";
      repo = "parinfer-rust";
      flake = false;
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, parinfer-rust-src, nix-index-database }@inputs:
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
          specialArgs = { inherit inputs system pkgs; };
          modules = [ ./configuration.nix ];
        };
      };
    };
}
