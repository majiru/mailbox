.PHONY: build deploy

build: moody.passwd
	nix-shell --run 'build'

deploy: moody.passwd
	nix-shell --run 'deploy switch'

moody.passwd:
	nix-shell --run 'mkpasswd -sm bcrypt > '$@
