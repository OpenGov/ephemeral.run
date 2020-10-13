# ephemeral.run

[![CI](https://github.com/OpenGov/ephemeral.run/workflows/CI/badge.svg?branch=main)](https://github.com/OpenGov/ephemeral.run/actions?query=workflow%3ACI+branch%3Adevelop)
[![ephemeral.run website](https://img.shields.io/badge/docs-ephemeral.run-blue.svg)](https://ephemeral.run)
[![Release Version](https://img.shields.io/github/v/release/OpenGov/ephemeral.run?label=ephemeral.run)](https://github.com/OpenGov/ephemeral.run/releases/latest)
[![License](https://img.shields.io/github/license/OpenGov/ephemeral.run?color=light%20green&logo=github)](https://github.com/OpenGov/ephemeral.run/blob/main/LICENSE)

![ephemeral.run logo](docs/static/ephemeral-run-logo.png "ephemeral.run")

ephemeral.run is an open-source project created by [@OpenGov](https://github.com/OpenGov) and [@infracloudio](https://github.com/infracloudio) to provide development teams with full application environments for every PR – before merging!

On 14 October 2020 we introduced ephemeral.run at a [CNCF community webinar](https://www.cncf.io/webinars/ephemeral-run-a-full-application-environment-for-every-pr-before-you-merge-to-master/). The slides can be viewed [here](https://docs.google.com/presentation/d/1qxDG2AnNu6od_H-og0tK7NKSw9PkFWco8ONdZCZGcS0/edit?usp=sharing). A link to the recording is forthcoming.

## Getting Started

Coming soon!

## Contributing

We're just getting started, so star the repo, open issues, open PRs, and we'll slowly build this topic out.

Our maintainers (admins) are:

- [@abhisheks-infracloud](https://github.com/abhisheks-infracloud)
- [@gchaware](https://github.com/gchaware)
- [@jspiro](https://github.com/jspiro)
- [@vishal-biyani](https://github.com/vishal-biyani)

Note that this repository's configuration and permissions are managed by Terraform (maintained by [@jspiro](https://github.com/jspiro)). Changes must _never_ be made in the GitHub UI.

## Design Goals

These were the design goals we started with:

- Minimal per-environment cost that scales linearly with your team
- Environments are "real" (not faked) and reflective of production
- Easy to use and convenient for everyone, not just developers
- Minimally complex configuration, fewer moving parts, prefer OSS reuse over ["not invented here"](https://en.wikipedia.org/wiki/Not_invented_here)
- Left-shift as much development and testing as possible to be pre-merge

Anti-goals:

- Performance: While we want these to be fast to start, they can only be so fast while meeting the above goals

## Roadmap

These are sorted by what we feel provides the broadest value to teams. Over time we'd like to migrate to a better document format like [this](https://github.com/moby/moby/blob/master/ROADMAP.md) or use GitHub Projects. (If you're a good project manager, help us out!)

- A generic, fork-friendly framework with simplified configuration DSL/templates.
  - Skaffold is powerful but verbose and easy to miswire. Not everyone needs that flexibility.
- A loving and proactive @runbot (like GitHub's @dependabot)
- BotKube integration for ChatOps
- Suspend/Resume: Scale down compute indefinitely while retaining data
- Dynamic TTLs on cluster resources
- Local-to-remote telepresence: Connect a locally running service in an IDE to a remote cluster
- CI integration
  - Wait for CI to finish building before starting, or launch/manage an environment from a pipeline
- Smarter Pod scheduling to optimize autoscaling
  - Run the fewest number of nodes necessary and schedule with MostRequestedPriority or other tricks. The default spread behavior can keep all our nodes online for only one environment.
- Centralized Control Plane with UI
- Usage reporting and analytics
- Budgeting policies
  - Dynamically control the number of environments and autoscalers

## Logo

Our logo was designed by @torymartin88 (torymartin.com).

---

## Licensing

ephemeral.run is licensed under the Apache License, Version 2.0. See LICENSE for the full license text.
