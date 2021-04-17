{ bash, cargoMetadata2mkRustCrateJQ, jq, writeShellScriptBin }:
	writeShellScriptBin
		"cargoMetadata2mkRustCrate"
		''
		${jq}/bin/jq -r -f ${cargoMetadata2mkRustCrateJQ} | ${bash}/bin/bash
		''
