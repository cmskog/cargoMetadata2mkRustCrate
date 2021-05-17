{ cargoPlatformToNix,
  nix,
  writeText }:
writeText
"cargoMetadata2mkRustCrateJQ"
''
#
# Start of jq script
#

def parsepkgid:
  capture("^(?<name>.*) (?<version>.*) \\((?<source>.*)\\)$");

def pkgid2recattr:
  gsub("[^a-zA-Z0-9]"; "-");

def print_root:
  "Root package";

def print_dep:
  "A dependency package";

def map_required_target:
  if . == null
  then "required"
  else .
  end;

def map_dependency($cfgmapping):
  map(
    "\"" + .name + "\"",
    ($cfgmapping[.pkgidrecattr] as $targetmap
    | $targetmap[(.target|map_required_target)]))
  | join("\n");

def print_package(print_type; $cfgmapping):
  "get_crateurl '\(.source)' '\(.name)' '\(.version)' '\($checksumlocation)'
cat <<__CREATE_NIX_CRATE__
  # Package with pkgid: \"\(.id)\"
  # \(print_type)
  \( .id | pkgid2recattr ) =
    mkRustCrate
      (augmentAttrs \"\( .name )\"
        rec {
          name = \"\( .name )\";
          version = \"\( .version )\";
          src = \(if .source == "registry+https://github.com/rust-lang/crates.io-index"
                  then "fetchFromCratesIo {
                                inherit name version cratelocation;
                                $(if [[ $CHECKSUM ]]
                                  then
                                    echo \"sha256 = \\\"$CHECKSUM\\\";\"
                                  fi)
                                };"
                  elif .path != null
            then "\( .path );"
            else "\"Unsupported source: \( .source )\";"
            end)
          dependencies = [
          \( .dependencies | map_dependency($cfgmapping) )
          ];
          buildDependencies = [
          \( .builddependencies |  map_dependency($cfgmapping) )
          ];
          devDependencies = [
          \( .devdependencies | map_dependency($cfgmapping) )
          ];
          features = [
          \( .features // [] | map("\"" + . + "\"") | join("\n") )
          ];
          noDefaultFeatures = true;
        });

__CREATE_NIX_CRATE__
";

def parse_cfg_expr:
  if . == null
  then
    "true"
  else
    "$(${cargoPlatformToNix}/bin/cargo-platform-to-nix '\(.)')"
  end;

def print_cfg_expr:
  "cat <<__CREATE_NIX_START_OF_A_CFG_EXPRESSION__
# CFG_EXPRESSION: \(.[0]), \(.[1]), \(.[2]), \(.[3])
  \(.[2]) =
    if \(.[3] | parse_cfg_expr)
    then
      \(.[1])
    else
      \"-\";
__CREATE_NIX_START_OF_A_CFG_EXPRESSION__
";

#
# Start of jq expression
#


.resolve.nodes # The info we need is in the ".resolve.nodes" tree

| (reduce (.[]) as $pkg
  ({};
  .[ $pkg | .id ] = (reduce ($pkg | .deps[]) as $dep ({}; .[ $dep | .pkg ] = ([ $dep | .dep_kinds[] | .target ] | unique)))
  )) as $depcfgs

| ($depcfgs
  | ((keys_unsorted - reduce (.[]) as $deps ([]; . += ($deps | keys_unsorted)))
    | reduce (.[]) as $rootpkg ({}; .[$rootpkg] = true))) as $rootpkgids

| ($depcfgs
  | reduce (path(.[] | .[] | .[])) as $cfg
    ([];
    . += ([ [
      ($cfg[0]),
      ($cfg[1] | pkgid2recattr),
      ("\($cfg[1])-from-\($cfg[0])-target-\($depcfgs | getpath($cfg) | map_required_target)" | pkgid2recattr),
      ($depcfgs | getpath($cfg)) ] ]))) as $cfgexprs

| ($cfgexprs| reduce(.[]) as $cfgexpr
  ({};
  . *=
  {
    ($cfgexpr[0]):
      {
        ($cfgexpr[1]):
          {
      (($cfgexpr[3]) | map_required_target)
      :
      ($cfgexpr[2])
    }
      }
  })) as $cfgmapping



| sort_by(.id)

| map_values(
  del(.dependencies)
  | . + { flatdeps: [ .deps[] | { pkg, name, pkgidrecattr: .pkg | pkgid2recattr } + .dep_kinds[] ] }
  | del(.deps)
  | . + { dependencies: .flatdeps | map(select(.kind == null)) }
  | . + { builddependencies: .flatdeps | map(select(.kind == "build")) }
  | . + { devdependencies: .flatdeps | map(select(.kind == "dev")) }
  | del(.flatdeps)
  | . + (.id | parsepkgid)
  | . + (.source | capture("^path\\+file\\://(?<path>.*)$") // { path: null }))


# First pass: Emit a heredoc-wrapped Nix expression.
# Heredoc-wrapped because we like to fill in sha256 sums with nix-prefetch-url
#
# Start of emitting the Nix expression
#

#
# START Shell functions
# Some shell functions that is used in the bash pass
#
| "set -o errexit -o nounset -o pipefail

get_crateurl()
{
  local source=\"$1\"
  local name=\"$2\"
  local version=\"$3\"
  local checksumlocation=\"$4\"
  local crateurl=
  local -n ref=CHECKSUM

  ref=

  if [[ $source != \"registry+https://github.com/rust-lang/crates.io-index\" ]]
  then
    return
  fi

  case $checksumlocation in
    remote)
      crateurl=\"https://crates.io/api/v1/crates/''${name}/''${version}/download#crate.tar.gz\"
      ;;

    local)
      local cratefile=~/.cargo/registry/cache/github.com-1ecc6299db9ec823/\"''${name}-''${version}.crate\"

      if [[ ! -e $cratefile ]]
      then
        echo \"Local crate file ''${cratefile} does not exist\" >&2
        return 1
      fi

      crateurl=\"file://''${cratefile}\"
      ;;

    none)
      return
      ;;

    *)
      echo \"Invalid checksumlocation: $checksumlocation\" >&2
      return 2
      ;;
  esac

  ref=$(${nix}/bin/nix-prefetch-url --type sha256 --unpack --name \"''${name}-''${version}.crate\" \"$crateurl\" 2>/dev/null)
}
",
#
# END Shell functions
# Some shell functions that is used in the bash pass
#

#
# START Nix expression start
#
# Check if $checksumlocation is none, i.e.
# we have no checksums. Then it is no meaning loading crates
# either remote or locally, since we have no checksums to check
# them against.
"cat <<__CREATE_NIX_START__
{
  pkgs ? import <nixpkgs> {},
  cratelocation ? \( if $checksumlocation == "none"
                     then
                       "\"localcargosrc\""
                     else
                       "null"
                     end)
}:
  with pkgs;
__CREATE_NIX_START__",
#
# END Nix expression start
#

#
# Start of dependencies: Start a "let" expression
#
"cat <<__CREATE_NIX_START_OF_DEPENDENCIES__

# START OF DEPENDENCIES
let
  _cfg = (import rustcNixCfg);
  _target = _cfg.target_arch
            + \"-\"
            + _cfg.target_vendor
            + \"-\"
            + _cfg.target_os
            + (if _cfg.target_env == \"\"
               then
                 \"\"
               else
                 (\"-\"
                  + _cfg.target_env));

  augmentAttrs = (cratename:
                   attrs:
                     (attrs
                       //
                       (
                         (lib.attrByPath [ cratename ] (attrs: {}) defaultCrateOverrides)
                         attrs
                       )
                     )
                  );

__CREATE_NIX_START_OF_DEPENDENCIES__",

"cat <<__CREATE_NIX_START_OF_CFG_EXPRESSIONS__
# START OF CFG_EXPRESSIONS

__CREATE_NIX_START_OF_CFG_EXPRESSIONS__",

  ($cfgexprs
    | .[]
    | print_cfg_expr),

"cat <<__CREATE_NIX_END_OF_CFG_EXPRESSIONS__

# END OF CFG_EXPRESSIONS
__CREATE_NIX_END_OF_CFG_EXPRESSIONS__",

#
# Enumerate dependencies: i.e all packages that is a dependency of some other package
#
  (map(select(.id | in($rootpkgids) | not))
    | .[]
    | print_package(print_dep; ($cfgmapping[.id]))),

#
# End of dependencies: wrap up the "let" expression with an "in"
#
"cat <<__CREATE_NIX_END_OF_DEPENDENCIES__
# END OF DEPENDENCIES
  in

__CREATE_NIX_END_OF_DEPENDENCIES__",

#
# Start of root packages: Just an attrset
#
"cat <<__CREATE_NIX_START_ROOT__
# START OF ROOT PACKAGES
{

__CREATE_NIX_START_ROOT__",

#
# Enumerate root packages: i.e. all packages that is NOT a dependency of any other
# package
#
  (map(select(.id | in($rootpkgids)))
    | .[]
    | print_package(print_root; ($cfgmapping[.id]))),

"cat <<__CREATE_NIX_END__
# END OF ROOT PACKAGES
}
__CREATE_NIX_END__"

#
# End of jq script
#
''
