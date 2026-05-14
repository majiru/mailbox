{
  description = "moody's mail server configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11-small";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable-small";

    mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.11";
    mailserver.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      mailserver,
    }:
    let
      userKeys = (
        nixpkgs.lib.strings.splitString "\n" (
          nixpkgs.lib.strings.removeSuffix "\n" (builtins.readFile ./user.keys)
        )
      );
    in
    {
      nixosConfigurations.indexwarp = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          keys = userKeys;
          nixpkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
        };
        modules = [
          ./hotfix.nix
          mailserver.nixosModule
          ./hardware-configuration.nix
          ./configuration.nix
        ];
      };
    };
}
