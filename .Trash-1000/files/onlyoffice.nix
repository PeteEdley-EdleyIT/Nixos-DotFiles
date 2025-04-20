{ config, pkgs, ... }:

let


  onlyoffice-with-fonts = pkgs.callPackage "${erosanix}/modules/onlyoffice.nix" {
    inherit pkgs;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
       Liberation_fonts
      ttf-ms-win10-auto # If you need windows fonts, you will have to accept the license.
      # Add any other fonts you require here.
    ];
  };

in
{
  environment.systemPackages = with pkgs; [
    onlyoffice-with-fonts
  ];

  # If you are using ttf-ms-win10-auto, you will need to accept the license.
  # Otherwise, you can remove this option.
  nixpkgs.config.allowUnfree = true;

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    Liberation_fonts
    # Add any other fonts you require here, if you did not add them to the onlyoffice module.
  ];

}
