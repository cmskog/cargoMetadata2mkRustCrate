{ pkgs ? import <nixpkgs> {} }:
  with pkgs;

# START OF DEPENDENCIES
let
  _cfg = (import rustcNixCfg);
  _target = _cfg.target_arch
            + "-"
            + _cfg.target_vendor
            + "-"
            + _cfg.target_os
            + (if _cfg.target_env == ""
               then
                 ""
               else
                 ("-"
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

# START OF CFG_EXPRESSIONS

# CFG_EXPRESSION: serde 1.0.125 (registry+https://github.com/rust-lang/crates.io-index), serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index-, serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index--from-serde-1-0-125--registry-https---github-com-rust-lang-crates-io-index--target-required, null
  serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index--from-serde-1-0-125--registry-https---github-com-rust-lang-crates-io-index--target-required =
    if true
    then
      serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index-
    else
      "-";
# CFG_EXPRESSION: serde_derive 1.0.125 (registry+https://github.com/rust-lang/crates.io-index), proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index-, proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index--target-required, null
  proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index--target-required =
    if true
    then
      proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index-
    else
      "-";
# CFG_EXPRESSION: serde_derive 1.0.125 (registry+https://github.com/rust-lang/crates.io-index), quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index-, quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index--target-required, null
  quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index--target-required =
    if true
    then
      quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index-
    else
      "-";
# CFG_EXPRESSION: serde_derive 1.0.125 (registry+https://github.com/rust-lang/crates.io-index), syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index-, syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index--target-required, null
  syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index--target-required =
    if true
    then
      syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index-
    else
      "-";
# CFG_EXPRESSION: syn 1.0.72 (registry+https://github.com/rust-lang/crates.io-index), proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index-, proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index--target-required, null
  proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index--target-required =
    if true
    then
      proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index-
    else
      "-";
# CFG_EXPRESSION: syn 1.0.72 (registry+https://github.com/rust-lang/crates.io-index), quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index-, quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index--target-required, null
  quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index--target-required =
    if true
    then
      quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index-
    else
      "-";
# CFG_EXPRESSION: syn 1.0.72 (registry+https://github.com/rust-lang/crates.io-index), unicode-xid-0-2-2--registry-https---github-com-rust-lang-crates-io-index-, unicode-xid-0-2-2--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index--target-required, null
  unicode-xid-0-2-2--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index--target-required =
    if true
    then
      unicode-xid-0-2-2--registry-https---github-com-rust-lang-crates-io-index-
    else
      "-";
# CFG_EXPRESSION: quote 1.0.9 (registry+https://github.com/rust-lang/crates.io-index), proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index-, proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index--from-quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index--target-required, null
  proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index--from-quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index--target-required =
    if true
    then
      proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index-
    else
      "-";
# CFG_EXPRESSION: cargo-platform-to-nix 0.1.0 (path+file:///Dev/cargoMetadata2mkRustCrate/cargo-platform-to-nix), cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index-, cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index--from-cargo-platform-to-nix-0-1-0--path-file----Dev-cargoMetadata2mkRustCrate-cargo-platform-to-nix--target-required, null
  cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index--from-cargo-platform-to-nix-0-1-0--path-file----Dev-cargoMetadata2mkRustCrate-cargo-platform-to-nix--target-required =
    if true
    then
      cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index-
    else
      "-";
# CFG_EXPRESSION: cargo-platform 0.1.1 (registry+https://github.com/rust-lang/crates.io-index), serde-1-0-125--registry-https---github-com-rust-lang-crates-io-index-, serde-1-0-125--registry-https---github-com-rust-lang-crates-io-index--from-cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index--target-required, null
  serde-1-0-125--registry-https---github-com-rust-lang-crates-io-index--from-cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index--target-required =
    if true
    then
      serde-1-0-125--registry-https---github-com-rust-lang-crates-io-index-
    else
      "-";
# CFG_EXPRESSION: proc-macro2 1.0.26 (registry+https://github.com/rust-lang/crates.io-index), unicode-xid-0-2-2--registry-https---github-com-rust-lang-crates-io-index-, unicode-xid-0-2-2--registry-https---github-com-rust-lang-crates-io-index--from-proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index--target-required, null
  unicode-xid-0-2-2--registry-https---github-com-rust-lang-crates-io-index--from-proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index--target-required =
    if true
    then
      unicode-xid-0-2-2--registry-https---github-com-rust-lang-crates-io-index-
    else
      "-";

# END OF CFG_EXPRESSIONS
  # Package with pkgid: "cargo-platform 0.1.1 (registry+https://github.com/rust-lang/crates.io-index)"
  # A dependency package
  cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index- =
    mkRustCrate
      (augmentAttrs "cargo-platform"
        rec {
          name = "cargo-platform";
          version = "0.1.1";
          src = fetchFromCratesIo {
                                inherit name version;
                                sha256 = "0jjk6j17303sj2szjv7j8088mj8zvn0y3f9zjdpjm86nis18akrb";
                                };
          dependencies = [
          "serde"
serde-1-0-125--registry-https---github-com-rust-lang-crates-io-index--from-cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index--target-required
          ];
          buildDependencies = [
          
          ];
          devDependencies = [
          
          ];
          features = [
          
          ];
          noDefaultFeatures = true;
        });

  # Package with pkgid: "proc-macro2 1.0.26 (registry+https://github.com/rust-lang/crates.io-index)"
  # A dependency package
  proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index- =
    mkRustCrate
      (augmentAttrs "proc-macro2"
        rec {
          name = "proc-macro2";
          version = "1.0.26";
          src = fetchFromCratesIo {
                                inherit name version;
                                sha256 = "0ng6gzl7x91svz7sdh44nfpkajqbrgzkb15rcgd9lrvm431p12f5";
                                };
          dependencies = [
          "unicode_xid"
unicode-xid-0-2-2--registry-https---github-com-rust-lang-crates-io-index--from-proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index--target-required
          ];
          buildDependencies = [
          
          ];
          devDependencies = [
          
          ];
          features = [
          "default"
"proc-macro"
          ];
          noDefaultFeatures = true;
        });

  # Package with pkgid: "quote 1.0.9 (registry+https://github.com/rust-lang/crates.io-index)"
  # A dependency package
  quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index- =
    mkRustCrate
      (augmentAttrs "quote"
        rec {
          name = "quote";
          version = "1.0.9";
          src = fetchFromCratesIo {
                                inherit name version;
                                sha256 = "154whaxfsyx6fyricyjlp874n8hf8zyjrxhlb8pzbjnlmdwm0css";
                                };
          dependencies = [
          "proc_macro2"
proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index--from-quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index--target-required
          ];
          buildDependencies = [
          
          ];
          devDependencies = [
          
          ];
          features = [
          "default"
"proc-macro"
          ];
          noDefaultFeatures = true;
        });

  # Package with pkgid: "serde 1.0.125 (registry+https://github.com/rust-lang/crates.io-index)"
  # A dependency package
  serde-1-0-125--registry-https---github-com-rust-lang-crates-io-index- =
    mkRustCrate
      (augmentAttrs "serde"
        rec {
          name = "serde";
          version = "1.0.125";
          src = fetchFromCratesIo {
                                inherit name version;
                                sha256 = "09p7fq84gkn39wfrmqxjfh3gp3xq68l5l3b5kvphfa9j55z7rlrk";
                                };
          dependencies = [
          "serde_derive"
serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index--from-serde-1-0-125--registry-https---github-com-rust-lang-crates-io-index--target-required
          ];
          buildDependencies = [
          
          ];
          devDependencies = [
          
          ];
          features = [
          "default"
"derive"
"serde_derive"
"std"
          ];
          noDefaultFeatures = true;
        });

  # Package with pkgid: "serde_derive 1.0.125 (registry+https://github.com/rust-lang/crates.io-index)"
  # A dependency package
  serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index- =
    mkRustCrate
      (augmentAttrs "serde_derive"
        rec {
          name = "serde_derive";
          version = "1.0.125";
          src = fetchFromCratesIo {
                                inherit name version;
                                sha256 = "17lgz72m989zvvd7j30gl3h2xx35skb7640mhdjdwja8r9zjgdg1";
                                };
          dependencies = [
          "proc_macro2"
proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index--target-required
"quote"
quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index--target-required
"syn"
syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-125--registry-https---github-com-rust-lang-crates-io-index--target-required
          ];
          buildDependencies = [
          
          ];
          devDependencies = [
          
          ];
          features = [
          "default"
          ];
          noDefaultFeatures = true;
        });

  # Package with pkgid: "syn 1.0.72 (registry+https://github.com/rust-lang/crates.io-index)"
  # A dependency package
  syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index- =
    mkRustCrate
      (augmentAttrs "syn"
        rec {
          name = "syn";
          version = "1.0.72";
          src = fetchFromCratesIo {
                                inherit name version;
                                sha256 = "1dlmx3cph92n9nsmpgzcbsz0hm42ab6b9yxmhfy88hdmilh77y66";
                                };
          dependencies = [
          "proc_macro2"
proc-macro2-1-0-26--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index--target-required
"quote"
quote-1-0-9--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index--target-required
"unicode_xid"
unicode-xid-0-2-2--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-72--registry-https---github-com-rust-lang-crates-io-index--target-required
          ];
          buildDependencies = [
          
          ];
          devDependencies = [
          
          ];
          features = [
          "clone-impls"
"default"
"derive"
"parsing"
"printing"
"proc-macro"
"quote"
          ];
          noDefaultFeatures = true;
        });

  # Package with pkgid: "unicode-xid 0.2.2 (registry+https://github.com/rust-lang/crates.io-index)"
  # A dependency package
  unicode-xid-0-2-2--registry-https---github-com-rust-lang-crates-io-index- =
    mkRustCrate
      (augmentAttrs "unicode-xid"
        rec {
          name = "unicode-xid";
          version = "0.2.2";
          src = fetchFromCratesIo {
                                inherit name version;
                                sha256 = "0bv6ckigaywphbg1mq4wg6zkdky73spjiqvz0v7ncsd6xgx49c2x";
                                };
          dependencies = [
          
          ];
          buildDependencies = [
          
          ];
          devDependencies = [
          
          ];
          features = [
          "default"
          ];
          noDefaultFeatures = true;
        });

# END OF DEPENDENCIES
  in

  # Package with pkgid: "cargo-platform-to-nix 0.1.0 (path+file:///Dev/cargoMetadata2mkRustCrate/cargo-platform-to-nix)"
  # Root package
    mkRustCrate
      (augmentAttrs "cargo-platform-to-nix"
        rec {
          name = "cargo-platform-to-nix";
          version = "0.1.0";
          src = ./.;
          dependencies = [
          "cargo_platform"
cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index--from-cargo-platform-to-nix-0-1-0--path-file----Dev-cargoMetadata2mkRustCrate-cargo-platform-to-nix--target-required
          ];
          buildDependencies = [
          
          ];
          devDependencies = [
          
          ];
          features = [
          
          ];
          noDefaultFeatures = true;
        })
