# cargoMetadata2mkRustCrate

## Description
A system for converting output from a "cargo metadata" invocation(on stdin) to a Nix script(on stdout) for building a crate with the mkRustCrate system.

## Example run
1. `$ cd some-dir-with-a-crate`
2. `$ cargo metadata --format-version 1 | cargoMetadata2mkRustCrate > default.nix`
    * `--format-version 1` stops whining about compatibility problems
3. `$ cd ..`
    * Do not run the actual nix-build process in the same directory as the crate you are hacking on. Any changes to the crate directory(e.g. result* files from a nix-build) will make the crate eligible for rebuild).
4. `$ nix-build some-dir-with-a-crate`
    * At least in theory(the packages is not in nixpkgs, so you will need prepare an overlay, and use this with a `--arg` argument, as described later).

## Implementation
The first pass(jq) creates a shell script that when run(second pass),
downloads with `nix-prefetch-url`(into the Nix store) and fills in the
sha256sums for the dependent crates from crates.io in the Nix expression.
The end result is a Nix expression that enumerates all "root crates" and
their dependencies, and all the needed features set on all crates. This can
then be used build all the crates and dependent crates with `nix-build`.

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

	# Import the Rust overlay from Mozilla's nixpkgs-mozilla repository
	(import
		(builtins.fetchTarball
			https://github.com/mozilla/nixpkgs-mozilla/archive/efda5b357451dbb0431f983cca679ae3cd9b9829.tar.gz
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

	];
}
```

You might also need to add buildInputs to some crates that references external
libraries(e.g. the `openssl-sys` crate needs a line
`buildInputs = [ openssl_1_0_2 pkgconfig ];` line added to its mkRustCrate
definition).
