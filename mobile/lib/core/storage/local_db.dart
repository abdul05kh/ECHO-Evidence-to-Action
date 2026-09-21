import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'local_db.g.dart';

// Evidence Table: Persists captured photos, voice notes, and text clips
class Evidences extends Table {
  TextColumn get id => text()();
  TextColumn get packetId => text().nullable()();
  TextColumn get type => text()(); // 'photo', 'voice', 'text'
  TextColumn get localUri => text()();
  TextColumn get thumbnailUri => text().nullable()();
  IntColumn get durationSec => integer().nullable()();
  TextColumn get transcriptExcerpt => text().nullable()();
  TextColumn get metadataJson => text().withDefault(const Constant('{}'))();
  DateTimeColumn get capturedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isClosure => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// Action Packets Table: Persists generated and approved structured work packets
class ActionPackets extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text().withDefault(const Constant('ws_default'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get status => text().withDefault(const Constant('draft'))(); // draft, processing, needs_review, ready, approved
  TextColumn get title => text()();
  TextColumn get category => text()(); // equipment, facility, electrical, plumbing, safety, other
  TextColumn get priority => text()(); // critical, high, medium, low
  TextColumn get summary => text()();
  TextColumn get payloadJson => text()(); // Full JSON of observations, inferences, checklist, etc.
  BoolColumn get requiresHumanApproval => boolean().withDefault(const Constant(true))();
  IntColumn get captureDurationMs => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Tasks Table: Persists approved active, completed, or reopened work orders
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text().withDefault(const Constant('ws_default'))();
  TextColumn get packetId => text()();
  TextColumn get status => text().withDefault(const Constant('approved'))(); // approved, assigned, in_progress, blocked, completed, reopened
  TextColumn get priority => text()();
  TextColumn get title => text()();
  TextColumn get summary => text()();
  TextColumn get assignedTo => text().nullable()();
  DateTimeColumn get dueAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Checklist Items Table
class ChecklistItems extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text()();
  IntColumn get position => integer()();
  TextColumn get textContent => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Task Events Table: Immutable audit trail
class TaskEvents extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text()();
  TextColumn get actorId => text().withDefault(const Constant('usr_operator'))();
  TextColumn get eventType => text()(); // created, approved, assigned, status_changed, checklist_updated, closure_added, reopened
  TextColumn get payloadJson => text().withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// Sync Outbox Table: For resilient offline sync
class SyncOutboxItems extends Table {
  TextColumn get id => text()();
  TextColumn get workspaceId => text().withDefault(const Constant('ws_default'))();
  TextColumn get operationType => text()(); // create_packet, approve_packet, create_task, transition_task, sync_evidence
  TextColumn get entityId => text()();
  TextColumn get idempotencyKey => text()();
  TextColumn get payloadJson => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, syncing, synced, failed
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Evidences,
  ActionPackets,
  Tasks,
  ChecklistItems,
  TaskEvents,
  SyncOutboxItems,
])
class EchoDatabase extends _$EchoDatabase {
  EchoDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'echo_local.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
