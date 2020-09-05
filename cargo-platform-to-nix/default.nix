{ rustcNixCfg, fetchFromCratesIo, mkRustCrate }:

# START OF DEPENDENCIES
  let
	_cfg = (import rustcNixCfg);
	_target = _cfg.target_arch
+ "-" + _cfg.target_vendor
+ "-" + _cfg.target_arch
+ (if _cfg.target_env == ""
then ""
else "-" + _cfg.target_env);

# START OF CFG_EXPRESSIONS

# CFG_EXPRESSION: quote 1.0.7 (registry+https://github.com/rust-lang/crates.io-index), proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index-, proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index--from-quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index-, null
proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index--from-quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index- = if true then proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index- else "-";
# CFG_EXPRESSION: syn 1.0.38 (registry+https://github.com/rust-lang/crates.io-index), proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index-, proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index-, null
proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index- = if true then proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index- else "-";
# CFG_EXPRESSION: syn 1.0.38 (registry+https://github.com/rust-lang/crates.io-index), quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index-, quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index-, null
quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index- = if true then quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index- else "-";
# CFG_EXPRESSION: syn 1.0.38 (registry+https://github.com/rust-lang/crates.io-index), unicode-xid-0-2-1--registry-https---github-com-rust-lang-crates-io-index-, unicode-xid-0-2-1--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index-, null
unicode-xid-0-2-1--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index- = if true then unicode-xid-0-2-1--registry-https---github-com-rust-lang-crates-io-index- else "-";
# CFG_EXPRESSION: proc-macro2 1.0.19 (registry+https://github.com/rust-lang/crates.io-index), unicode-xid-0-2-1--registry-https---github-com-rust-lang-crates-io-index-, unicode-xid-0-2-1--registry-https---github-com-rust-lang-crates-io-index--from-proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index-, null
unicode-xid-0-2-1--registry-https---github-com-rust-lang-crates-io-index--from-proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index- = if true then unicode-xid-0-2-1--registry-https---github-com-rust-lang-crates-io-index- else "-";
# CFG_EXPRESSION: serde 1.0.115 (registry+https://github.com/rust-lang/crates.io-index), serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index-, serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index--from-serde-1-0-115--registry-https---github-com-rust-lang-crates-io-index-, null
serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index--from-serde-1-0-115--registry-https---github-com-rust-lang-crates-io-index- = if true then serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index- else "-";
# CFG_EXPRESSION: cargo-platform-to-nix 0.1.0 (path+file:///Dev/cargo-platform-to-nix), cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index-, cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index--from-cargo-platform-to-nix-0-1-0--path-file----Dev-cargo-platform-to-nix-, null
cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index--from-cargo-platform-to-nix-0-1-0--path-file----Dev-cargo-platform-to-nix- = if true then cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index- else "-";
# CFG_EXPRESSION: cargo-platform 0.1.1 (registry+https://github.com/rust-lang/crates.io-index), serde-1-0-115--registry-https---github-com-rust-lang-crates-io-index-, serde-1-0-115--registry-https---github-com-rust-lang-crates-io-index--from-cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index-, null
serde-1-0-115--registry-https---github-com-rust-lang-crates-io-index--from-cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index- = if true then serde-1-0-115--registry-https---github-com-rust-lang-crates-io-index- else "-";
# CFG_EXPRESSION: serde_derive 1.0.115 (registry+https://github.com/rust-lang/crates.io-index), proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index-, proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index-, null
proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index- = if true then proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index- else "-";
# CFG_EXPRESSION: serde_derive 1.0.115 (registry+https://github.com/rust-lang/crates.io-index), quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index-, quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index-, null
quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index- = if true then quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index- else "-";
# CFG_EXPRESSION: serde_derive 1.0.115 (registry+https://github.com/rust-lang/crates.io-index), syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index-, syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index-, null
syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index- = if true then syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index- else "-";

# END OF CFG_EXPRESSIONS
# Package with pkgid: "cargo-platform 0.1.1 (registry+https://github.com/rust-lang/crates.io-index)"
# A dependency package
cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index- = mkRustCrate rec {
    name = "cargo-platform";
    version = "0.1.1";
    src = fetchFromCratesIo {
      inherit name version;
      sha256 = "0jjk6j17303sj2szjv7j8088mj8zvn0y3f9zjdpjm86nis18akrb";
    };
    dependencies = [
"serde"
serde-1-0-115--registry-https---github-com-rust-lang-crates-io-index--from-cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index-
    ];
    buildDependencies = [

    ];
    devDependencies = [

    ];
    features = [

    ];
    noDefaultFeatures = true;
  };

# Package with pkgid: "proc-macro2 1.0.19 (registry+https://github.com/rust-lang/crates.io-index)"
# A dependency package
proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index- = mkRustCrate rec {
    name = "proc-macro2";
    version = "1.0.19";
    src = fetchFromCratesIo {
      inherit name version;
      sha256 = "0bg3gpm2snmfddj6q55fjs360aavdvswlk2c4bjphag00xx59z7w";
    };
    dependencies = [
"unicode_xid"
unicode-xid-0-2-1--registry-https---github-com-rust-lang-crates-io-index--from-proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index-
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
  };

# Package with pkgid: "quote 1.0.7 (registry+https://github.com/rust-lang/crates.io-index)"
# A dependency package
quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index- = mkRustCrate rec {
    name = "quote";
    version = "1.0.7";
    src = fetchFromCratesIo {
      inherit name version;
      sha256 = "0n4qkwj9zwbbgraxc5wnly466dzwyzxlpw396h5m4yazp0sai6ha";
    };
    dependencies = [
"proc_macro2"
proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index--from-quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index-
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
  };

# Package with pkgid: "serde 1.0.115 (registry+https://github.com/rust-lang/crates.io-index)"
# A dependency package
serde-1-0-115--registry-https---github-com-rust-lang-crates-io-index- = mkRustCrate rec {
    name = "serde";
    version = "1.0.115";
    src = fetchFromCratesIo {
      inherit name version;
      sha256 = "0c64j1kjqlz5sqdv8gh8pyzz13c5075z0r77lhff917kyqbd8r2r";
    };
    dependencies = [
"serde_derive"
serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index--from-serde-1-0-115--registry-https---github-com-rust-lang-crates-io-index-
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
  };

# Package with pkgid: "serde_derive 1.0.115 (registry+https://github.com/rust-lang/crates.io-index)"
# A dependency package
serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index- = mkRustCrate rec {
    name = "serde_derive";
    version = "1.0.115";
    src = fetchFromCratesIo {
      inherit name version;
      sha256 = "0why8a69r6f4m3xna0628lpd5zgkqrz464vw4nkzbnqbq2a3pxsr";
    };
    dependencies = [
"proc_macro2"
proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index-
"quote"
quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index-
"syn"
syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index--from-serde-derive-1-0-115--registry-https---github-com-rust-lang-crates-io-index-
    ];
    buildDependencies = [

    ];
    devDependencies = [

    ];
    features = [
"default"
    ];
    noDefaultFeatures = true;
  };

# Package with pkgid: "syn 1.0.38 (registry+https://github.com/rust-lang/crates.io-index)"
# A dependency package
syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index- = mkRustCrate rec {
    name = "syn";
    version = "1.0.38";
    src = fetchFromCratesIo {
      inherit name version;
      sha256 = "0birzz2wxa5fvaf85ikhqv2hq8wdgp2w9fb6bwp9d3l9kfq79qda";
    };
    dependencies = [
"proc_macro2"
proc-macro2-1-0-19--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index-
"quote"
quote-1-0-7--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index-
"unicode_xid"
unicode-xid-0-2-1--registry-https---github-com-rust-lang-crates-io-index--from-syn-1-0-38--registry-https---github-com-rust-lang-crates-io-index-
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
"visit"
    ];
    noDefaultFeatures = true;
  };

# Package with pkgid: "unicode-xid 0.2.1 (registry+https://github.com/rust-lang/crates.io-index)"
# A dependency package
unicode-xid-0-2-1--registry-https---github-com-rust-lang-crates-io-index- = mkRustCrate rec {
    name = "unicode-xid";
    version = "0.2.1";
    src = fetchFromCratesIo {
      inherit name version;
      sha256 = "1fph4gggixccg801ab40q44svyny7kfkmr7j1isb571xgfav13j5";
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
  };

# END OF DEPENDENCIES
  in

# START OF ROOT PACKAGES

# Package with pkgid: "cargo-platform-to-nix 0.1.0 (path+file:///Dev/cargo-platform-to-nix)"
# Root package
mkRustCrate rec {
    name = "cargo-platform-to-nix";
    version = "0.1.0";
    src = ./.;
    dependencies = [
"cargo_platform"
cargo-platform-0-1-1--registry-https---github-com-rust-lang-crates-io-index--from-cargo-platform-to-nix-0-1-0--path-file----Dev-cargo-platform-to-nix-
    ];
    buildDependencies = [

    ];
    devDependencies = [

    ];
    features = [

    ];
    noDefaultFeatures = true;
  }

# END OF ROOT PACKAGES
