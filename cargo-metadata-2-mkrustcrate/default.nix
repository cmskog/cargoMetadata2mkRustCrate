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

CHECKSUM_LOCATION=remote
CHECKSUM_LOCATION_MISSING=
DEBUG=
DONT_USE_METADATA=
declare -a INVALIDOPTS=()
OUTPUT_DIRECTORY=.
OUTPUT_DIRECTORY_MISSING=
PRINT_HELP=

while getopts :c:dho:s ARGS
do
  case "$ARGS" in
    c)
      CHECKSUM_LOCATION="$OPTARG"
      ;;

    d)
      DEBUG=y
      ;;

    h)
      PRINT_HELP=y
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
        CHECKSUM_LOCATION_MISSING=1
      elif [[ $OPTARG == o ]]
      then
        OUTPUT_DIRECTORY_MISSING=1
      fi
      ;;

    *)
      INVALIDOPTS+=($OPTARG)
      ;;
  esac
done

shift $(($OPTIND - 1))

usage()
{
  local errmsg=''${1:-}
  local redir=''${errmsg:+">&2"}
  local exitval=''${2:-0}


  eval ${coreutils}/bin/cat ''${redir} <<- END
		''${errmsg:+''$errmsg

		}Usage: $(basename $0) [-c <checksumlocation>] [-h] [-o <directory>] [-s]

		  -c option: Point out the source for checksums for crates

		    where <checksumlocation> is either remote(default), local or none;

		    'remote' means use nix-prefetch-url to download the cargo crate
		    from crates.io, and fill in the sha256 checksum in the
		    fetchFromCratesIo expression. This is the most expensive operation,
		    but should also be the most authoritative value;

		    'local' means use the crate cache in the directory
		    .cargo/registry/cache/github.com-1ecc6299db9ec823 under the users
		    home directory to determine the checksum for the crate. Normally,
		    this should be up to date, since "cargo metadata" is input data for
		    this program;

		    'none' means do emit any sha256 checksums at all.

		  -h option: Print this info.

		  -o option: Set output directory, instead of using current directory.

		  -s option: Do not invoke "cargo metadata".

		    Normally "cargo metadata" is invoked, and it's output used to create
		    the nix expression. If this option is given, the "cargo metadata"
		    output is expected on stdin.
		END
  exit $exitval
}

if [[ $CHECKSUM_LOCATION_MISSING ]]
then
  usage "Checksum location missing for option 'c'" 1
elif [[ $OUTPUT_DIRECTORY_MISSING ]]
then
  usage "Output directory missing for option 'o'" 2
else
  case "$CHECKSUM_LOCATION" in
    local)
      ;;
    none)
      ;;
    remote)
      ;;


    *)
      usage "Invalid checksum location: '$CHECKSUM_LOCATION'" 3
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
  usage "Invalid option$([[ ''${#INVALIDOPTS[@]} -ge 2 ]] && echo s): ''${INVALIDOPTS[*]}" 5
fi

if [[ "$@" ]]
then
  usage "Extraneous arguments: $*" 6
fi

if [[ $PRINT_HELP ]]
then
  usage
fi

PROJECT_NAME="$(basename "$(pwd)")"
LOG_DATE="$(${coreutils}/bin/date)"
CARGO_METADATA_DEBUG="$OUTPUT_DIRECTORY/''${PROJECT_NAME}.''${CHECKSUM_LOCATION}.''${LOG_DATE}.json"
BASH_SCRIPT_DEBUG="$OUTPUT_DIRECTORY/''${PROJECT_NAME}.''${CHECKSUM_LOCATION}.''${LOG_DATE}.sh"
NIX_EXPRESSION="$OUTPUT_DIRECTORY/''${PROJECT_NAME}.''${CHECKSUM_LOCATION}.''${LOG_DATE}.nix"

process_json()
{
  local cmd="${jq}/bin/jq \
               -f ${cargoMetadata2mkRustCrateJQ} \
               -r \
               --arg checksumlocation '$CHECKSUM_LOCATION'"

  if [[ $DEBUG ]]
  then
    cmd+=" | ${coreutils}/bin/tee '$BASH_SCRIPT_DEBUG'"
  fi

  cmd+=" | ${bash}/bin/bash > '$NIX_EXPRESSION'"

  eval "$cmd"
}

if [[ $DONT_USE_METADATA ]]
then
  process_json
else
  CMD="${cargo}/bin/cargo metadata --format-version 1"

  if [[ $DEBUG ]]
  then
    CMD+=" | ${coreutils}/bin/tee '$CARGO_METADATA_DEBUG'"
  fi

  CMD+=" | process_json"

  eval "$CMD"
fi
''
