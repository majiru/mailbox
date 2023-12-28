{
  description = "moody's mail server configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-23.11";
    mailserver.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs, mailserver }:
    let
      userKeys = (nixpkgs.lib.strings.splitString "\n" (nixpkgs.lib.strings.removeSuffix "\n" (builtins.readFile ./user.keys)));
    in
    {
      nixosConfigurations.indexwarp = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { keys = userKeys; };
        modules = [
          mailserver.nixosModule
          ./hardware-configuration.nix
          ./configuration.nix
        ];
      };
    };
}
