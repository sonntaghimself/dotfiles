{
  description = "Zenful Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          # pkgs.alacritty
          pkgs.mkalias
          pkgs.neovim
          pkgs.wget
          pkgs.lazygit
          pkgs.fzf
          pkgs.gcc
          pkgs.ffmpeg
          pkgs.zoxide
          pkgs.texliveFull
          pkgs.eza
          # pkgs.oh-my-posh # Doesn't offer newest version. brew does.
          # pkgs.tmux # TODO: Retry and reconfigure
        ];

      homebrew = {
          enable = true;
          casks = [
            # "wezterm"
            # "kitty" # Nah for now, seems intersting though
            "alacritty"
            # "nikitabobko/tap/aerospace"
            # "r"
            "keymapp"
          ];
          brews = [
            "npm"
            "pkgconf"
            "pyenv"
            "pyenv-virtualenv"
            "oh-my-posh"
            # NOTE: The following package is needed to get R running.
            "gettext"
          ];
          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
        };

      fonts.packages = [
          (pkgs.nerdfonts.override { fonts = ["JetBrainsMono"]; })
        ];

      # NOTE: Doesn't work.
      # system.activationScripts.applications.text = let
      #   env = pkgs.buildEnv {
      #     name = "system-applications";
      #     paths = config.environment.systemPackages;
      #     pathsToLink = "/Applications";
      #   };
      # in
      #   pkgs.lib.mkForce ''
      #   # Set up applications.
      #   echo "setting up /Applications..." >&2
      #   rm -rf /Applications/Nix\ Apps
      #   mkdir -p /Applications/Nix\ Apps
      #   find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      #   while read src; do
      #     app_name=$(basename "$src")
      #     echo "copying $src" >&2
      #     ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      #   done
      #       '';

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
      configuration
      nix-homebrew.darwinModules.nix-homebrew{
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "sonntaghimself";

            # Automatically migrate existing Homebrew installations
            # autoMigrate = true;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mac".pkgs;
  };
}
