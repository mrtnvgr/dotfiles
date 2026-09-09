{ ... }: {
  nix = {
    settings = {
      # Enable flakes
      experimental-features = ["nix-command" "flakes"];

      # Hard link store content
      auto-optimise-store = true;

      # Disable "uncommited changes" warning
      warn-dirty = false;
    };
  };

  # Faster rebuilds
  documentation = {
    doc.enable = false;
    dev.enable = false;
    info.enable = false;
  };
}
