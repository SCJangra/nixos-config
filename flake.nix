{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, neovim-nightly-overlay, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system  = "x86_64-linux";
      specialArgs = inputs;
      modules = [ 
        ./configuration.nix 
        home-manager.nixosModules.home-manager
        {
          home-manager.users.scj       = ./home-manager.nix;
          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs   = true;
        }
      ];
    };
  };
}
