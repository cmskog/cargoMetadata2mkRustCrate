# cargoMetadata2mkRustCrate

## Description
A program for converting output from a "cargo metadata" invocation(run by
cargoMetadata2mkRustCrate itself, or on stdin) to a Nix script(on stdout)
for building a crate with the mkRustCrate derivation.

## Example session
1. `$ mkdir some-dir-with-a-crate.build`
1. `$ cd some-dir-with-a-crate`
1. `$ cargoMetadata2mkRustCrate -c none -o ../some-dir-with-a-crate.build`
    * `-c none` means do not create checksums. Lightweight, but only for development.
    * You can also use `-c local` to determine sha256 checksums from your local cargo crate cache.
1. `$ cd ../some-dir-with-a-crate.build`
    * Do not run the actual nix-build process in the same directory as the crate you are hacking on. Any changes to the crate directory(e.g. result* files from a nix-build) will make the crate eligible for rebuild).
1. `$ nix-build some-dir-with-a-crate.none.<somedate>.nix`
    * At least in theory(the packages is not in nixpkgs, so you will need prepare an overlay, and use this with a `--arg` argument, as described later).
    * The `some-dir-with-a-crate.none.<somedate>.nix` is created by `cargoMetadata2mkRustCrate` above.
1. Hack away until done...
    * If you change `Cargo.toml`, you will have to rerun `cargoMetadata2mkRustCrate` like above.
1. `$ cd ../some-dir-with-a-crate`
1. `$ cargoMetadata2mkRustCrate`
    * Fetch the crate source with `nix-prefetch-url` from https://crates.io/ and fill in the sha256 sums in the Nix expression. Most of the time this will not deviate from the local checksums, but it is certainly good to check.

## Implementation
`cargo metadata` is first run, and the resulting json is piped through jq.
The `jq` pass creates a shell script that when run(second pass),
downloads with `nix-prefetch-url`(into the Nix store) and fills in the
sha256sums for the dependent crates from crates.io in the Nix expression.
The end result is a Nix expression that enumerates all "root crates"(crates
that is not a dependency for any crate in the dependency tree) and their
dependencies, and all the needed features set on all crates. This can then
be used build all the crates and dependent crates with `nix-build`.

## Deficiencies
In order to make the resultant Nix expression assume as little as possible about the packages given to the expression, it starts with the usual
`{ pkgs ? import <nixpkgs> {} }:`.
However, the needed packages is not in nixpkgs yet, so you have to prepare an overlay for `nix-build`.
To use the rust in nixpkgs, save an overlay in some file(e.g. `overlay.nix`):
```
import <nixpkgs> {
  overlays = [

    # mkRustCrate and friends
    (import (builtins.fetchTarball https://github.com/cmskog/mkRustCrate/archive/master.tar.gz))

    # cargoMetadata2mkRustCrate and friends(in particular rustcNixCfg that is referenced in Nix expressions created by cargoMetadata2mkRustCrate)
    (import (builtins.fetchTarball https://github.com/cmskog/cargoMetadata2mkRustCrate/archive/master.tar.gz))

    # Override the overrides in defaultCrateOverrides(used by buildRustCrate in in nixpkgs)
    (import
      ./defaultCrateOverridesOverrides.nix)
  ];
}
```
The last import above is used if you need to change some dependencies outside of
rust that is not covered by defaultCrateOverrides set as used by buildRustCrate.
As in the example below; the `cairo-sys-rs` crate need the external library to build.
```
(self: super:

  {

    defaultCrateOverrides =
      super.defaultCrateOverrides
        //
        {

            cairo-sys-rs =
              attrs: {
                nativeBuildInputs = [ self.pkg-config ];
                buildInputs = [ self.cairo.dev ];
              };

        };
  }

)

```
Then run `nix-build`:

`nix-build some-dir-with-a-crate --arg pkgs 'import ./overlay.nix'`

If you want be fancy and run the expression against the Rust nightly at some specific date, you can use the very cool "rust-overlay.nix"
from the "nixpkgs-mozilla" repository.

E.g. you absolutely want to use the nightly of 2020-04-22:

```
import <nixpkgs> {
  overlays = [

    # Import the Rust overlay from Mozilla's nixpkgs-mozilla repository
    (import
      (builtins.fetchTarball
        https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz
        + "/rust-overlay.nix"
      )
    )

    # Pick the Rust version you are interested in
    (self: super:
      let
        rustChannel = super.rustChannelOf {
          date = "2020-04-22";
          channel = "nightly";
        };
      in
        {
          cargo = rustChannel.rust;
          rustc = rustChannel.rust;

          # We should be able to just "inherit (rustChannel) rustc" here
          #inherit (rustChannel) cargo rustc;
        }
    )

    # mkRustCrate and friends
    (import (builtins.fetchTarball https://github.com/cmskog/mkRustCrate/archive/master.tar.gz))

    # cargoMetadata2mkRustCrate and friends(in particular rustcNixCfg that is referenced in Nix expressions created by cargoMetadata2mkRustCrate)
    (import (builtins.fetchTarball https://github.com/cmskog/cargoMetadata2mkRustCrate/archive/master.tar.gz))

    # Override the overrides in defaultCrateOverrides(used by buildRustCrate in in nixpkgs)
    (import
      ./defaultCrateOverridesOverrides.nix)

  ];
}
```
