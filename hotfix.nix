{ nixpkgs-unstable, ... }:
{
  boot.kernelPackages = nixpkgs-unstable.linuxPackages;
  services.nginx.package = nixpkgs-unstable.nginx;
}
