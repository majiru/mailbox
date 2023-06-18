{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      (builtins.fetchTarball {
        url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-23.05/nixos-mailserver-nixos-23.05.tar.gz";
        sha256 = "0bbv0hcwpm9vhvqnj51k84c3fx6x0vgv68yf0f8kdjvprpzxjdgk";
      })
    ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "postmaster@indexwarp.net";
  };
  mailserver = {
    enable = true;
    fqdn = "mail.indexwarp.net";
    domains = [ "indexwarp.net" ];
    loginAccounts = {
      "moody@indexwarp.net" = {
        hashedPasswordFile = "/var/secrets/moody.passwd";
        aliases = [
          "postmaster@indexwarp.net"
        ];
      };
    };
    certificateScheme = "acme-nginx";
  };

  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  networking.hostName = "mail"; # Define your hostname.
  time.timeZone = "US/Central";
  i18n.defaultLocale = "en_US.UTF-8";
  users.mutableUsers = false;
  security.sudo.wheelNeedsPassword = false;

  users.users.moody = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = (pkgs.lib.strings.splitString "\n" (pkgs.lib.strings.removeSuffix "\n" (builtins.readFile (builtins.fetchurl "https://github.com/majiru.keys"))));
  };
  users.groups."mailers".members = [ "dovecot2" "postfix" ];
  nix.settings.trusted-users = [ "root" "@wheel" ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;

  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

