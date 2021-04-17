(self: super:
	{
		rustcNixCfg = (super.callPackage
				./rustc-nix-cfg
				{});

		cargoPlatformToNix = (super.callPackage
			./cargo-platform-to-nix
			{});

		cargoMetadata2mkRustCrateJQ = (super.callPackage
			./cargo-metadata-2-mkrustcrate-jq
			{});

		cargoMetadata2mkRustCrate = (super.callPackage
			./cargo-metadata-2-mkrustcrate
			{});
	}
)
