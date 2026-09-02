{
  description = "b.ignited development environments and project templates";

  outputs = { self, ... }: {
    templates = {
      "typescript/playwright" = {
        path = ./templates/typescript/playwright;
      };
    };
  };
}
