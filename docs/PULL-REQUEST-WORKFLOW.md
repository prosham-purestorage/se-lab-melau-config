# Pull Request Workflow for Configuration Changes

The subscriber environment now supports proposing configuration changes back to the master repository via automated Pull Requests.

## Overview

This enables a controlled, reviewable process for subscribers to suggest configuration changes while maintaining the authoritative nature of the shared config.

## Workflow for Subscribers

### 1. Check Current State
```bash
make check-changes
```
Shows any local modifications you've made to configuration files.

### 2. Make Configuration Changes
Edit files in the `config/` directory:
- `config/lab-config.yml` - Main configuration
- `config/secrets.yml` - Encrypted secrets (if you have the key)

### 3. Review Your Changes
```bash
make check-changes
```
This will show:
- Which files have been modified
- Detailed diff of all changes
- Instructions for next steps

### 4. Propose Changes
```bash
make propose-changes
```
This will:
1. Validate that you have changes to propose
2. Prompt for a title and description
3. Create a new branch with timestamp
4. Commit your changes with metadata
5. Push the branch to the remote repository
6. Provide instructions for creating the PR

### 5. Create Pull Request
After running `propose-changes`:
1. Go to the config repository on GitHub
2. GitHub will show a prompt to create a Pull Request
3. Or manually create a PR from the generated branch
4. Wait for admin review and approval

### 6. Get Approved Changes
Once your PR is merged:
```bash
make update
```
This pulls the approved changes back to your environment.

## Example Session

```bash
# Check current state
$ make check-changes
✅ No local changes detected

# Edit configuration
$ vim config/lab-config.yml
# (make your changes)

# Review changes
$ make check-changes
📝 Local changes detected:
 M lab-config.yml

📊 Detailed differences:
-  version: "1.0.0"
+  version: "1.0.1"

# Propose changes
$ make propose-changes
🚀 Proposing Configuration Changes
==================================

📝 Local changes detected:
 M lab-config.yml

📋 Enter a title for your config changes: Update version to 1.0.1
📄 Enter a description of your changes: Bump version for new release

🔧 Creating branch: config-update-my-repo-20250802-143055
💾 Committing changes...
🚀 Pushing branch to remote...
✅ Configuration changes proposed successfully!

📋 Next steps:
  1. Go to the config repository on GitHub
  2. You should see a prompt to create a Pull Request
  3. Or manually create a PR from branch: config-update-my-repo-20250802-143055
  4. Once approved and merged, run 'make update' to get the changes back
```

## Branch Naming Convention

Branches are automatically named with the pattern:
```
config-update-{subscriber-repo-name}-{timestamp}
```

Example: `config-update-vmware-templates-20250802-143055`

## Commit Message Format

Commits include detailed metadata:
```
Config update from {subscriber-repo}: {title}

{description}

Proposed by: {subscriber-repo} repository
Timestamp: {date-time}
```

## Admin Review Process

1. Check for incoming changes: `make review-changes`
2. Accept subscriber changes: `make accept-changes`
3. Or manually review and merge specific PRs

The `make accept-changes` command will:

- Fetch latest changes from subscribers
- Pull and merge approved changes
- Regenerate all export files
- Run validation tests
- Display updated status

For more granular control, admins can:

1. Review individual PRs on GitHub
2. Test changes in a separate branch
3. Merge or request modifications
4. Use `make accept-changes` after manual merges

## Security Considerations

- Only subscribers with push access to the config repo can propose changes
- All changes go through PR review process
- Secrets remain encrypted in proposed changes
- Branch permissions can be configured to require admin approval

## Troubleshooting

### "No changes detected"
- Make sure you've actually modified files in `config/`
- Run `make check-changes` to see current state

### "Permission denied"
- Ensure you have push access to the config repository
- Check your Git credentials and SSH keys

### "Branch already exists"
- The timestamp-based naming should prevent this
- If it occurs, try again (new timestamp will be generated)

## Available Commands

| Command | Purpose |
|---------|---------|
| `make check-changes` | Show local config modifications |
| `make propose-changes` | Create PR with your changes |
| `make update` | Get latest approved changes |
| `make update-submodule` | Force update config (discards local changes) |
| `make review-changes` | **Admin**: Review incoming subscriber changes |
| `make accept-changes` | **Admin**: Accept and integrate subscriber changes |

## Integration with Existing Workflow

The PR workflow coexists with the existing authoritative model:
- `make update` still discards local changes and pulls latest
- New PR workflow provides a path for contributing changes back
- Configuration remains centrally controlled and reviewed
