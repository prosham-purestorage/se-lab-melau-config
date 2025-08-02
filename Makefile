# Makefile for SE Lab Melbourne Config Repo

.PHONY: tests test-decrypt test-export test-subscriber clean export commit push status help

# Default target - show help
help:
	@echo "Available targets:"
	@echo "  tests           - Run all tests (decrypt, export, subscriber)"
	@echo "  test-decrypt    - Test secrets decryption"
	@echo "  test-export     - Test configuration export to all formats"
	@echo "  test-subscriber - Test subscriber workflow simulation"
	@echo "  export          - Generate all configuration files"
	@echo "  clean           - Remove generated export files"
	@echo "  status          - Show git status and recent commits"
	@echo "  commit          - Export configs, add all changes, and commit"
	@echo "  push            - Commit and push changes to GitHub"
	@echo ""
	@echo "Git Workflow:"
	@echo "  make commit     # Export + add + commit with message prompt"
	@echo "  make push       # Full workflow: export + commit + push"

# Run all tests
tests: test-decrypt test-export test-subscriber

# Default target
all: help

# Export configuration files (alias for test-export)
export: test-export

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

# Git workflow targets
status:
	@echo "📊 Git Status:"
	git status --short
	@echo ""
	@echo "📈 Recent commits:"
	git log --oneline -5

# Commit changes with automated export
commit: export
	@echo "🔄 Adding all changes..."
	git add .
	@echo "📝 Committing changes..."
	@read -p "Enter commit message: " msg; \
	git commit -m "$$msg"
	@echo "✅ Changes committed successfully"

# Push to GitHub (commits and pushes)
push: commit
	@echo "🚀 Pushing to GitHub..."
	git push origin main
	@echo "✅ Changes pushed to GitHub successfully"
