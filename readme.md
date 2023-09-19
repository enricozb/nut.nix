# nut.nix

A nix flake for [blawar/nut][1].

## Configuration
The `conf/` directory that nut expects is `~/.config/nut/`.

## Usage
If you have a file like `nut.nix`:
```nix
{ fetchFromGitHub, callPackage }:

let
  src = fetchFromGitHub {
    owner = "enricozb";
    repo = "nut.nix";
    rev = "ce18c3e82960faba0a417e2c5101b14f83220d9c";
    sha256 = "1r5pjyci6k4xq9fmb1m4m4mvc72p1jk5ilajl4b2y7w0pff6jlmx";
  };

in (import "${src}/default.nix")
```
You can use it like
```nix
{
  environment.systemPackages = [ (pkgs.callPackage ./nut.nix { } )];
}
```

[1]: https://github.com/blawar/nut
