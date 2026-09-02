{ pkgs, ... }:
{
  env.PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright.browsers}";
  env.PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = true;

  packages = [
    pkgs.playwright-driver
  ];

  languages = {
    javascript = {
      enable = true;
      npm = {
        enable = true;
        install.enable = true;
      };
    };
    typescript = {
      enable = true;
    };
  };

  tasks = {
    "test:ui".exec = ''
      echo 'Running UI tests...'
      playwright test
    '';
    "test:api".exec = "echo 'API testing not set up in this repository.'";
    "test:perf".exec = "echo 'Performance testing not set up in this repository.'";

    "format:github-actions".exec = "treefmt -f actionlint";
    "format:prettier".exec = "treefmt -f prettier";

    "lint:eslint".exec = "eslint .";
  };

  treefmt.config.programs = {
    actionlint.enable = true;
    prettier.enable = true;
  };

  git-hooks.hooks.eslint = {
    enable = true;
    settings.binPath = "./node_modules/.bin/eslint";
    settings.extensions = "\\.(js|mjs|cjs|ts|mts|cts|json|jsonc|md)$";
  };

  enterShell = ''
    playwrightNpmVersion=$(node -p "require('@playwright/test/package.json').version" 2>/dev/null)
    nixPlaywrightBaseVersion=$(echo "${pkgs.playwright.version}" | cut -d. -f1,2)
    npmPlaywrightBaseVersion=$(echo "$playwrightNpmVersion" | cut -d. -f1,2)

    echo "Playwright nix version: ${pkgs.playwright.version}"
    echo "Playwright npm version: $playwrightNpmVersion"

    if [ "$nixPlaywrightBaseVersion" != "$npmPlaywrightBaseVersion" ]; then
        echo "❌ Playwright versions (major, minor) in nix ($nixPlaywrightBaseVersion in devenv.yaml) and npm ($npmPlaywrightBaseVersion in package.json) are not the same! Please adapt the configuration."
    else
        echo "✅ Playwright versions in nix and npm are the same"
    fi

    echo
    env | grep ^PLAYWRIGHT
  '';
}
