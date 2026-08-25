# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.kernelModules = [ "vmwgfx" ];
  boot.kernelModules = [ "vmwgfx" ];
  boot.extraModprobeConfig = ''
    # VMware's virtual HDA controller can lose MSI interrupts and lock up
    # while ALSA resets a stream, stalling graphics and audio together.
    options snd_hda_intel enable_msi=0 bdl_pos_adj=64
  '';

  networking.hostName = "meru"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  # Set your time zone.
  time.timeZone = "America/New_York";

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."kramer" = {
    isNormalUser = true;
    description = "Kramer Hampton";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
  system.stateVersion = "26.05"; # Did you read the comment?

  virtualisation.vmware.guest = {
    enable = true;
    headless = false;
  };

  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      mesa
    ];
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;

    package = pkgs.hyprland.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ./vmwgfx-hypr.patch
      ];
    });
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
    command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd 'uwsm start hyprland-uwsm.desktop'";
    user = "greeter";
    };
  };

  security.polkit.enable = true;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs._1password.enable = true;

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "kramer" ];
  };

  programs.nix-ld.enable = true;
  services.flatpak.enable = true;

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "18";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MESA_LOADER_DRIVER_OVERRIDE = "vmwgfx";
    SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
  };

  environment.systemPackages = with pkgs; [
    ast-grep
    bibata-cursors
    btop
    clang
    clang-tools
    cmake
    fd
    firefox
    fzf
    ghostty
    git
    gnumake
    gtk4
    hyprlauncher
    hyprpaper
    hyprpolkitagent
    kdePackages.dolphin
    kdePackages.qt5compat
    kdePackages.qtimageformats
    kdePackages.qtmultimedia
    kdePackages.qtsvg
    kitty
    lazydocker
    lazygit
    lua5_1
    luarocks
    mako
    mesa-demos
    neovim
    pciutils
    pkg-config
    quickshell
    ripgrep
    stow
    tree-sitter
    unzip
    uwsm
    vulkan-tools
    waybar
    wget
    wl-clipboard
    wofi
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
