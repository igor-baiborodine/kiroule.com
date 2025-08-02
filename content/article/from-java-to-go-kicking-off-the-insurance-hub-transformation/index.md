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

TODO: add links

### Raison d'Être or What's My Motivation

As a professional Java developer, I believe that real growth comes from stepping outside the
familiar. Learning another JVM-based language like Kotlin or Scala—even though they have their
strengths—doesn’t shift my mindset or challenge my habits the way picking up a language like Go
does. Go introduces me to entirely new programming paradigms and problem-solving approaches, thanks
to its minimalistic syntax, explicitness, and distinct concurrency model. Its straightforward
standard library and philosophy of “no hidden magic” push me to re-examine how I structure code and
systems. More importantly, Go is engineered for cloud-native development and microservices—domains
where modern software is heading—so adding it to my toolkit directly expands not just my technical
abilities but also my readiness for next-generation software challenges.

Making this leap is about more than simply adding a language to my resume. Immersing myself in Go
means grappling with new idioms, evolving my understanding of system design, and adapting to the
fast-paced, polyglot realities of today’s software teams. It positions me to contribute more
effectively in modern cloud environments and to approach both legacy migrations and greenfield
projects with renewed perspective and confidence. By embracing Go, I’m not just diversifying my
skill set—I’m deliberately preparing for where the industry is going, while also expanding the ways
I can create robust, scalable software solutions.

### Why Insurance Hub?

Before setting out to learn Go, I took a brief detour into Python. My efforts there never really
moved beyond getting comfortable with the syntax and solving a few HackerRank
challenges—engaging, but not transformative. With Go, I made a conscious decision to approach
things differently. I wasn't looking to just dabble in the language; I wanted to truly master the
broader Go ecosystem, the tooling, the patterns, and what it takes to build distributed,
cloud-native systems from scratch. The goal was simple: if I ever transitioned into a Go developer
role, I'd be productive and ready from day one.

I knew that mastering a new language—especially in parallel with a full-time job as a Java
developer—would be a gradual process, one that demanded patience and steady commitment during my
spare hours. My Go journey began in 2022 with Jon Bodner's "Learning Go," coupled with hands-on
practice through Exercism's Go track. In 2023, I raised the bar by working through Travis
Jeffery's "Distributed Services with Go Workshop." That book was a deep dive not just into Go, but
into distributed systems development, and many concepts were entirely new to me. I made it a point
to work through each chapter's code in my local environment, making sure everything ran as intended
and maintaining a fork of the repository to track my understanding alongside Go's evolving
ecosystem. I also challenged myself with problems from "Elements of Programming Interviews" to round
out my skills.

In 2024, I focused on "Event-Driven Architecture In Golang" by Michael Stack—one of the best
resources I've found on building event-driven, cloud-native systems in Go. Once again, I
methodically worked through the material, updating and experimenting with the source code to
reinforce new paradigms and idioms. Once again, I maintained a forked repository for the source code
to keep it current.

That same year marked a significant milestone: I set out to migrate my "Campsite Booking API" pet
project from Java to Go. Previously, I had documented the original Java implementation thoroughly on
my blog, sharing design decisions and lessons learned. Approaching the migration, I drew inspiration
from the Mallbots example in Michael Stack's book, applying its techniques, architectural structure,
and best practices as I rebuilt the application in Go. The process was demanding—spanning many
months—but the result was a fully functional Go-based microservice and a rewarding step forward
in my journey, now available as the campsite-booking-go repository.

To support my progress and explore new facets of Go, I dove into additional books: "Test-driven
Development in Go" by Adelina Simion, "Efficient Go" by Bartłomiej Płotka, "Functional Programming
in Go" by Dylan Meeus, and "Ultimate Go Notebook" by William Kennedy with Hoanh An. Each of these
resources broadened my understanding and deepened my toolkit as I refined my approach.

When it came time to choose the next challenge, I wanted to build something closer to the real-world
complexity—something like the Mallbots application, but drawn from an existing codebase rather than
starting entirely from scratch. My search led me to "Micronaut Microservices POC," a simplified
insurance sales system written in Java and designed around distributed microservices. This project
fit perfectly, aligning with my professional experience in the insurance domain and offering the
kind of scale and architecture ideal for a meaningful migration. Reimagining and building this
system in Go—now titled "Insurance Hub" in my GitHub repository—not only allows me to grow my Go
skills, but also lets me practice a full spectrum of system modernization: migration, architecture
design, cloud deployment on Kubernetes, CI/CD, effective testing strategies, and more.

This journey marks a genuine "dual-learning project"—an opportunity to blend technical growth with
real-world, hands-on modernization skills. Having ported the code and set my sights on a holistic
migration, I'm excited to push forward and share the lessons I learn along the way. Let the journey
begin!

### System Analysis Deep Dive

> **Disclaimer:** All subsequent analysis and migration decisions are made with these key
> assumptions in mind:
>
> * Although the original Java project was developed as a proof of concept, it is approached as if
    it were a production-ready system, running and maintained in a non-cloud-native environment.
    This perspective is intentional to better simulate real-world conditions for learning purposes.
> * As in most real-world scenarios, a complete greenfield rewrite is not feasible. The existing
    system cannot simply be discarded and rebuilt from scratch; instead, a phased, incremental
    migration strategy is necessary to ensure business continuity and minimize risk during the
    transition.

#### A Tale of Two Architectures

To truly understand the "why" behind this migration, it's helpful to visualize the journey from the
starting point to the destination. Below is a high-level comparison that contrasts the original
Java-based architecture with the modernized Go-based target. This "before and after" view clarifies
the strategic shifts in technology, deployment, and operations.

*(Placeholder for Java-based C4 system container diagram)*

*(Placeholder for Go-based C4 system container diagram)*

| Aspect                         | Before (Current State)                                                                                                                         | After (Target State)                                                                                                                                                                                                                        |
|:-------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Language & Framework**       | Java 14 with the Micronaut framework.                                                                                                          | Idiomatic Go, favoring the standard library and proven, lightweight libraries.                                                                                                                                                              |
| **Data Persistence**           | Mixed persistence model: PostgreSQL for relational data, MongoDB for flexible product data, and Elasticsearch for search.                      | Consolidated persistence on PostgreSQL, leveraging its powerful JSONB capabilities to replace MongoDB. Elasticsearch is retained for search.                                                                                                |
| **Interservice Communication** | Primarily synchronous RESTful HTTP APIs, with some asynchronous communication using Apache Kafka.                                              | gRPC-first for all internal service-to-service communication, providing performance and strict API contracts. REST is exposed at the edge via a gRPC-gateway for external clients, with some asynchronous communication using Apache Kafka. |
| **Deployment & Environment**   | Non-cloud-native environment. Docker Compose is used for local development, but production lacks a unified orchestration platform.             | Fully cloud-native and Kubernetes-first. Services are designed as stateless, 12-factor-compliant applications deployed on Kubernetes.                                                                                                       |
| **Observability**              | Basic and incomplete. Distributed tracing is implemented with Zipkin, but there is no centralized logging or comprehensive metrics collection. | Comprehensive, end-to-end observability using OpenTelemetry for traces, Prometheus for metrics, and a centralized logging solution (like Loki) for structured logs.                                                                         |
| **File & Artifact Storage**    | Relies on a local filesystem for storing documents, bank statements, and tariff rules.                                                         | Migrated to S3-compatible object storage (like MinIO) for scalable, durable, and cloud-native artifact management.                                                                                                                          |
| **Legacy Integrations**        | Uses external services like JSReports for PDF generation and a file-based system for tariff rule execution.                                    | Replaced with embedded, modern Go libraries (e.g., `chromedp` for PDFs) and in-memory data grids (Tarantool) for high-performance rule execution.                                                                                           |

#### Key Architectural Shifts

This transformation addresses several critical architectural concerns:

**Operational Complexity Reduction**: The current system's diverse technology stack (Java/Micronaut,
MongoDB, file-based storage, external JSReports) creates multiple operational touchpoints. The
target architecture consolidates these into fewer, more standardized components.

**Cloud-Native Alignment**: Moving from Docker Compose and traditional deployment to
Kubernetes-first architecture enables automatic scaling, rolling updates, and improved resource
utilization while following established cloud-native patterns.

**Data Governance Simplification**: Consolidating from PostgreSQL + MongoDB + file storage to
PostgreSQL + JSONB + object storage reduces data management complexity while maintaining flexibility
through PostgreSQL's advanced JSON capabilities.

**Performance and Reliability**: The shift to gRPC internal communication, in-memory pricing rules (
Tarantool), and Go's efficient concurrency model targets improved system performance and resource
utilization.

**Developer Experience Enhancement**: Standardizing on gRPC with code generation, comprehensive
observability, and Kubernetes-native tooling aims to improve development velocity and debugging
capabilities.

TODO: add link to the system analysis doc

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
  code reviews, and docs.
- Promise honest reporting on successes and failures with these tools.

**Article conclusion goes here.**

Continue reading the series ["Insurance Hub: The Way to Go"](/series/insurance-hub-the-way-to-go/):
{{< series "Insurance Hub: The Way to Go" >}}
