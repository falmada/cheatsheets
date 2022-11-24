# Git - Rebase

```bash
git checkout MyOutdatedBranch
git fetch origin master:master
git rebase origin/master
git status
# After status, you'll see which files need to be fixed, edit tem and "continue"
git rebase --continue
git status
# Repeat, until it is finished
git rebase --continue
git status
# This will fail (master has a different "base")
git push origin MyOutdatedBranch
# Force with lease is less dangerous
git push --force-with-lease origin MyOutdatedBranch
```
