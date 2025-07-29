---
title: "From Java to Go: Kicking Off the Insurance Hub Transformation"
date: 2025-07-28T17:00:00-04:00

categories: [ "Go", "Write-up" ]
tags: [ "Java-to-Go", "Software Migration", "Cloud-Native Go", "AI in Software Development" ]
toc: false
series: [ "Insurance Hub: The Way to Go" ]

author: "Igor Baiborodine"
---

**Article intro 1 goes here.**

<!--more-->

**Article intro 2 goes here.**

{{< toc >}}

### Raison d'Être or What's My Motivation

- Briefly explain why learning a new programming language is widely considered a cornerstone of
  professional development for a software engineer.
- Briefly mention my background and why Go attracts me as a professional Java developer.
- Elaborate on my previous Go learning experiences and list previous Go pet projects.
- Emphasize the jump from small pet projects to a real-world system rewrite. Include a short, honest
  reflection on prior explorations with Go and what none of those smaller
  projects could offer compared to a big migration.
- Briefly mention why migration skills matter beyond just picking up Go (e.g. cloud, “polyglot”
  teams, etc.).

### Why Insurance Hub?

- Java project -> to Go, it's logical and simpler for me since I'm a Java developer
- Offer a candid description of how you selected this system—why not something simpler, or a
  greenfield project? (This helps frame the "real-world complexity" factor.)
- Highlight this as a "dual-learning project": growing Go skills *and* system
  architecture/modernization skills.
- Familiar business domain → lowers domain-knowledge risk.
- Technically challenging enough to stay interesting.
- Opportunity to cover much more than Go coding: migration of an existing system, system design,
  cloud deployment with k8s, CI/CD, testing strategies for replacement components etc.

### System Analysis Deep Dive

- Show a C4 simple architecture diagram or visual to engage readers.
- Instead of a dry summary, you could frame this as a **"Tale of Two Architectures."** Use your
  `system-overview-and-migration-analysis.md` to create a high-level comparison table or a "before
  and after" narrative.
  - **Before (Current State):** Java 14/Micronaut, mixed persistence (PostgreSQL, MongoDB), basic
    observability, non-cloud-native deployment.
  - **After (Target State):** Idiomatic Go, consolidated persistence (PostgreSQL with JSONB),
    gRPC-first communication, comprehensive observability on Kubernetes.
    This creates a clearer, more engaging picture for the reader.

### Migration Strategy Overview

- High-level phases (6-phase approach from your analysis) or use a simple phase table or timeline
  graphic to visualize the roadmap.
- Briefly introduce the “Strangler Fig” pattern and why phased, safe migration matters.

### Iterative Dev with GitHub Projects

- Include a screenshot (if possible) or a brief demo/description of how you set up your GitHub
  Project for solo work.

### How AI Tools Fit In

This is a very strong and unique point. Be sure to emphasize it. It will set my blog series apart
by integrating a highly relevant and modern topic into the development workflow. This is a great
way to attract a broader audience.

- AI as a learning accelerator
- Elaborate on JetBrains AI Pro, Junie coding agent, Perplexity—explain how they’ll speed up design,
  code reviews and docs.
- Promise honest reporting on successes and failures with these tools.

**Article conclusion goes here.**

Continue reading the series ["Insurance Hub: The Way to Go"](/series/insurance-hub-the-way-to-go/):
{{< series "Insurance Hub: The Way to Go" >}}
