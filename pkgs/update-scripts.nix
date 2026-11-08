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
      version=""
      for attempt in 1 2 3; do
        version="$(${versionCommand})" || version=""
        if [ -n "$version" ]; then
          break
        fi

        echo "Could not determine the latest version for ${name} (attempt $attempt/3)" >&2
        sleep $((attempt * 10))
      done

      if [ -z "$version" ]; then
        echo "Could not determine the latest version for ${name}" >&2
        exit 1
      fi

      exec nix-update --flake --version="$version" "''${UPDATE_NIX_ATTR_PATH:-${name}}"
    '';
  }))
]
