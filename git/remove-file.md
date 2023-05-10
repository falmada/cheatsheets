# Remove file

This is **ONLY** recommended if you have screwed it up and pushed sensitive data to the repositories.

```sh
# cd into the main directory from the local repo
git filter-branch -f --prune-empty --index-filter "git rm -r --cached --ignore-unmatch ./path/to/file2remove.tar.gz" HEAD
# Or simpler
git filter-branch -f --index-filter 'git rm --cached --ignore-unmatch *file2remove.tar.gz'
```

Once done, you will have a conflict with the repository, as shown below:

```sh
╰─ git push
To url.to.git:project/repo.git
 ! [rejected]        master -> master (non-fast-forward)
error: falló el push de algunas referencias a 'git@url.to.git:project/repo.git'
ayuda: Actualizaciones fueron rechazadas porque la punta de tu rama actual está
ayuda: detrás de su contraparte remota. Integra los cambios remotos (es decir
ayuda: 'git pull ...') antes de hacer push de nuevo.
ayuda: Mira 'Note about fast-forwards' en 'git push --help' para más detalles.
```

Unprotect the master branch (and any other branch affected by this), perform a `git push origin master --force` and finally protect the branch once again, otherwise it will fail.

## References

- [StackOverflow](https://stackoverflow.com/a/28772827)