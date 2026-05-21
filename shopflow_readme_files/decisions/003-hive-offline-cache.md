# ADR 003: Hive Offline Cache

**Status:** Accepted

**Decision:** Hive boxes for catalog/order persistence; `ConnectivityCubit` for UI offline state (not a mutation queue).

**Consequences:** Reads survive offline; writes may fail until online unless feature implements local queue later.
