{ bash,
  cargo,
  cargoMetadata2mkRustCrateJQ,
  coreutils,
  jq,
  writeShellScriptBin }:
writeShellScriptBin
"cargoMetadata2mkRustCrate"
''
set \
-o errexit \
-o nounset \
-o pipefail

CRATE_LOCATION=remote
CRATE_LOCATION_MISSING=
DONT_USE_METADATA=
declare -a INVALIDOPTS=()
OUTPUT_DIRECTORY=.
OUTPUT_DIRECTORY_MISSING=

while getopts :c:o:s ARGS
do
  case "$ARGS" in
    c)
      CRATE_LOCATION="$OPTARG"
      ;;

    o)
      OUTPUT_DIRECTORY="$OPTARG"
      ;;

    s)
      DONT_USE_METADATA=y
      ;;

    :)
    if [[ $OPTARG == c ]]
    then
      CRATE_LOCATION_MISSING=1
    elif [[ $OPTARG == o ]]
    then
      OUTPUT_DIRECTORY_MISSING=1
    fi
      ;;

    *)
      INVALIDOPTS[''${#INVALIDOPTS[@]}]=$OPTARG
      ;;
  esac
done

shift $(($OPTIND - 1))

usage()
{
  ${coreutils}/bin/cat >&2 <<- END
		$1

		Usage: $0 [-c <cratelocation>] [-o <directory>] [-s]

		-c option: Point out crate source

		where <cratelocation> is either remote(default), local or none;

		'remote' means use nix-prefetch-url to download the cargo crate
		from crates.io, and fill in the sha256 checksum in the
		fetchFromCratesIo expression;

		'local' means use the crate cache in the directory
		.cargo/registry/cache/github.com-1ecc6299db9ec823 under the users
		home directory. Normally, this should be the case if the
		"cargo metadata" output is uptodate regarding the tree of crates
		in use for the crate.

		'none' means do emit any sha256 checksums at all.

		-o option: Set output directory, instead of using current directory.

		-s option: Do not invoke "cargo metadata".

		Normally "cargo metadata" is invoked, and it's output used to create
		the nix expression. If this option is given, the "cargo metadata"
		output is expected on stdin.
		END
  exit $2
}

if [[ $CRATE_LOCATION_MISSING ]]
then
  usage "Crate location missing for option 'c'" 1
elif [[ $OUTPUT_DIRECTORY_MISSING ]]
then
  usage "Output directory missing for option 'o'" 2
else
  case "$CRATE_LOCATION" in
    local)
      ;;

    none)
      ;;

    remote)
      ;;

    *)
      usage "Invalid cratelocation: '$CRATE_LOCATION'" 3
      ;;
  esac

  if [[ ! ( -d $OUTPUT_DIRECTORY && -w $OUTPUT_DIRECTORY ) ]]
  then
    usage "Output directory '$OUTPUT_DIRECTORY' does not exist or is not writable" 4
  fi
fi

if [[ "''${INVALIDOPTS[@]}" ]]
then
  IFS=,
  usage "Invalid options: ''${INVALIDOPTS[*]}" 5
fi

if [[ "$@" ]]
then
  usage "Extraneous arguments: $*" 6
fi

PROJECT_NAME="$(basename "$(pwd)")"
LOG_DATE="$(${coreutils}/bin/date)"
CARGO_METADATA_FILE="$OUTPUT_DIRECTORY/''${PROJECT_NAME}.''${LOG_DATE}.json"
BASH_BEFORE_CHKSUMS="$OUTPUT_DIRECTORY/''${PROJECT_NAME}.''${LOG_DATE}.sh"
NIX_EXPRESSION="$OUTPUT_DIRECTORY/''${PROJECT_NAME}.''${LOG_DATE}.nix"

process_json()
{
  ${jq}/bin/jq \
    -f ${cargoMetadata2mkRustCrateJQ} \
    -r \
    --arg cratelocation "$CRATE_LOCATION" \
    \
  | ${coreutils}/bin/tee "$BASH_BEFORE_CHKSUMS" \
    \
  | ${bash}/bin/bash > "$NIX_EXPRESSION"
}

if [[ $DONT_USE_METADATA ]]
then
  process_json
else
  ${cargo}/bin/cargo metadata --format-version 1 \
    \
  | ${coreutils}/bin/tee "$CARGO_METADATA_FILE" \
    \
  | process_json
fi
''
