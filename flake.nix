{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      # hostModule is the host-specific hyprland module passed as an extra import
      hmModule = hostModule: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs;
          stylix = inputs.stylix;
        };
        home-manager.users.chuck = {
          imports = [ ./home.nix hostModule ];
        };
      };

      sharedModules = [
        inputs.stylix.nixosModules.stylix
        inputs.hyprland.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
      ];
    in
    {
      nixosConfigurations = {
        nixdesktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = sharedModules ++ [
            ./hosts/nixdesktop/configuration.nix
            (hmModule ./modules/hyprland/nixdesktop.nix)
          ];
        };

        nixframe = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = sharedModules ++ [
            ./hosts/nixframe/configuration.nix
            (hmModule ./modules/hyprland/nixframe.nix)
          ];
        };
      };
    };
}
