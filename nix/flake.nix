{
  description = "My nix-darwin configuration";

  inputs = {
    # NOTE: versions for nixpkgs, nix-darwin, home-manager should match
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager }:
    {
      darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/mbp/configuration.nix
          home-manager.darwinModules.home-manager
          {
            users.users.levguzman = {
              name = "levguzman";
              home = "/Users/levguzman";
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.levguzman = import ./home/home.nix;
          }
        ];
      };
    };
}
