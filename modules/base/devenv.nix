{ ... }:
{
 tasks = {
    "format:nix".exec = "treefmt -f nixfmt";
  };

  treefmt = {
    enable = true;
    config.programs = {
      nixfmt.enable = true;
    };
  };

  git-hooks.hooks = {
    treefmt.enable = true;
  };
}
