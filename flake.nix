{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system  = "x86_64-linux";
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
