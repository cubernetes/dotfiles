#! /bin/bash --

set -e

usage () {
	printf 'USAGE:\n\t%s DOMAIN NAME USER\n' "${0}"
}

domain="${1-}" # ex. nosu
name="${2-}" # ex. bastion
user="${3-}" # ex. root
[ -z "${domain-}" ] && { echo "Missing domain (1st argument)"; usage; exit 1; }
[ -z "${name-}" ] && { echo "Missing name (2st argument)"; usage; exit 2; }
[ -z "${user-}" ] && { echo "Missing user (3st argument)"; usage; exit 3; }

conn="${domain-}_${name-}_${user-}"
if [ -f ~/.ssh/"${domain-}"/"${conn-}" ]; then
	echo "File already created, exiting."
	exit 1
fi

echo "COPY THIS PASSWORD, IT WILL ONLY BE SHOWN ONCE"
pw="$(keepassxc-cli diceware --words 6 | tr ' ' '_')_A.1"
mkdir -p ~/.ssh/"${domain-}"/
ssh-keygen -q -t ed25519 -a 5 -N "${pw-}" -f ~/.ssh/"${domain-}"/"${conn-}" -C "tosuman@archtosu->${user-}@${conn-}"
echo "${pw-}"
echo -e "\033[32mSUCCESS\033[m"
