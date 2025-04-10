# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# Rijan: This file has been hardlinked to /home/rijan/repos/MyConfigs/

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /home/rijan/myflakes/plink2.nix
      /home/rijan/myflakes/snpeff.nix
      (import "${home-manager}/nixos")
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
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rijan = {
    isNormalUser = true;    
    extraGroups = [ "networkmanager" "wheel"];
  };
  home-manager.users.rijan = {pkgs, ...}: {
    home.packages = with pkgs;
    let
      my_R_packages_list = with rPackages; [
        tidyverse
        rPackages.languageserver
        bslib
        ggplot2
        DT
        ggpubr
        shinyFiles
        bigsnpr
        ggExtra
        plotly
        shiny
        ape
        data_table
        ggtree
        devtools
        igraph
        dplyr
        argparse
        rPackages.IRkernel
        shinyBS
        reactlog
        rlang
        svglite
        phylotools
      ];
      
      RStudio-with-my-packages = rstudioWrapper.override{
        packages = my_R_packages_list;
      };
      R-with-my-packages = rWrapper.override{
        packages = my_R_packages_list;
      };
      python-with-my-packages = python3.withPackages (ps: with ps; [
        numpy
        pandas
        matplotlib
        spyder
        spyder-kernels
        python312Packages.psycopg2
        python312Packages.pyarrow
        python312Packages.marimo
        python312Packages.duckdb
        python312Packages.pysam
        python312Packages.ipykernel
        python312Packages.jupyterlab
        python312Packages.polars
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
      anki-bin
      atuin
      authenticator
      autoconf269
      automake115x
      awscli2
      backblaze-b2
      bcftools
      beeper
      brave
      bzip2
      c2nim
      calibre
      canon-cups-ufr2
      cargo
      clementine
      duckdb
      emacs
      firefox
      fish
      flutter
      fzf
      gccgo13
      gdb
      ghostty
      gimp
      git
      glab
      glibc
      gnome-podcasts
      gnumake42
      helix
      htslib
      hugo
      inetutils
      inkscape
      jdk17
      jellyfin-ffmpeg
      joplin-desktop
      julia
      kbfs
      keybase
      kitty
      lazygit
      libgcc
      libreoffice
      logseq
      mailspring
      mercurial
      mosh
      ncurses
      neovim
      nim
      nimble
      nodePackages_latest.wrangler
      notcurses
      obs-studio
      onedriver
      openconnect
      pandoc
      perl
      plink-ng
      postgresql_16
      protonvpn-gui
      python-with-my-packages
      R-with-my-packages
      rclone
      ripcord
      ripgrep
      RStudio-with-my-packages
      rustc
      samba4Full
      sioyek
      sox
      spotify
      spotube
      sqlite-interactive
      stow
      syncthing
      tangram
      tesseract4
      the-way
      thunderbird
      tor-browser
      typst
      unzip
      valgrind
      vcftools
      vlc
      vscode-fhs
      waydroid
      wget
      xclip
      xz
      yazi
      yt-dlp
      ytdownloader
      zed-editor
      zellij
      zig
      zlib
      zlib.dev
      zoom-us
      zotero
    ];

    programs.atuin = {
      enable = true;
      enableFishIntegration = true;
    };

    nixpkgs.config.permittedInsecurePackages = [
      "electron-27.3.11"
    ];
    # this should enable zsh as the default shell
    
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    home.stateVersion = "24.11";
  };

  programs.fish.enable = true;
  # this should enable zsh as the default shell
  users.users.rijan.shell = pkgs.fish;
  # this shoule make zsh the default shell
  users.users.rijan.useDefaultShell = true;


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

  system.stateVersion = "24.11";
}
