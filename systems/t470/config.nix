{config, lib, ...} :
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariable = true;

  networking.hostName = "peter-laptop";
}