(self: super:
	{
		rustcNixCfg = (super.callPackage
				./rustc-nix-cfg
				{});

		cargoPlatformToNix = (super.callPackage
			./cargo-platform-to-nix
			{});

		cargoMetadata2mkRustcrateJQ = (super.callPackage
			./cargo-metadata-2-mkrustcrate-jq
			{});

		cargoMetadata2mkRustcrate = (super.callPackage
			./cargo-metadata-2-mkrustcrate
			{});
	}
)
