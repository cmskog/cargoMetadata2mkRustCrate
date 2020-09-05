BEGIN {
	FS = "="
	}
{
	if (NF == 1) {
		CFG[$1][0]="true"
	}
	else if (NF == 2) {
			CFG[$1][length(CFG[$1])]=$2
	}
}
END {
	print "{"
	for (i in CFG) {
		printf "%s = ", i
			if (length(CFG[i]) > 1) {
				printf "["
				for (j in CFG[i]) {
					printf " %s", CFG[i][j]
				}
				printf " ]"
			}
			else {
				printf "%s", CFG[i][0]
			}
		print ";"
	}
	print "}"
}
