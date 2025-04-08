{
  description =
    "SolitudeAlma's NixOS, nix-darwin and Home Manager Configuration";
  # It is also possible to "inherit" an input from another input. This is useful to minimize
  # flake dependencies. For example, the following sets the nixpkgs input of the top-level flake
  # to be equal to the nixpkgs input of the nixops input of the top-level flake:
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    daeuniverse.url = "github:daeuniverse/flake.nix";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    maomaowm.url = "github:DreamMaoMao/maomaowm/wlroots-0.19";
    maomaowm.inputs.nixpkgs.follows = "nixpkgs";

    nur-xddxdd.url = "github:xddxdd/nur-packages";

    sops-nix.url = "github:Mic92/sops-nix";

    yazi.url =
      "github:sxyazi/yazi?rev=b6cb1fa8d3fb3fafea7a190f23acaeb44333cfe9";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      username = "solitudealma";
      hostname = "laptop";
    in {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # If the hostname starts with "iso-", generate an ISO image
          specialArgs = { inherit inputs hostname username; };
          modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.backupFileExtension = "backup";
              home-manager.useUserPackages = true;
              home-manager.users.solitudealma = import ./home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs hostname username;
              };
            }
          ];
        };
      };
    };
}
