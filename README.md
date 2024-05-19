# Starter-go

This is my first go project. The purpose here is to explore the language's features with no real intention of creating a useful application. Although the intention is not to have real functionality, the code found here will be very useful for future reference.

## How to run

To run the project run the following command:

```bash
curl -fsSL https://raw.githubusercontent.com/danielleitelima/starter-go/master/install.sh | bash
```

## Release process

Currently, the release process is manual. To release a new version, follow the steps below:

1. Tag the commit with the version you want to release:

```bash
git tag -a vX.X.X -m "Release vX.X.X"
git push origin vX.X.X
```

2. Make sure the `GITHUB_TOKEN` environment variable is set with the GitHub token.

```bash
export GITHUB_TOKEN="YOUR_GH_TOKEN"
```

3. Then use [goreleaser](https://goreleaser.com/) to publish the release:

```bash
goreleaser release
```


