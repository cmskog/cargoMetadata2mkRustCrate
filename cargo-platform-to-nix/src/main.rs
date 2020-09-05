use cargo_platform::{Cfg,CfgExpr,Platform};
use std::str::FromStr;
use std::env;


fn main() {
    let args: Vec<String> = env::args().collect();

    for arg in &args[1..] {
        let p = Platform::from_str(arg).unwrap();

        match p {
            Platform::Name(name) => {
                println!("(_target == \"{}\")", name);
            },
            Platform::Cfg(ref expr) => {
                println!("{}", handle_cfgexpr(expr));
            },
        }
    }
}

fn handle_cfgexpr(expr: &CfgExpr) -> String {
    match *expr {
        CfgExpr::Not(ref expr) => {
            format!("(!{})", handle_cfgexpr(expr))
        },
        CfgExpr::All(ref exprs) => {
            let mut all_string = String::from("(");

            for (i, expr) in exprs.iter().enumerate() {
                if i > 0 {
                    all_string.push_str(" && ");
                }
                all_string.push_str(handle_cfgexpr(expr).as_str());
            }

            all_string.push_str(")");

            all_string
        }
        CfgExpr::Any(ref exprs) => {
            let mut all_string = String::from("(");

            for (i, expr) in exprs.iter().enumerate() {
                if i > 0 {
                    all_string.push_str(" || ");
                }
                all_string.push_str(handle_cfgexpr(expr).as_str());
            }

            all_string.push_str(")");

            all_string
        },
        CfgExpr::Value(ref cfg) => {
            match *cfg {
                Cfg::Name(ref s) => {
                    format!("(_cfg ? {0} && _cfg.{0} == true)", s)
                },
                Cfg::KeyPair(ref k, ref v) => {
                    format!("(_cfg ? {0} && _cfg.{0} == \"{1}\")", k, v)
                }
            }
        }
    }
}
