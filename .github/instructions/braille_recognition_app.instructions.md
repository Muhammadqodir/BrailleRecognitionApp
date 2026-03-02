# BrailleRecognition Rewrite — General Copilot Instructions (Flutter + Laravel)

You are GitHub Copilot assisting with rewriting ONLY:
- Mobile app: Flutter (BLoC)
- Backend API: PHP Laravel
There is a separate Model Server. The Mobile app MUST NOT call it directly.
The Backend orchestrates any ML/translation requests by calling the Model Server.

## 1) Architecture principles (non-negotiable)
- Follow Clean Architecture / Hexagonal mindset:
  - Clear boundaries between presentation, application, domain, infrastructure.
  - Domain must not depend on frameworks or external services.
  - All external communication goes through interfaces (ports) with concrete adapters.
- Prefer composition over inheritance. Keep modules small and cohesive.
- Make it testable by design: dependency injection + pure functions where possible.

## 2) System boundary rules (2 servers)
- Mobile -> Backend only.
- Backend -> Model Server only (private integration).
- Secrets (model server URL/key, tokens, DB creds) NEVER appear in mobile code.
- Never log sensitive payloads (images, raw results, tokens, PII).

## 3) Backend (Laravel) high-level structure
Use a layered structure such as:
- Domain: entities/value objects + domain rules
- Application: use cases/services + DTOs + interfaces (ports)
- Infrastructure: DB repositories, HTTP clients (model server), queues, storage
- Presentation: controllers, requests/validation, resources/serializers

Guidelines:
- Controllers are thin: map request -> use case -> response.
- Put business rules in use cases/services, not controllers.
- Use Form Requests for validation; never trust client input.
- Use consistent error handling and response format across the API.
- Prefer async processing for heavy work (queues/jobs); return quickly to client.
- All external calls (model server) must be wrapped in a dedicated client class with:
  - timeouts
  - limited retries with backoff
  - strict response validation
  - safe logging (request id + duration only)

## 4) Mobile (Flutter) high-level structure
Use a Clean-ish approach:
- Presentation: UI screens/widgets
- State: BLoC/Cubit for flows, explicit states/events
- Domain: entities + use cases (pure logic)
- Data: repositories + remote/local data sources, DTOs/mappers
- Core: networking, storage, error mapping, DI, utilities

Guidelines:
- UI is dumb: it renders state and dispatches events.
- Business logic lives in BLoC + domain use cases.
- Repositories hide where data comes from (API/cache).
- Networking: central client with interceptors (auth, retry rules, logging-safe).
- Secure token storage (platform secure storage).
- Robust UX for long operations:
  - progress states
  - polling/backoff or push updates (optional)
  - retry/resume flows
- Never block UI thread; use isolates for heavy preprocessing if needed.

## 5) Communication contracts
- Define and maintain a single source of truth for client<->backend contracts:
  - Prefer OpenAPI spec or shared DTO definitions.
- Keep API responses consistent; version when breaking changes are needed.
- Use stable IDs and explicit statuses for long-running operations.

## 6) Reliability & observability
Backend:
- Use request correlation IDs (generate if missing; propagate to model server calls).
- Log structured events without sensitive content.
- Rate-limit expensive endpoints.
- Handle partial failures gracefully and return safe error messages.

Mobile:
- Centralized error mapping: network errors vs validation vs server errors.
- Offline/poor connection resilience (at least: retries + graceful messaging).
- Cache minimal data; avoid storing sensitive content unencrypted.

## 7) Performance requirements
- Avoid loading full-resolution images into memory unnecessarily.
- Downscale/compress images before upload when appropriate (configurable).
- Backend: stream uploads, avoid memory spikes, use background jobs for heavy work.
- Prefer pagination and incremental loading for lists.

## 8) Testing strategy (must follow)
Backend:
- Unit tests for use cases and service logic.
- Feature tests for critical user flows.
- Contract tests (basic) to prevent API regressions.

Mobile:
- Unit tests for BLoC and use cases.
- Widget tests for core screens (smoke tests).
- Mock repositories/data sources; avoid real network in tests.

## 9) Code style & quality
- Favor readability and explicitness.
- Small functions, clear naming, typed interfaces.
- No "magic strings" sprinkled around; centralize constants.
- Avoid silent catches; always handle errors intentionally.
- Document intent for non-obvious decisions (short comments or ADR notes).

## 10) What to do when implementing a feature
When asked to implement something, ALWAYS:
1) Propose a clean architecture placement (which layer/module and why).
2) List files/classes to add/change.
3) Generate code with minimal placeholders.
4) Include basic tests.
5) Mention required configuration/env vars (backend) or DI wiring (mobile).

If requirements are unclear, make reasonable assumptions and proceed without asking,
but keep the solution extensible (interfaces, default implementations, feature flags).

## 11) Security hard rules (repeat)
- Never expose model-server details to mobile.
- Never log payloads/results/tokens.
- Validate everything at boundaries (backend requests, model server responses).
