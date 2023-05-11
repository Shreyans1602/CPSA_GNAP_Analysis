# /bin/sh

cd "$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

mkdir -p ./output

# SOA
cpsa4 -o ./output/soa.out gnap_soa_channels.scm
cpsa4graph -o ./output/soa.xhtml ./output/soa.out

#UCI
cpsa4 -o ./output/uci.out gnap_uci_channels.scm
cpsa4graph -o ./output/uci.xhtml ./output/uci.out