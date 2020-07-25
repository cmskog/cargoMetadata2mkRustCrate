# cargoMetadata2mkRustCrate

## Description
jq and shell script for converting output from a "cargo metadata" invocation to a Nix script for building with the mkRustCrate system.
For now, it is a crude two pass jq output into shell script implementation.

## Example run
1. `$ cd some-dir-with-a-crate`
2. `$ cargo metadata --format-version 1 | bash cargoMetadata2mkRustCrate > ../some-build-directory/some-dir-with-a-crate.nix.sh`
    * `--format-version 1` stops whining about compatibility problems
3. `$ cd ../some-build-directory`
    * Do not run the actual nix-build process in the same directory as the crate
4. `$ bash ./some-dir-with-a-crate.nix.sh > some-dir-with-a-crate.nix`
5. `$ nix-build some-dir-with-a-crate.nix`

## Implementation
The first pass creates a shell script that when run, downloads with `nix-prefetch-url`(into the Nix store) and fills in the sha256sums for the dependent crates from crates.io in the Nix expression.
The end result is a Nix expression that enumerates all "root crates" and their dependencies, and all the needed features set on all crates.
This can then be used build all the crates and dependent crates with `nix-build`.

## Deficiencies
For simple cases, that is.

Currently, no issues dealing with platform specific builds are handled(those under `[target.'cfg(windows)'.dependencies]` headings in the Cargo.toml).

In addition, in order to make the resultant Nix expression assume as little as possible about the packages given to the expression, it starts with the usual
`{ pkgs ? import <nixpkgs> {} }:`.
However, the needed packages is not in nixpkgs yet, so you have to prepare an overlay for `nix-build`.
E.g. to use the rust in nixpkgs save an overlay in some file(overlay.nix):
```
import <nixpkgs> {
	overlays = [

	(import (builtins.fetchTarball https://github.com/cmskog/mkRustCrate/archive/master.tar.gz))

      ];
}
```
Then run `nix-build`:

`nix-build some-dir-with-a-crate.nix --arg pkgs 'import ./overlay.nix'`

If you want be fancy and run the expression against the Rust nightly at some specific date, you can use the very cool "rust-overlay.nix"
from the "nixpkgs-mozilla" repository.

E.g. you absolutely want to use the nightly of 2020-04-22:

```
import <nixpkgs> {
	overlays = [

	(import
		(builtins.fetchTarball
			https://github.com/mozilla/nixpkgs-mozilla/archive/efda5b357451dbb0431f983cca679ae3cd9b9829.tar.gz
			+ "/rust-overlay.nix"
		)
	)

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

	(import (builtins.fetchTarball https://github.com/cmskog/mkRustCrate/archive/master.tar.gz))

	];
}
```
