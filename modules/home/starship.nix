{
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      add_newline = true;
      right_format = "$time";
      continuation_prompt = "▶▶ ";

      battery.disabled = true;
      git_metrics.disabled = false;
      time.disabled = false;

      nix_shell = {
        format = "[󱄅 $name](#74b2ff) ";
        heuristic = true;
      };
      directory = {
        read_only = " ";
        repo_root_style = "bold underline italic blue";
      };
    };
  };
}
