{
  description = "SCJ's NixOS Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    iosevka = {
      url = "https://github.com/SCJangra/Iosevka/releases/download/stable/iosevka.zip";
      flake = false;
    };

    fluida = {
      url = "https://github.com/brummer10/Fluida.lv2/releases/download/v0.9.3/Fluida.lv2-v0.9.3-linux-x86_64.tar.xz";
      flake = false;
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, iosevka, fluida, home-manager, nix-index-database, agenix }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [ nil ];
      };

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            system = system;
          };
          modules = [ ./configuration.nix ];
        };
      };
    };
}
