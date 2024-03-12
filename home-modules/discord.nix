{pkgs, ...}: {
  home.packages = [pkgs.vesktop];

  xdg.configFile = {
    "Vencord/settings/quickCss.css".text = ''
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
}
