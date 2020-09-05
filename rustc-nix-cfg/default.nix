{ gawk, rustc, stdenv }:
stdenv.mkDerivation {
	name = "rustc-nix-cfg";
	builder = ./builder.sh;
	rustcPrintCfgToNix = ./rustc-print-cfg-to-nix.awk;
	gawk = "${gawk}/bin/gawk";
	rustc = "${rustc}/bin/rustc";
}
