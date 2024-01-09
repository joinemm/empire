{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      battery.disabled = true;
      git_metrics.disabled = false;
      directory.repo_root_style = "bold underline italic blue";
    };
  };
}
