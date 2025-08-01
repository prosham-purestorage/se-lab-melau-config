.PHONY: config update-submodule export-dir

update-submodule:
	git submodule update --init --remote config/shared

export-dir:
	mkdir -p export

config: update-submodule export-dir
	python config/shared/scripts/subscriber/install.py
	python config/shared/scripts/subscriber/update.py --type env --output export/lab-config.env
	python config/shared/scripts/subscriber/update.py --type json --output export/lab-config.json
	python config/shared/scripts/subscriber/update.py --type ps1 --output export/vmware-config.ps1