# Tips

## How to update fork from main repo

1. Add a secondary remote called **upstream**.
`git remote add upstream https://...`
2. Fetch the remote and then pull its changes into your local master branch.
```
git checkout master
git fetch upstream
git pull upstream master
```
3. Last, push to your own remote origin to keep the forked repo in sync.
`git push origin master`

## Error: You have not concluded your merge (MERGE_HEAD exists).

Error when doing `git pull`
```
error: You have not concluded your merge (MERGE_HEAD exists).
hint: Please, commit your changes before merging.
fatal: Exiting because of unfinished merge.
```

Just run `git merge --abort` and then `git pull` again.