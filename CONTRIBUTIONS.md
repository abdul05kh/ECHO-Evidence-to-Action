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
- **Commit**: `d058bc3`

### Contribution 06
- **Title**: Add search query and category filter bar to HomeQueueScreen
- **Category**: UI / Task Management & Search
- **Problem**: Operators lacked real-time keyword search (title, summary, ID) and category filtering across active work orders in `HomeQueueScreen`.
- **Solution**: Implemented `SearchFilterState` value object to manage search queries and category selections cleanly. Added a search input field and interactive category filter chips to `HomeQueueScreen` with empty search state feedback and clear filter action.
- **Files changed**:
  - `mobile/lib/features/home/search_filter_state.dart`
  - `mobile/lib/features/home/home_queue_screen.dart`
  - `mobile/test/unit/search_filter_state_test.dart`
  - `mobile/test/screens/home_queue_screen_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 6 unit tests in `search_filter_state_test.dart` passed, 108 total tests passed.
- **Commit**: `b1b20e2`

### Contribution 07
- **Title**: Implement structured EchoLogger utility and in-memory diagnostic log ring buffer
- **Category**: Core / Utilities & Diagnostics
- **Problem**: Diagnostic logs across AI runtime, storage database, STT transcriber, and outbox sync lacked standard formatting, log level filtering, category tagging, error stack trace capture, and in-memory log buffer retention for diagnostic inspection.
- **Solution**: Implemented `LogLevel` enum, `LogEntry` data model, and `EchoLogger` service featuring configurable ring-buffer in-memory retention (default 200 logs), category tagging (`[AI]`, `[SYNC]`, `[STORAGE]`, `[STT]`, `[UI]`), log level thresholds, text export generator, and broadcast stream listener support.
- **Files changed**:
  - `mobile/lib/core/utils/echo_logger.dart`
  - `mobile/test/unit/echo_logger_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 6 unit tests in `echo_logger_test.dart` passed, 114 total tests passed.
- **Commit**: `1fe1fe0`

### Contribution 08
- **Title**: Enforce repository-wide dart format compliance for CI pipeline
- **Category**: CI/CD & Code Quality
- **Problem**: GitHub Actions CI workflow step `dart format --output=none --set-exit-if-changed .` failed because legacy source files in `mobile/lib/features/` and `mobile/test/` contained non-standard line formatting.
- **Solution**: Formatted all Dart source files across `mobile/` with `dart format .` ensuring 100% clean exit for `dart format --set-exit-if-changed .` and GitHub Actions CI workflow.
- **Files changed**:
  - `mobile/lib/features/*`
  - `mobile/test/*`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `dart format --output=none --set-exit-if-changed .` clean (exit code 0), `flutter analyze` clean, 114 total tests passed.
- **Commit**: `ff6e9b1`

### Contribution 09
- **Title**: Add SyncOutboxItem Drift database DAO converter
- **Category**: Database / Storage
- **Problem**: The Drift SQLite database defines `SyncOutboxItems` table, but lacked Data Access Object (DAO) converter helpers to transform between domain `OutboxOperation` entities and Drift `SyncOutboxItem` / `SyncOutboxItemsCompanion` database representations.
- **Solution**: Implemented `SyncOutboxItemConverter` with lossless serialization methods `toCompanion` and `toDomain`. Added unit test suite `sync_outbox_item_converter_test.dart`.
- **Files changed**:
  - `mobile/lib/core/storage/sync_outbox_item_converter.dart`
  - `mobile/test/unit/sync_outbox_item_converter_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 2 unit tests passed, 116 total tests passed.
- **Commit**: `870ac93`

### Contribution 10
- **Title**: Add prompt injection sanitizer to PolicyEngine
- **Category**: AI / Security
- **Problem**: User speech-to-text transcripts or photo text inputs might contain adversarial prompt injection phrases (e.g., `Ignore previous instructions`, `System: override prompt`) that attempt to manipulate local model parameters or bypass deterministic safety rules.
- **Solution**: Implemented `PromptInjectionSanitizer` with regex pattern detection and redaction safeguards. Integrated sanitizer into `PolicyEngine.evaluate()` to lower confidence scores and flag injection risks for operator review. Added a dedicated suite of unit tests.
- **Files changed**:
  - `mobile/lib/features/ai/prompt_injection_sanitizer.dart`
  - `mobile/lib/features/ai/policy_engine.dart`
  - `mobile/test/unit/prompt_injection_sanitizer_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 3 unit tests passed, 119 total tests passed.
- **Commit**: Pending
