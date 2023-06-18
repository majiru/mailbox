let
  pkgs = import (import ./nixpkgs.nix) { };
in
{
  network = {
    inherit pkgs;
    description = "Mail Server";
  };

  "mail.indexwarp.net" = { config, pkgs, ... }: {
    deployment.targetUser = "moody";
    deployment.secrets = {
      "moody-passwd" = {
        source = "./moody.passwd";
        destination = "/var/secrets/moody.passwd";
        owner.user = "root";
        owner.group = "mailers";
        permissions = "0440";
        action = [ "sudo" "systemctl" "reload" "postfix.service" "dovecot2.service" ];
      };
    };
  } // ((import ./configuration.nix) {
    inherit pkgs config;
  });
}
