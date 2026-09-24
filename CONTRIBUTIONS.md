# ECHO - Contribution Log

This file tracks all genuine contributions.

---

### Contribution 01
- **Title**: Add reusable PriorityBadge, CategoryChip, EchoLoadingIndicator, and formatters
- **Category**: UI / Shared Components
- **Problem**: Inconsistent rendering of priority badges, category chips, loading states, and date/duration formatters across mobile screens.
- **Solution**: Implemented reusable `PriorityBadge`, `CategoryChip`, `EchoLoadingIndicator`, `EmptyStateWidget`, `ConfirmDialog`, `DateFormatter`, and `DurationFormatter`.
- **Files changed**:
  - `mobile/lib/core/utils/date_formatter.dart`
  - `mobile/lib/core/utils/duration_formatter.dart`
  - `mobile/lib/shared/widgets/category_chip.dart`
  - `mobile/lib/shared/widgets/confirm_dialog.dart`
  - `mobile/lib/shared/widgets/echo_loading_indicator.dart`
  - `mobile/lib/shared/widgets/empty_state_widget.dart`
  - `mobile/lib/shared/widgets/priority_badge.dart`
  - `mobile/lib/shared/widgets/status_pill.dart`
- **Tests performed**: Unit & Widget tests.
- **Commit**: `cd7a080`

### Contribution 02
- **Title**: Expand domain routing, state machine rules, bridge exporters, and storage diagnostics
- **Category**: Core / Domain Architecture & AI
- **Problem**: Domain routing logic, state transitions, bridge exporters, and diagnostic output needed stricter rules and error resilience.
- **Solution**: Enhanced `ActionPacketModel`, `TaskStateMachine`, `OfficeKitBridge`, `LocalLlmProvider`, `PolicyEngine`, and `SchemaValidator`.
- **Files changed**:
  - `mobile/lib/core/storage/local_db.dart`
  - `mobile/lib/features/ai/local_llm_provider.dart`
  - `mobile/lib/features/ai/policy_engine.dart`
  - `mobile/lib/features/ai/schema_validator.dart`
  - `mobile/lib/features/bridge/office_kit_bridge.dart`
  - `mobile/lib/features/packet/domain/action_packet.dart`
  - `mobile/lib/features/tasks/domain/task_state_machine.dart`
  - `mobile/lib/features/settings/presentation/ai_runtime_screen.dart`
  - `mobile/lib/features/tasks/presentation/task_detail_screen.dart`
- **Tests performed**: Unit & Integration tests.
- **Commit**: `837a492`

### Contribution 03
- **Title**: Expand unit and widget test coverage to 96 passing tests
- **Category**: Testing / Reliability
- **Problem**: Codebase required comprehensive unit and widget tests for domain value objects, formatters, state machine matrix, bridges, and screen widgets.
- **Solution**: Added 26 test files covering screens, widgets, models, state machine transitions, and bridge exporters.
- **Files changed**:
  - `mobile/test/model_adapter_test.dart`
  - `mobile/test/screens/*`
  - `mobile/test/unit/*`
  - `mobile/test/widgets/*`
- **Tests performed**: 96 passing Flutter unit & widget tests.
- **Commit**: `c519953`

### Contribution 04
- **Title**: Document engineering contributions, verification guide, and CI pipeline
- **Category**: Documentation & CI/CD
- **Problem**: Missing unified documentation of contributions, project verification guide, and GitHub Actions CI workflow setup.
- **Solution**: Updated `README.md`, `CONTRIBUTIONS.md`, `.github/workflows/ci.yml`, `scripts/verify_project.bat`, and `analysis_options.yaml`.
- **Files changed**:
  - `.github/workflows/ci.yml`
  - `CONTRIBUTIONS.md`
  - `README.md`
  - `mobile/analysis_options.yaml`
  - `scripts/verify_project.bat`
- **Tests performed**: Verification script & CI workflow execution.
- **Commit**: `d496f99`

### Contribution 05
- **Title**: Implement SyncOutboxManager and exponential backoff retry policy for offline operations
- **Category**: Features / Storage & Offline Sync
- **Problem**: The database defined `SyncOutboxItems` for offline persistence, but the application lacked a dedicated manager service to enqueue operations, calculate exponential backoff retries, track outbox status transitions, enforce idempotency, and purge stale synced entries.
- **Solution**: Implemented `OutboxOperation` domain object and `SyncOutboxManager` queue service with exponential backoff retry scheduling, idempotency key deduplication, status transition lifecycle (`pending` -> `syncing` -> `synced` / `failed`), retention purging, and diagnostic summary statistics. Added a dedicated suite of unit tests.
- **Files changed**:
  - `mobile/lib/core/sync/outbox_operation.dart`
  - `mobile/lib/core/sync/sync_outbox_manager.dart`
  - `mobile/test/unit/sync_outbox_manager_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean, `flutter test test/unit/sync_outbox_manager_test.dart` passed, full test suite (102 tests) passed.
- **Commit**: Pending
