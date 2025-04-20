{ config, pkgs, ...}:

let 
	freeshowApp = import ../../derivations/freeshow.nix { inherit pkgs; };
in
{
  users.users.petere = {
    isNormalUser = true;
    description = "Peter Edley";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
		  freeshowApp
	  ];

  home-manager.users.petere = {
    home.stateVersion = "24.11";
    imports = [];
    home.packages = with pkgs; [ 
      nixfmt 
      nixd
    ];

    programs = {
      thunderbird = {
        enable = true;
        profiles = {
          default ={
            isDefault = true;
          };
        };
      };
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["git" "thefuck"];
        theme = "lukerandall";
      };
    };
    programs.git = {
      enable = true;
      userName = "Peter Edley";
      userEmail = "peter@edleyit.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
    programs.direnv.enable = true;
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        mkhl.direnv
        arrterian.nix-env-selector
      ];
    };
  };
}