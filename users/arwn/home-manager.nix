{ isWSL, inputs, ... }:

{ config, lib, pkgs, ... }:

let
  # sources = import ../../nix/sources.nix;
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # For our MANPAGER env var
  # https://github.com/sharkdp/bat/issues/1145
  manpager = (pkgs.writeShellScriptBin "manpager" (if isDarwin then ''
    sh -c 'col -bx | bat -l man -p'
    '' else ''
    cat "$1" | col -bx | bat --language man --style plain
  ''));
in {
  # Home-manager 22.11 requires this be set. We never set it so we have
  # to use the old state version.
  home.stateVersion = "18.09";

  xdg.enable = true;


  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.   
  home.packages = [
    pkgs.git
    pkgs.jujutsu
    # pkgs._1password
    # pkgs.asciinema
    pkgs.bat
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.gh
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    # pkgs.sentry-cli
    # pkgs.tree
    pkgs.watch

    # pkgs.gopls
    #pkgs.zigpkgs."0.13.0"

    # Node is required for Copilot.vim
    pkgs.nodejs
    # Language servers
    pkgs.nodePackages.typescript-language-server
  ] ++ (lib.optionals isDarwin [
    # This is automatically setup on Linux
    pkgs.cachix
    pkgs.tailscale
  ]) ++ (lib.optionals (isLinux && !isWSL) [
    pkgs.chromium
    # pkgs.firefox
    pkgs.rofi
    pkgs.xfce.xfce4-terminal
  ]);

  xdg.configFile = {
    "jj/config.toml".source = ./jujutsu.toml;
    "i3/config".source = ./i3;
  };

	programs.direnv = {
		enable = true;
		nix-direnv.enable = true;
	};

  programs.fish = {
    enable = true;
    shellAliases = {
      e = "nvim";
			eee = "sed 's/[a-z]/e/g; s/[A-Z]/E/g; s/[0-9]/0/g'";
			ls = "ls -F";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = builtins.readFile ./nvim.lua;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
			base16-nvim
      ale
    ];
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
				color_scheme = "One Light (base16)",
        font = wezterm.font("Iosevka"),
        font_size = 28,
				hide_tab_bar_if_only_one_tab = true,
      }
    '';
  };

}
