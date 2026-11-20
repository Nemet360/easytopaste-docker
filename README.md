# EasyToPaste in a container

```sh
docker run --rm ghcr.io/nemet360/easytopaste:latest send "the thing you were about to paste into Slack"
```

Share a password, an API key or a note through a **one-time link**. The
container encrypts it before anything leaves (AES-256-GCM); the key travels in
the link's URL fragment, which no HTTP client transmits, so the service stores
ciphertext it cannot read. The link dies on first read.

What it is: <https://easytopaste.com/?utm_source=ghcr&utm_medium=container&utm_campaign=launch-2026-11>
· how the encryption works: <https://easytopaste.com/how-it-works/?utm_source=ghcr&utm_medium=container&utm_campaign=launch-2026-11>

## What is in the image

`node:20-alpine` plus the **published npm package**, nothing else. The image
does not carry a copy of the source: one artifact of record, so a container and
a `npm i -g` cannot drift apart. It runs as the unprivileged `node` user.

`EASYTOPASTE_CHANNEL=docker` is baked in. That is how a container run is
distinguishable on the service side — a pipeline never loads a page, so a link
tag cannot measure it. The field reaches the service from CLI **0.1.2** onward;
0.1.1, the version pinned today, ignores it.

## The limit you will meet first

Anonymous callers share a daily allowance of **10 creates per outgoing IP
address**, and a CI runner's address is shared by everybody on that platform.
There is no long-lived API key for machines yet, so a busy pipeline will hit
this. Pass `--token` if an earlier step obtained a bearer token; they last 15
minutes.

## Publishing

Tag the repository `v<cli-version>` and the workflow builds for amd64 and
arm64, pushes to GHCR and then runs the image to prove it starts. Nothing is
stored here: the push uses the workflow's own `GITHUB_TOKEN`.
