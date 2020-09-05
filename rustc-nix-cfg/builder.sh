set -e
${rustc} --print cfg | ${gawk} -f ${rustcPrintCfgToNix} > $out
