{
  lib,
  fetchFromGitHub,
  maven,
  jdk21,
  pkgs,
}:
maven.buildMavenPackage rec {
  pname = "drivenbymoss";
  version = "26.6.5";

  src = fetchFromGitHub {
    owner = "git-moss";
    repo = "DrivenByMoss";
    tag = version;
    hash = "sha256-Zpqr9JYfutiR1yxCgRKlIOaqrm4UQpmOn+STs0SgXyY=";
  };

  # Local changes from github.com/mrtnvgr/drivenbymoss, rebased onto the
  # upstream release tag. See ./patches/README.md for details.
  patches = [
    ./patches/0001-launchpad-scene-buttons-track-navigation.patch
    ./patches/0002-drum-view-selected-pad-highlight-toggle.patch
  ];

  mvnJdk = jdk21;
  doCheck = false;

  mvnHash = "sha256-azOYleBzlK5nTpWQKmfULHbpjYf/tb9o3I7Cl6qi6eE=";

  installPhase = ''
    runHook preInstall
    # The shaded JAR is the extension. Keep the output as a single file since
    # the Bitwig module links pkgs.drivenbymoss directly as a home file.
    install -Dm644 "target/DrivenByMoss-${version}.jar" $out
    runHook postInstall
  '';

  passthru.updateScript = import ../update-scripts.nix { inherit pkgs; } {
    name = "drivenbymoss";
    versionCommand = ''
      curl -fsSL --user-agent 'Mozilla/5.0' https://www.mossgrabers.de/Software/Bitwig/ \
        | grep -oE 'DrivenByMoss-[0-9.]+-Bitwig\.zip' \
        | sed -E 's/^DrivenByMoss-//; s/-Bitwig\.zip$//' \
        | sort -V \
        | tail -n1
    '';
  };

  meta = {
    description = "Bitwig Studio extension for supported MIDI controllers";
    homepage = "https://www.mossgrabers.de/Software/Bitwig/Bitwig.html";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.all;
  };
}
