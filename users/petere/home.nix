{ config, pkgs, home-manager, ... }:

let freeshowApp = import ../../derivations/freeshow.nix { inherit pkgs; };
in {
  users.users.petere = {
    isNormalUser = true;
    description = "Peter Edley";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  home-manager.users.petere = {
    home.stateVersion = "24.11";
    imports = [ ];

    home.packages = with pkgs; [ 
      nixfmt 
      nixd 
      freeshowApp 
      bitwarden-desktop
      gnomeExtensions.appindicator
      gnomeExtensions.night-theme-switcher
      gnomeExtensions.caffeine
      gnomeExtensions.tailscale-status
    ];

    services = { 
      nextcloud-client.enable = true;
      caffeine.enable = true;
   };

    programs = {
      thunderbird = {
        enable = true;
        profiles = { default = { isDefault = true; }; };
      };
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        autocd = true;
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "thefuck" ];
          theme = "lukerandall";
        };
      };
      git = {
        enable = true;
        userName = "Peter Edley";
        userEmail = "peter@edleyit.com";
        extraConfig = { init.defaultBranch = "main"; };
      };
      vscode = {
        enable = true;
        package = pkgs.vscodium;
        profiles.default.extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          mkhl.direnv
          arrterian.nix-env-selector
        ];
      };
      direnv = { enable = true; };
    };
  };
}
