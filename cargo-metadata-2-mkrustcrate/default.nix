{ bash, cargoMetadata2mkRustcrateJQ, jq, writeShellScriptBin }:
	writeShellScriptBin
		"cargoMetadata2mkRustCrate"
		''
		${jq}/bin/jq -r -f ${cargoMetadata2mkRustcrateJQ} | ${bash}/bin/bash
		''
