{ pkgs, inputs, ... }:
{
  imports = [ inputs.nixcord.homeManagerModules.nixcord ];

  programs.nixcord = {
    enable = true;
    discord.enable = false;

    # https://github.com/Vencord/Vesktop/pull/517
    vesktop = {
      enable = true;

      package = (
        pkgs.vesktop.overrideAttrs (prev: {
          src = pkgs.fetchFromGitHub {
            owner = "PolisanTheEasyNick";
            repo = "Vesktop";
            rev = "60d0f2c3e37405aab115f2dff84163587ed877af";
            hash = "sha256-6ld0o+k8rSF1O0VRWuYQzEajswn5CO/uM9/PtsEkC6M=";
          };

          pnpmDeps = (
            prev.pnpmDeps.overrideAttrs (_: {
              outputHash = "sha256-Wtj/XKfunoWSHGyS54/6CyUVKMWos3j4Rgf7te1JBnY=";
            })
          );

          # https://github.com/Vencord/Vesktop/issues/220
          patches = (prev.patches or [ ]) ++ [ ./readonlyFix.patch ];
        })
      );
    };

    config = {
      useQuickCss = true;
      plugins = {
        betterGifAltText.enable = true;
        callTimer.enable = true;
        fakeNitro.enable = true;
        fakeNitro.useHyperLinks = false;
        favoriteEmojiFirst.enable = true;
        fixSpotifyEmbeds.enable = true;
        fixYoutubeEmbeds.enable = true;
        youtubeAdblock.enable = true;
        forceOwnerCrown.enable = true;
        friendsSince.enable = true;
        memberCount.enable = true;
        openInApp.enable = true;
        webScreenShareFixes.enable = true;
      };
    };

    extraConfig = {
      notifications.useNative = "always";
    };

    quickCss = ''
      @import url('https://refact0r.github.io/midnight-discord/midnight.css');

      :root {
        --font: 'ggsans';
        --text-2: hsl(220, 30%, 80%); /* headings and important text */
        --text-3: hsl(220, 15%, 80%); /* normal text */
        --text-4: hsl(220, 15%, 50%); /* icon buttons and channels */
        --text-5: hsl(220, 15%, 25%); /* muted channels/chats and timestamps */
      }
    '';
  };

  xdg.configFile = {
    # Use custom tray icon
    "vesktop/TrayIcons/icon_custom.png".source = ./tray-icon.png;

    # https://github.com/KaylorBen/nixcord/issues/18
    "vesktop/settings.json".text = builtins.toJSON {
      minimizeToTray = "on";
      discordBranch = "canary";
      arRPC = "on";
      splashColor = "rgb(196, 201, 212)";
      splashBackground = "rgb(22, 24, 29)";
      splashTheming = true;
      checkUpdates = false;
      disableMinSize = true;
      tray = true;
      hardwareAcceleration = true;
      trayMainOverride = true;
      trayColorType = "custom";
      trayAutoFill = "auto";
      trayColor = "c02828";
      firstLaunch = false;
    };
  };
}
