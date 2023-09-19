{
  description = "nut";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nut.url = "github:blawar/nut";

  outputs = { self, nixpkgs, flake-utils, nut }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python-pkgs = (ps:
          with ps; [
            asn1
            beautifulsoup4
            certifi
            colorama
            filelock
            Flask
            future
            google-api-python-client
            google-auth-oauthlib
            humanize
            markupsafe
            Pillow
            pycryptodome
            pycryptoplus
            pycurl
            pyopenssl
            pyqt5
            pyusb
            qt-range-slider
            requests
            tqdm
            Unidecode
            urllib3
            watchdog
            zstandard
          ]);
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            curl
            libusb
            (python39.withPackages python-pkgs)
          ];
        };
      });
}
