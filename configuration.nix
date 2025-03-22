# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# Rijan: This file has been hardlinked to /home/rijan/repos/MyConfigs/

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /home/rijan/myflakes/plink2.nix
      /home/rijan/myflakes/snpeff.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents. # Rijan: Anything after the first line was added by me.
  services.printing.enable = true;
  services.printing.drivers  = [ pkgs.gutenprint ];
  services.avahi.openFirewall = true;

  services.printing.browsing = true;
  services.printing.browsedConf = ''
  BrowseDNSSDSubTypes _cups,_print
  BrowseLocalProtocols all
  BrowseRemoteProtocols all
  CreateIPPPrinterQueues All

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  
  BrowseProtocols all
      '';
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
    environment.etc = {
    "resolv.conf".text = "nameserver 1.1.1.3\nnameserver 2606:4700:4700::1113\n";
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # This is for kbfs
  #services.keybase.enable = true;
  #services.kbfs.enable = true;
  # Enable basic Keybase and KBFS services
  services.keybase.enable = true;
  services.kbfs.enable = true;
  services.kbfs.mountPoint = "/home/rijan/keybase/";

  # ---
  # enable flakes
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  #---
  
  # This is to enable postgres 
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_16;
  services.postgresql.authentication = pkgs.lib.mkOverride 10 ''
    # Generated file; do not edit!
    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    local   all             all                                     trust
    host    all             all             127.0.0.1/32            trust
    host    all             all             ::1/128                 trust
    '';
  
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];

  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rijan = {
    isNormalUser = true;
    description = "rijan";
    extraGroups = [ "networkmanager" "wheel"];
    packages = with pkgs;
    let
      RStudio-with-my-packages = rstudioWrapper.override{
        packages = with rPackages; [ 
          ggplot2
          ggtree
          devtools
          igraph
          ggpubr
          dplyr
          shiny
          tidyverse
          bigsnpr
          data_table
          bslib
          svglite
          ggExtra
          ape
          phylotools
          argparse
          plotly
          DT
          rlang
          shinyFiles
          shinyBS
          rPackages.IRkernel
          rPackages.languageserver
          ];
      };
      R-with-my-packages = rWrapper.override{
        packages = with rPackages; [ 
          ggplot2
          ggpubr
          devtools
          dplyr
          shiny
          plotly
          tidyverse
          data_table
          bslib
          svglite
          ggExtra
          argparse
          ggtree
          rPackages.IRkernel
          rPackages.languageserver
          ];
      };
      python-with-my-packages = python3.withPackages (ps: with ps; [
        numpy
        pandas
        matplotlib
        python312Packages.psycopg2
        python312Packages.pyarrow
        python312Packages.marimo
        python312Packages.duckdb
        python312Packages.spyder-kernels
        python312Packages.pysam
        python312Packages.ipykernel
        python312Packages.jupyterlab
        python312Packages.polars
        python312Packages.spyder-kernels
        python312Packages.qtconsole
        python312Packages.newick
        python312Packages.ete3
        python312Packages.xlsx2csv
        python312Packages.flask
        python312Packages.sqlalchemy
        python312Packages.flask-sqlalchemy
        python312Packages.werkzeug
        python312Packages.flask-session
        python312Packages.pyqt6
      ]);
    in
     [
      sqlite-interactive
      zed-editor
      yt-dlp
      clementine
      ripgrep
      duckdb
      inetutils
      vlc
      tesseract4
      ytdownloader
      plink-ng
      bcftools
      spotube
      samba4Full
      gnome-podcasts
      wget
      mailspring
      awscli2
      neovim
      valgrind
      obs-studio
      sox
      gdb
      pandoc
      authenticator
      anki-bin
      postgresql_16
      backblaze-b2
      xlsx2csv
      mercurial
      dart
      flutter
      protonvpn-gui
      libreoffice
      firefox
      unzip
      glibc
      nimble
      c2nim
      libgcc
      bzip2
      xz
      gccgo13
      syncthing
      gnumake42
      zlib
      zlib.dev
      automake115x
      autoconf269
      xclip
      yt-dlp
      thunderbird
      zoom-us
      ncurses
      notcurses
	    helix
	    brave
	    emacs
	    fish
      mosh
      inkscape
	    kitty
      zellij
      vcftools
      zig
      julia
      yazi
      nodePackages_latest.wrangler
      R-with-my-packages
      RStudio-with-my-packages
      python-with-my-packages
      spyder
      openconnect
      htslib
      sioyek
      tor-browser
      nim
      hugo
      rustc
      cargo
      git
      fzf
      glab
      atuin
      the-way
      stow
      typst
      openconnect
      vscode-fhs
      ripcord
      rclone
      onedriver
      keybase
      kbfs
      zotero
      joplin-desktop
      logseq
      calibre
      gimp
      jellyfin-ffmpeg
      jdk17
      waydroid
      perl
      spotify
      canon-cups-ufr2
      tangram
      lazygit
      beeper
    ];
  };

  # this should enable zsh as the default shell
  programs.fish.enable = true;
  # this shoule make zsh the default shell
  users.defaultUserShell = pkgs.fish;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
