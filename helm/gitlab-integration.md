# Connect Helm to own Gitlab instance

1. Go to your Gitlab instance, for example: <https://gitlab.mydomain.com/-/profile/personal_access_tokens>
2. Set a token name, expiration date, and set required scopes:
   - `read_api`
   - `read_user`
   - `read_repository`
   - If you are going to be developing helm charts, you need to be able to push, hence you also need `write_repository` and `api`
3. Click on `Create personal access token`
4. Copy the newly generated personal access token

Now on a shell, run:

```sh
GITLAB_USER="user.name"
 GITLAB_TOKEN="token obtained on above steps"
PROJECT_ID="1234" # belongs to repo where your helm chart is https://gitlab.mydomain.com/group_name/helm-repo-name
CHANNEL="stable"
helm repo add --username ${GITLAB_USER} --password ${GITLAB_TOKEN} k8s-helm-repo https://gitlab.mydomain.com/api/v4/projects//packages/helm/$\{CHANNEL\}
```
