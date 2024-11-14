## Useful links
- [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)

## Notes
- Simplified version: `<type>[optional scope]: <description>`
- Types:
	- `fix:`
		- patches a bug in codebase
		- correlates with `PATCH` in SemVer
	- `feat:`
		- introduces a new feature to codebase
		- correlates with `MINOR` in SemVer
	- `BREAKING CHANGE:` or append `!` after the type/scope
		- introduces a breaking API change
		- correlates with `MAJOR` in SemVer
		- It can be related to commits of any `type`
	- `docs:`
	- `ci:`
	- `style:`
	- `build:`
	- `chore:`
		- Related to routine work: maintenance work, dependency update, etc
	- And others
- Optional scope:
	- Useful to identify a specific component or section affected by this commit
	- For example `api`, `lang`, `moduleX`, `scripts`, `runbooks`
	- As the name says, it's optional
- Description:
	- Should be clear what the commit is actually doing, in a summarized text
- Examples:
	- `ci: update deploy step`
	- `ci(stage1): clear unused variables`
	- `docs: correct typos`
	- `docs(runbooks): update NodeDown.md`
	- `fix(mainModule): deprecated functionX`

Conventional commits also has `[optional body]` and `[optional footer]` but will not cover it here as it makes it far more complex for my use cases.