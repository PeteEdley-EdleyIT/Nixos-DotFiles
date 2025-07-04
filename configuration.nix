{ config, pkgs, lib, device, hostname, secrets, ... }:
# Config for all devices
{
  imports =
    [
      ./systems/${device}/hardware-configuration.nix
      ./systems/${device}/config.nix
    ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  console.keyMap = "uk";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.thefuck = {
    enable = true;
  };
  programs.appimage = {
    enable = true;
    binfmt = true;
  };


  services.tailscale.enable = true;
  networking.firewall.allowedUDPPorts = [ 41641]; #Why need to check

  environment.systemPackages = with pkgs; [
    rustdesk-flutter
    gnome-software
    git-crypt
    vlc
    tailscale
  ];

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    after = ["network-pre.target" "tailscale.service" ];
    wants = ["network-pre.target" "tailscale.service" ];
    wantedBy = ["multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = with pkgs; ''
      sleep 2

      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then
        exit 0
      fi

      ${tailscale}/bin/tailscale up --ssh --authkey ${secrets.tailscale.authkey}
    '';
  };

  system.stateVersion = "24.11";
  nix.settings.experimental-features = ["nix-command" "flakes"];
}