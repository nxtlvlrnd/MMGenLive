#!/bin/bash
#:REV: 0.0.7e
#:DESC: Add environment vars http_proxy, etc. to '/etc/sudoers'
#:DESC: Upgrade Ubuntu system
#:DESC: Install kramdown and elinks
#:DESC: Auto-generate documentation if wiki has changed

set -e

SUDOERS='/etc/sudoers'
FUNCTIONS=~/scripts/include/functions.sh

function edit_sudoers {
	echo "Editing '$SUDOERS'"
	REPL='Defaults	env_keep="http_proxy HTTP_PROXY https_proxy HTTPS_PROXY all_proxy ALL_PROXY"'
	sudo bash -c ". $FUNCTIONS; cf_insert $SUDOERS '^Defaults' '$REPL'"
}

function apt_upgrade {
	echo "Upgrading Ubuntu system"
	eval "$APT_GET update"
	eval "$APT_GET upgrade"
	eval "$APT_GET clean"
}

function install_kramdown_elinks {
	echo "Installing ruby-kramdown and elinks"
	eval "$APT_GET install ruby-kramdown elinks"
}

function regen_docs {
	echo "Generating documentation from Wikis"
	(
		cd /setup/git/MMGenLive
		sudo ./build_system.sh setup_sh_usb_create_docs 'IN_MMLIVE_SYSTEM=1'
	)
}

sudo grep -q 'http_proxy' $SUDOERS || edit_sudoers
apt_upgrade
which kramdown elinks >/dev/null || { install_kramdown_elinks; regen_docs; }

exit 0
