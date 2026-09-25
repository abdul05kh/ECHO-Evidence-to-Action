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
- **Commit**: `7576d99`

### Contribution 11
- **Title**: Implement EvidenceGroundingCalculator for multimodal claim verification
- **Category**: AI / Domain
- **Problem**: Generated Action Packets may contain ungrounded or hallucinated claims that lack supporting evidence links or transcript provenance.
- **Solution**: Implemented `EvidenceGroundingCalculator` and `EvidenceGroundingResult` to evaluate the ratio of grounded facts versus ungrounded claims, calculate grounding scores (0.0 to 1.0), assign confidence states (`Verified`, `High Confidence`, `Needs Review`), and list ungrounded claims. Added unit test suite `evidence_grounding_calculator_test.dart`.
- **Files changed**:
  - `mobile/lib/features/ai/evidence_grounding_calculator.dart`
  - `mobile/test/unit/evidence_grounding_calculator_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 2 unit tests passed, 121 total tests passed.
- **Commit**: `7a7c111`

### Contribution 12
- **Title**: Add MarkdownExporter to OfficeKitBridge
- **Category**: Features / Bridge
- **Problem**: `OfficeKitBridge` formatted plain text for clipboard export, but lacked structured GitHub Flavored Markdown (GFM) export capability with tables, blockquotes, and task checkboxes for external tool integration.
- **Solution**: Implemented `MarkdownExporter.toMarkdown(packet)` generating clean GFM reports formatted with property tables, summary quotes, fact lists, and task checkboxes. Added unit test suite `markdown_exporter_test.dart`.
- **Files changed**:
  - `mobile/lib/features/bridge/markdown_exporter.dart`
  - `mobile/test/unit/markdown_exporter_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 1 unit test passed, 122 total tests passed.
- **Commit**: `bb8a56c`

### Contribution 13
- **Title**: Add CSVExporter to OfficeKitBridge
- **Category**: Features / Bridge
- **Problem**: Operators lacked CSV export functionality to export Action Packets and task lists into tabular spreadsheets (Excel / Google Sheets).
- **Solution**: Implemented `CSVExporter` supporting single packet CSV conversion and batch list CSV export with proper quote escaping. Added unit test suite `csv_exporter_test.dart`.
- **Files changed**:
  - `mobile/lib/features/bridge/csv_exporter.dart`
  - `mobile/test/unit/csv_exporter_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 2 unit tests passed, 124 total tests passed.
- **Commit**: `471f170`

### Contribution 14
- **Title**: Add JSONSchemaExporter to OfficeKitBridge
- **Category**: Features / Bridge
- **Problem**: Enterprise REST backends require strict JSON payloads formatted according to the ECHO Action Packet API contract.
- **Solution**: Implemented `JSONSchemaExporter.toJsonSchemaString(packet)` generating JSON schema payloads with schema URI and generation metadata. Added unit test suite `json_schema_exporter_test.dart`.
- **Files changed**:
  - `mobile/lib/features/bridge/json_schema_exporter.dart`
  - `mobile/test/unit/json_schema_exporter_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 1 unit test passed, 125 total tests passed.
- **Commit**: `7d73431`

### Contribution 15
- **Title**: Implement ChecklistStateNotifier for TaskDetailScreen
- **Category**: Features / Tasks
- **Problem**: `TaskDetailScreen` toggled checklist items inline without a dedicated state notifier managing checklist completion counts, progress ratios, percentage text strings, and item additions/removals.
- **Solution**: Implemented `ChecklistStateNotifier` managing checklist items state, completion ratios, percentage strings (e.g. `75%`), and item toggles/additions/removals. Added unit test suite `checklist_state_notifier_test.dart`.
- **Files changed**:
  - `mobile/lib/features/tasks/domain/checklist_state_notifier.dart`
  - `mobile/test/unit/checklist_state_notifier_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 3 unit tests passed, 128 total tests passed.
- **Commit**: Pending

### Contribution 16
- **Title**: Add TaskEventAuditLogger helper
- **Category**: Features / Storage & Audit
- **Problem**: Task state changes (creation, claim, evidence attachment, completion, sync) lacked a structured audit logging mechanism for forensic tracking and compliance verification.
- **Solution**: Implemented `TaskEventAuditLogger` and `TaskAuditEvent` model with timestamped event logging, task ID filtering, JSON serialization, and Riverpod provider support. Added unit test suite `task_event_audit_logger_test.dart`.
- **Files changed**:
  - `mobile/lib/core/storage/task_event_audit_logger.dart`
  - `mobile/test/unit/task_event_audit_logger_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 3 unit tests passed, 131 total tests passed.
- **Commit**: Pending

### Contribution 17
- **Title**: Add NetworkConnectivityMonitor utility
- **Category**: Features / Network & Sync
- **Problem**: The app lacked a centralized network connectivity monitor to determine online/wifi/offline state and sync readiness.
- **Solution**: Implemented `NetworkConnectivityMonitor` with `NetworkStatus` enum, `isOnline`, `isWifi`, and `canSync` properties, status update methods, and Riverpod provider support. Added unit test suite `network_connectivity_monitor_test.dart`.
- **Files changed**:
  - `mobile/lib/core/network/network_connectivity_monitor.dart`
  - `mobile/test/unit/network_connectivity_monitor_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 3 unit tests passed, 134 total tests passed.
- **Commit**: Pending

### Contribution 18
- **Title**: Implement BackgroundSyncWorker service
- **Category**: Features / Network & Sync
- **Problem**: Outbox items queued during offline operation required manual triggering or fragmented sync calls across screens.
- **Solution**: Implemented `BackgroundSyncWorker` coordinating `SyncOutboxManager` and `NetworkConnectivityMonitor` for automatic background queue processing when network connectivity is active. Added unit test suite `background_sync_worker_test.dart`.
- **Files changed**:
  - `mobile/lib/core/sync/background_sync_worker.dart`
  - `mobile/lib/core/sync/sync_outbox_manager.dart`
  - `mobile/test/unit/background_sync_worker_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 2 unit tests passed, 136 total tests passed.
- **Commit**: Pending

### Contribution 19
- **Title**: Add priority filter selector chips to HomeQueueScreen
- **Category**: Features / UI & Filtering
- **Problem**: `HomeQueueScreen` only allowed filtering by category and query, forcing users to scroll through large queues to find urgent or high priority work orders.
- **Solution**: Added interactive priority filter selector chips (`ALL PRIORITIES`, `LOW`, `MEDIUM`, `HIGH`, `URGENT`) to `HomeQueueScreen` UI connected to `SearchFilterState`. Added unit test suite `home_queue_priority_filter_test.dart`.
- **Files changed**:
  - `mobile/lib/features/home/home_queue_screen.dart`
  - `mobile/test/unit/home_queue_priority_filter_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 3 unit tests passed, 139 total tests passed.
- **Commit**: Pending

### Contribution 20
- **Title**: Implement PullToRefresh gesture on HomeQueueScreen
- **Category**: Features / UI & Interaction
- **Problem**: `HomeQueueScreen` required navigating away or manually triggering diagnostics to reload queue state or re-check active work orders.
- **Solution**: Wrapped `CustomScrollView` in `RefreshIndicator` gesture handling with `_onRefreshQueue` async callback, smooth accent Gold progress indicator, and state preservation. Added unit test suite `home_queue_refresh_test.dart`.
- **Files changed**:
  - `mobile/lib/features/home/home_queue_screen.dart`
  - `mobile/test/unit/home_queue_refresh_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 1 unit test passed, 140 total tests passed.
- **Commit**: Pending

### Contribution 21
- **Title**: Add EchoEmptyStateWidget component
- **Category**: Features / UI Components
- **Problem**: Empty states across queue, outbox, search, and audit log screens duplicated inline empty state container widgets.
- **Solution**: Implemented reusable `EchoEmptyStateWidget` with configurable icon, title, subtitle, action label, and tap callback in `mobile/lib/shared/widgets/echo_empty_state_widget.dart`. Added widget test suite `echo_empty_state_widget_test.dart`.
- **Files changed**:
  - `mobile/lib/shared/widgets/echo_empty_state_widget.dart`
  - `mobile/test/unit/echo_empty_state_widget_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 2 widget tests passed, 142 total tests passed.
- **Commit**: Pending

### Contribution 22
- **Title**: Add EchoNetworkStatusBadge UI widget
- **Category**: Features / UI Components
- **Problem**: Offline, cellular, and Wi-Fi network connectivity statuses were not visually indicated in app top bars or settings overview panels.
- **Solution**: Implemented `EchoNetworkStatusBadge` displaying color-coded pill badges (`ONLINE (WIFI)`, `ONLINE (CELLULAR)`, `OFFLINE (LOCAL QUEUE)`) with distinct icons and themed borders in `mobile/lib/shared/widgets/echo_network_status_badge.dart`. Added widget test suite `echo_network_status_badge_test.dart`.
- **Files changed**:
  - `mobile/lib/shared/widgets/echo_network_status_badge.dart`
  - `mobile/test/unit/echo_network_status_badge_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 3 widget tests passed, 145 total tests passed.
- **Commit**: Pending

### Contribution 23
- **Title**: Add EvidenceStorageSizeCalculator utility
- **Category**: Features / Storage Diagnostics
- **Problem**: Storage diagnostics lacked a standardized utility for calculating cumulative attachment sizes and formatting human-readable byte values (B, KB, MB, GB).
- **Solution**: Implemented `EvidenceStorageSizeCalculator` in `mobile/lib/core/storage/evidence_storage_size_calculator.dart` with byte calculation and string formatting helpers. Added unit test suite `evidence_storage_size_calculator_test.dart`.
- **Files changed**:
  - `mobile/lib/core/storage/evidence_storage_size_calculator.dart`
  - `mobile/test/unit/evidence_storage_size_calculator_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 2 unit tests passed, 147 total tests passed.
- **Commit**: Pending

### Contribution 24
- **Title**: Add TaskSearchIndex helper
- **Category**: Features / Performance & Search
- **Problem**: Full-text searching across large collections of action packets required scanning string fields on every keystroke without token caching.
- **Solution**: Implemented `TaskSearchIndex` in `mobile/lib/features/home/task_search_index.dart` providing inverted token indexing and matching score calculations. Added unit test suite `task_search_index_test.dart`.
- **Files changed**:
  - `mobile/lib/features/home/task_search_index.dart`
  - `mobile/test/unit/task_search_index_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 3 unit tests passed, 150 total tests passed.
- **Commit**: Pending

### Contribution 25
- **Title**: Add TaskSortingNotifier for HomeQueueScreen
- **Category**: Features / State & Sorting
- **Problem**: Action packets in Home Queue were presented strictly in creation sequence without options to sort by priority severity, date, or title.
- **Solution**: Implemented `TaskSortingNotifier` supporting `TaskSortOption` enum modes (`dateNewest`, `dateOldest`, `priorityHighest`, `titleAZ`) with comparator functions and Riverpod provider support. Added unit test suite `task_sorting_notifier_test.dart`.
- **Files changed**:
  - `mobile/lib/features/home/task_sorting_notifier.dart`
  - `mobile/test/unit/task_sorting_notifier_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 3 unit tests passed, 153 total tests passed.
- **Commit**: Pending

### Contribution 26
- **Title**: Add TaskCategoryFilterSelector widget
- **Category**: Features / UI Components
- **Problem**: Category selection chips were rendered as ad-hoc inline horizontal scroll loops in screen files.
- **Solution**: Implemented reusable `TaskCategoryFilterSelector` in `mobile/lib/shared/widgets/task_category_filter_selector.dart` with choice chip styling and tap selection callbacks. Added widget test suite `task_category_filter_selector_test.dart`.
- **Files changed**:
  - `mobile/lib/shared/widgets/task_category_filter_selector.dart`
  - `mobile/test/unit/task_category_filter_selector_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 2 widget tests passed, 155 total tests passed.
- **Commit**: Pending

### Contribution 27
- **Title**: Add SyncOutboxStatusCard UI widget
- **Category**: Features / UI Components
- **Problem**: Outbox status stats (total, pending, syncing, synced, failed) were scattered across diagnostic modals without a dedicated summary card widget.
- **Solution**: Implemented `SyncOutboxStatusCard` in `mobile/lib/shared/widgets/sync_outbox_status_card.dart` displaying real-time queue counts and a manual "SYNC PENDING NOW" action button. Added widget test suite `sync_outbox_status_card_test.dart`.
- **Files changed**:
  - `mobile/lib/shared/widgets/sync_outbox_status_card.dart`
  - `mobile/test/unit/sync_outbox_status_card_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 2 widget tests passed, 157 total tests passed.
- **Commit**: Pending

### Contribution 28
- **Title**: Add EvidenceFileTypeValidator helper
- **Category**: Features / Storage & Validation
- **Problem**: File type validation for evidence attachments was hardcoded in multiple places without a centralized MIME type and extension registry.
- **Solution**: Implemented `EvidenceFileTypeValidator` in `mobile/lib/core/storage/evidence_file_type_validator.dart` verifying extension validity and resolving standard MIME types (`image/jpeg`, `audio/m4a`, `application/json`, etc.). Added unit test suite `evidence_file_type_validator_test.dart`.
- **Files changed**:
  - `mobile/lib/core/storage/evidence_file_type_validator.dart`
  - `mobile/test/unit/evidence_file_type_validator_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 3 unit tests passed, 160 total tests passed.
- **Commit**: Pending

### Contribution 29
- **Title**: Add TaskPriorityColorMapper utility
- **Category**: Features / Styling
- **Problem**: Priority colors and transparent background/border alpha calculations were duplicated across UI components and badge widgets.
- **Solution**: Implemented `TaskPriorityColorMapper` in `mobile/lib/app/task_priority_color_mapper.dart` providing centralized priority theme color mapping and alpha helper methods. Added unit test suite `task_priority_color_mapper_test.dart`.
- **Files changed**:
  - `mobile/lib/app/task_priority_color_mapper.dart`
  - `mobile/test/unit/task_priority_color_mapper_test.dart`
  - `CONTRIBUTIONS.md`
- **Tests performed**: `flutter analyze` clean (0 issues), 4 unit tests passed, 164 total tests passed.
- **Commit**: Pending
