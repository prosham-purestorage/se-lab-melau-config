# Makefile for SE Lab Melbourne Config Repo

.PHONY: tests test-decrypt test-export test-subscriber clean

# Run all tests
tests: test-decrypt test-export test-subscriber

# Test decryption of secrets
test-decrypt:
	.venv/bin/python scripts/admin/test_decrypt_secrets.py

# Test export of all formats
test-export:
	.venv/bin/python scripts/subscriber/update.py --type env --output export/lab-config.env --config lab-config.yml --secrets secrets.yml.encrypted --key $(HOME)/.purestorage/se-lab-melau.key
	.venv/bin/python scripts/subscriber/update.py --type json --output export/lab-config.json --config lab-config.yml --secrets secrets.yml.encrypted --key $(HOME)/.purestorage/se-lab-melau.key
	.venv/bin/python scripts/subscriber/update.py --type ps1 --output export/lab-config.ps1 --config lab-config.yml --secrets secrets.yml.encrypted --key $(HOME)/.purestorage/se-lab-melau.key

# Test subscriber workflows (simulates submodule usage)
test-subscriber:
	.venv/bin/python scripts/admin/test_subscriber_workflow.py

# Clean export files
clean:
	rm -f export/lab-config.env export/lab-config.json export/lab-config.ps1
