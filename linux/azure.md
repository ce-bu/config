
## PAT autentication

```
MY_PAT=yourPAT # replace "yourPAT" with your actual PAT
B64_PAT=$(printf "%s"":$MY_PAT" | base64)
git -c http.extraHeader="Authorization: Basic ${B64_PAT}" clone https://dev.azure.com/yourOrgName/yourProjectName/_git/yourRepoName
```


In *~/.gitconfig*

```
[credential]
	helper = store --file=/home/ubuser/.git-credentials
```

In *.git-credentials* (!!! UNSAFE)
```
https://USER:PATH_TOKEN@dev.azure.com
```
