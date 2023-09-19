{
  description = "nut";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };
  inputs.nut = {
    url = "github:blawar/nut";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, nut, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = (pkgs.python311.withPackages python-pkgs);
        nut-bin = pkgs.writeShellScriptBin "nut" ''
          export QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins"
          CONFIG_DIR="$HOME/.config/nut"

          mkdir -p "$CONFIG_DIR"
          cd "$CONFIG_DIR"

          ${python}/bin/python ${nut}/nut_gui.py
        '';
        python-pkgs = (ps:
          with ps; [
            asn1
            beautifulsoup4
            certifi
            colorama
            filelock
            flask
            future
            google-api-python-client
            google-auth-oauthlib
            humanize
            markupsafe
            pillow
            pycryptodome
            (buildPythonPackage rec {
              pname = "pycryptoplus";
              version = "0.0.1";
              src = fetchPypi {
                inherit pname version;
                sha256 = "sha256-BnBAuUgr1bj3jABJIjwsL+ogtOcnUe6CqelX+bQyypQ=";
              };
              propagatedBuildInputs = [ pkgs.python311Packages.pycryptodome ];
            })
            pycurl
            pyopenssl
            pyqt5
            pyusb
            (buildPythonPackage rec {
              pname = "qt-range-slider";
              version = "0.2.7";
              format = "pyproject";
              src = fetchPypi {
                inherit pname version;
                sha256 = "sha256-KcEWFAaxRy/aXdW05p1PRn1vqnAjFEsqCiPYgqVsNM8=";
              };
              propagatedBuildInputs = with pkgs.python311Packages; [
                pyqt6
                pyqt6-sip
              ];
            })
            requests
            tqdm
            unidecode
            urllib3
            watchdog
            zstandard
          ]);
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ curl libusb python nut-bin ];
        };
      });
}
