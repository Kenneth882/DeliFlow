# DeliFlow

DeliFlow is a planned bilingual English/Spanish ordering application for a neighborhood bodega or deli. Customers will order through web chat or SMS, and staff will manage pickup orders through a kitchen dashboard. The project aims to demonstrate reliable AI integration, deterministic business rules, and measurable results in a small, understandable system.

## Current status

The repository currently contains project instructions, a shared instruction ledger, and a CI check for the instruction link. Application code, database schema, ordering flows, and evaluation suites have not been implemented yet. The capabilities and release criteria below describe the intended scope, not measured or deployed functionality.

## MVP scope

The first release serves **one deli, pickup orders, and payment at the counter**.

- **Customer ordering:** English, Spanish, and code-switching through web chat and Twilio SMS; menu lookup, item quantities and modifiers, draft edits, order summaries, explicit confirmation, status lookup, and cancellation requests.
- **Kitchen operations:** authenticated staff can accept or reject submitted orders, mark preparation and readiness, record pickup, and handle cancellation requests.
- **Authoritative order rules:** server-calculated prices and configured taxes, validated menu choices, historical price snapshots, and enforced order transitions. The AI interprets requests; application code controls prices, authorization, and state changes.
- **Customer consent:** confirmation applies to a specific, current summary with items, modifiers, quantities, total, pickup details, and expiry. Editing a draft requires a new summary and confirmation. Customer submission and staff acceptance are separate steps.
- **Reliable messaging:** durable inbound records, duplicate protection, ordered conversation processing, queued work, outbound delivery tracking, and recovery after failures. Committed orders remain available to the kitchen during SMS outages.
- **Measured AI quality:** a TypeScript evaluation CLI, reviewed bilingual conversations, a bounded synthetic customer simulator, deterministic graders, and a protected results UI for comparing runs.
- **Isolated public demo:** synthetic customer data, separate orders and notifications, bounded provider spending, redacted telemetry, and documented recovery procedures.

Submitted baskets are frozen. Before staff acceptance, a customer can cancel and start a replacement order; after acceptance, cancellation requires staff approval. Unknown ingredients or allergen details require staff confirmation.

## Outside the MVP

Online payments, delivery dispatch, inventory reservation, and support for multiple stores are outside the initial scope. WhatsApp is a possible later channel. The architecture excludes microservices, Kubernetes, LangChain, vector databases, and fine-tuning.

## Planned technical approach

One repository will contain a modular monolith with separate web and persistent worker processes sharing application and domain code.

| Area | Planned technology |
| --- | --- |
| Web chat, kitchen, results UI, and API routes | Next.js App Router and strict TypeScript |
| Database and staff authentication | Supabase PostgreSQL, Prisma, and Supabase Auth |
| AI and input validation | Anthropic native tool calling, a bounded handwritten loop, and Zod |
| SMS | Twilio with signature validation |
| Background processing | pg-boss and a transactional outbox on PostgreSQL |
| Deployment | Vercel for web; Railway, Fly.io, or equivalent for the persistent worker |
| Observability | Langfuse, Sentry, and pino with redaction |
| Verification and development | Vitest, Playwright, k6, Docker Compose, and GitHub Actions |

## Delivery milestones

1. **Deterministic core:** database schema, synthetic bilingual menu, pricing, order lifecycle, and authorization; demonstrate correctness without an LLM.
2. **Web ordering:** bounded agent loop, web chat, confirmation tied to the current order version, and protected kitchen UI; complete English and Spanish ordering flows through pickup.
3. **Durable messaging:** signed SMS ingress, worker, outbox, rate limits, and recovery; verify duplicate, concurrent, and interrupted processing.
4. **Measured AI quality:** gold cases, simulator, graders, stored results, and CI gates; establish a reproducible baseline and demonstrate regression detection.
5. **Deployable demo:** isolated deployment, telemetry, staging load results, architecture records, and an operations runbook; demonstrate recovery after worker restart without duplicate orders.

Initial release targets include at least 60 reviewed gold cases (25 English, 25 Spanish, and 10 code-switching), 100% passing critical invariant checks, and at least 95% task success overall with 90% in each language slice. These are targets; no quality or performance baseline has been measured. Full release gates and completion criteria are defined in [AGENTS.md](AGENTS.md#evals-and-acceptance-gates).

## Project instructions and ledger

Project instructions live in [AGENTS.md](AGENTS.md), shared with `CLAUDE.md` through a symbolic link.

View the instruction change ledger with `sh scripts/agent-ledger.sh`; verify the link with `sh scripts/agent-ledger.sh check`. See [shared instruction maintenance](docs/agent-instructions.md) for history and recovery details.
