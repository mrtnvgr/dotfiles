{ pkgs }:
{
  name,
  versionCommand,
}:
[
  (pkgs.lib.getExe (pkgs.writeShellApplication {
    name = "update-${name}";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      gnugrep
      gnused
      nix-update
    ];
    text = ''
      version="$(${versionCommand})" || version=""
      if [ -z "$version" ]; then
        echo "Could not determine the latest version for ${name}" >&2
        exit 1
      fi

      exec nix-update --flake --version="$version" "''${UPDATE_NIX_ATTR_PATH:-${name}}"
    '';
  }))
]
