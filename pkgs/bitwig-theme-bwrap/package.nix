{
  writeShellApplication,
  coreutils,
  util-linux,
  bubblewrap,
  bitwig-theme-editor,
}:
writeShellApplication {
  name = "bwrap";
  runtimeInputs = [
    coreutils
    util-linux
  ];

  text = ''
    state="''${XDG_DATA_HOME:-$HOME/.local/share}/bitwig-theme-editor"
    cfg="''${XDG_CONFIG_HOME:-$HOME/.config}/bitwig-theme-editor"
    jar="$state/bitwig.jar"
    stamp="$state/source"
    log="$state/patch.log"

    args=("$@")
    dest=""
    idx=""

    # The Bitwig launcher ends its bwrap command with .../libexec/bitwig-studio.
    # Derive the JAR path from it instead of hard-coding the store path.
    for i in "''${!args[@]}"; do
      case "''${args[i]}" in
        */libexec/bitwig-studio)
          dest="''${args[i]%/bitwig-studio}/bin/bitwig.jar"
          idx=$i
          break
          ;;
      esac
    done

    if [[ -z "$dest" || ! -f "$dest" ]]; then
      exec ${bubblewrap}/bin/bwrap "$@"
    fi

    if ! mkdir -p "$state"; then
      exec ${bubblewrap}/bin/bwrap "$@"
    fi

    key="$dest|${bitwig-theme-editor}|$cfg"

    if [[ ! -f "$jar" || "$(cat "$stamp" 2>/dev/null || true)" != "$key" ]]; then
      # Keep the lock in a subshell so fd 9 is not inherited by bwrap.
      if ! (
        exec 9>"$state/lock"
        flock 9

        if [[ ! -f "$jar" || "$(cat "$stamp" 2>/dev/null || true)" != "$key" ]]; then
          tmp="$(mktemp "$state/bitwig.jar.XXXXXX")"
          cp "$dest" "$tmp"
          chmod u+w "$tmp"

          if ! ${bitwig-theme-editor}/bin/bitwig-theme-editor \
            --global-theme --config-dir "$cfg" "$tmp" >"$log" 2>&1; then
            echo "bitwig-theme-editor: patch failed; launching unpatched Bitwig (see $log)" >&2
            rm -f "$tmp" "$tmp.bak"
            exit 1
          fi

          rm -f "$tmp.bak"
          mv "$tmp" "$jar"
          printf '%s\n' "$key" > "$stamp"
        fi
      ); then
        exec ${bubblewrap}/bin/bwrap "$@"
      fi
    fi

    # Point the editor GUI at the writable cache instead of making the user
    # select a jar (and potentially choose the read-only store jar) on first run.
    if [[ -f "$jar" && ! -f "$cfg/bte_config.txt" ]]; then
      mkdir -p "$cfg" 2>/dev/null || true
      printf '# Bitwig Theme Editor configuration file\nbitwig_path=%s\nglobal_theme=true\n' "$jar" \
        > "$cfg/bte_config.txt" 2>/dev/null || true
    fi

    # Insert the bind after the launcher's "--bind / /" and before the
    # command; a bind before it would be hidden by the root mount.
    exec ${bubblewrap}/bin/bwrap \
      "''${args[@]:0:idx}" --bind "$jar" "$dest" "''${args[@]:idx}"
  '';
}
