# ADR 001: Clean Architecture + BLoC

**Status:** Accepted

**Context:** Showcase app must demonstrate scalable Flutter structure for freelance clients.

**Decision:** Three layers per feature with BLoC/Cubit in presentation and `Either<Failure, T>` in domain.

**Consequences:** More boilerplate, but clear test boundaries and familiar pattern for hiring/portfolio reviewers.
