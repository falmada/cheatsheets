# Git - Rebase

## Why rebase?

- You start working on a branch, and last for a few days
- Something changes on the master branch, which may impact your work
- When you try to test your branch, it fails due to NOT having commits which happend AFTER you created the branch
- A `git rebase master`, then `git pull` and finally `git push` would allow to get those changes, apply them to your branch and finally push them with your branch

## Instructions

```bash
branch=MyOutdatedBranch
git checkout ${branch}
git fetch origin master:master
git rebase origin/master
git status
# After status, you'll see which files need to be fixed, edit tem and "continue"
git rebase --continue
git status
# Repeat, until it is finished
git rebase --continue
git status
# Force with lease is less dangerous
git push --force-with-lease origin ${branch}
```

## Simpler approach

If it is just adding commits, without collision, then run below:

```bash
branch=MyOutdatedBranch
# Fetch changes
git fetch
# Rebase
git rebase origin/master
# After a git rebase, you have to do
git push origin ${branch} --force-with-lease
```
