{ pkgs, inputs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Since we're using fish as our shell
  programs.fish.enable = true;

  users.users.arwn = {
    isNormalUser = true;
    home = "/home/arwn";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    hashedPassword = "$6$3SCNHdRCCochCSiq$aDaufcA3zZ6dQz4Jzi8YTF4i7BqotmS7p9X3B1leHQP/LUAWHSILuK8B5AOA/FCztW0Mbr7bgq1COjfK/NjJp/";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAf/sNbqapH4L+aDNH+r8Ppw1vTs4R3vYP7vPcnywxh2 windham.aren@protonmail.com"
    ];
  };

  #nixpkgs.overlays = import ../../lib/overlays.nix ++ [
    # (import ./vim.nix { inherit inputs; })
  #];
}
