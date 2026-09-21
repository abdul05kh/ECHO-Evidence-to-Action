// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_db.dart';

// ignore_for_file: type=lint
class $EvidencesTable extends Evidences
    with TableInfo<$EvidencesTable, Evidence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvidencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _packetIdMeta =
      const VerificationMeta('packetId');
  @override
  late final GeneratedColumn<String> packetId = GeneratedColumn<String>(
      'packet_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localUriMeta =
      const VerificationMeta('localUri');
  @override
  late final GeneratedColumn<String> localUri = GeneratedColumn<String>(
      'local_uri', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _thumbnailUriMeta =
      const VerificationMeta('thumbnailUri');
  @override
  late final GeneratedColumn<String> thumbnailUri = GeneratedColumn<String>(
      'thumbnail_uri', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationSecMeta =
      const VerificationMeta('durationSec');
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
      'duration_sec', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _transcriptExcerptMeta =
      const VerificationMeta('transcriptExcerpt');
  @override
  late final GeneratedColumn<String> transcriptExcerpt =
      GeneratedColumn<String>('transcript_excerpt', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metadataJsonMeta =
      const VerificationMeta('metadataJson');
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
      'metadata_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _capturedAtMeta =
      const VerificationMeta('capturedAt');
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
      'captured_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isClosureMeta =
      const VerificationMeta('isClosure');
  @override
  late final GeneratedColumn<bool> isClosure = GeneratedColumn<bool>(
      'is_closure', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_closure" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        packetId,
        type,
        localUri,
        thumbnailUri,
        durationSec,
        transcriptExcerpt,
        metadataJson,
        capturedAt,
        isClosure
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evidences';
  @override
  VerificationContext validateIntegrity(Insertable<Evidence> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('packet_id')) {
      context.handle(_packetIdMeta,
          packetId.isAcceptableOrUnknown(data['packet_id']!, _packetIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('local_uri')) {
      context.handle(_localUriMeta,
          localUri.isAcceptableOrUnknown(data['local_uri']!, _localUriMeta));
    } else if (isInserting) {
      context.missing(_localUriMeta);
    }
    if (data.containsKey('thumbnail_uri')) {
      context.handle(
          _thumbnailUriMeta,
          thumbnailUri.isAcceptableOrUnknown(
              data['thumbnail_uri']!, _thumbnailUriMeta));
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
          _durationSecMeta,
          durationSec.isAcceptableOrUnknown(
              data['duration_sec']!, _durationSecMeta));
    }
    if (data.containsKey('transcript_excerpt')) {
      context.handle(
          _transcriptExcerptMeta,
          transcriptExcerpt.isAcceptableOrUnknown(
              data['transcript_excerpt']!, _transcriptExcerptMeta));
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
          _metadataJsonMeta,
          metadataJson.isAcceptableOrUnknown(
              data['metadata_json']!, _metadataJsonMeta));
    }
    if (data.containsKey('captured_at')) {
      context.handle(
          _capturedAtMeta,
          capturedAt.isAcceptableOrUnknown(
              data['captured_at']!, _capturedAtMeta));
    }
    if (data.containsKey('is_closure')) {
      context.handle(_isClosureMeta,
          isClosure.isAcceptableOrUnknown(data['is_closure']!, _isClosureMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Evidence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Evidence(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      packetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}packet_id']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      localUri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_uri'])!,
      thumbnailUri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}thumbnail_uri']),
      durationSec: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_sec']),
      transcriptExcerpt: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}transcript_excerpt']),
      metadataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata_json'])!,
      capturedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}captured_at'])!,
      isClosure: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_closure'])!,
    );
  }

  @override
  $EvidencesTable createAlias(String alias) {
    return $EvidencesTable(attachedDatabase, alias);
  }
}

class Evidence extends DataClass implements Insertable<Evidence> {
  final String id;
  final String? packetId;
  final String type;
  final String localUri;
  final String? thumbnailUri;
  final int? durationSec;
  final String? transcriptExcerpt;
  final String metadataJson;
  final DateTime capturedAt;
  final bool isClosure;
  const Evidence(
      {required this.id,
      this.packetId,
      required this.type,
      required this.localUri,
      this.thumbnailUri,
      this.durationSec,
      this.transcriptExcerpt,
      required this.metadataJson,
      required this.capturedAt,
      required this.isClosure});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || packetId != null) {
      map['packet_id'] = Variable<String>(packetId);
    }
    map['type'] = Variable<String>(type);
    map['local_uri'] = Variable<String>(localUri);
    if (!nullToAbsent || thumbnailUri != null) {
      map['thumbnail_uri'] = Variable<String>(thumbnailUri);
    }
    if (!nullToAbsent || durationSec != null) {
      map['duration_sec'] = Variable<int>(durationSec);
    }
    if (!nullToAbsent || transcriptExcerpt != null) {
      map['transcript_excerpt'] = Variable<String>(transcriptExcerpt);
    }
    map['metadata_json'] = Variable<String>(metadataJson);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    map['is_closure'] = Variable<bool>(isClosure);
    return map;
  }

  EvidencesCompanion toCompanion(bool nullToAbsent) {
    return EvidencesCompanion(
      id: Value(id),
      packetId: packetId == null && nullToAbsent
          ? const Value.absent()
          : Value(packetId),
      type: Value(type),
      localUri: Value(localUri),
      thumbnailUri: thumbnailUri == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailUri),
      durationSec: durationSec == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSec),
      transcriptExcerpt: transcriptExcerpt == null && nullToAbsent
          ? const Value.absent()
          : Value(transcriptExcerpt),
      metadataJson: Value(metadataJson),
      capturedAt: Value(capturedAt),
      isClosure: Value(isClosure),
    );
  }

  factory Evidence.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Evidence(
      id: serializer.fromJson<String>(json['id']),
      packetId: serializer.fromJson<String?>(json['packetId']),
      type: serializer.fromJson<String>(json['type']),
      localUri: serializer.fromJson<String>(json['localUri']),
      thumbnailUri: serializer.fromJson<String?>(json['thumbnailUri']),
      durationSec: serializer.fromJson<int?>(json['durationSec']),
      transcriptExcerpt:
          serializer.fromJson<String?>(json['transcriptExcerpt']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      isClosure: serializer.fromJson<bool>(json['isClosure']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'packetId': serializer.toJson<String?>(packetId),
      'type': serializer.toJson<String>(type),
      'localUri': serializer.toJson<String>(localUri),
      'thumbnailUri': serializer.toJson<String?>(thumbnailUri),
      'durationSec': serializer.toJson<int?>(durationSec),
      'transcriptExcerpt': serializer.toJson<String?>(transcriptExcerpt),
      'metadataJson': serializer.toJson<String>(metadataJson),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'isClosure': serializer.toJson<bool>(isClosure),
    };
  }

  Evidence copyWith(
          {String? id,
          Value<String?> packetId = const Value.absent(),
          String? type,
          String? localUri,
          Value<String?> thumbnailUri = const Value.absent(),
          Value<int?> durationSec = const Value.absent(),
          Value<String?> transcriptExcerpt = const Value.absent(),
          String? metadataJson,
          DateTime? capturedAt,
          bool? isClosure}) =>
      Evidence(
        id: id ?? this.id,
        packetId: packetId.present ? packetId.value : this.packetId,
        type: type ?? this.type,
        localUri: localUri ?? this.localUri,
        thumbnailUri:
            thumbnailUri.present ? thumbnailUri.value : this.thumbnailUri,
        durationSec: durationSec.present ? durationSec.value : this.durationSec,
        transcriptExcerpt: transcriptExcerpt.present
            ? transcriptExcerpt.value
            : this.transcriptExcerpt,
        metadataJson: metadataJson ?? this.metadataJson,
        capturedAt: capturedAt ?? this.capturedAt,
        isClosure: isClosure ?? this.isClosure,
      );
  Evidence copyWithCompanion(EvidencesCompanion data) {
    return Evidence(
      id: data.id.present ? data.id.value : this.id,
      packetId: data.packetId.present ? data.packetId.value : this.packetId,
      type: data.type.present ? data.type.value : this.type,
      localUri: data.localUri.present ? data.localUri.value : this.localUri,
      thumbnailUri: data.thumbnailUri.present
          ? data.thumbnailUri.value
          : this.thumbnailUri,
      durationSec:
          data.durationSec.present ? data.durationSec.value : this.durationSec,
      transcriptExcerpt: data.transcriptExcerpt.present
          ? data.transcriptExcerpt.value
          : this.transcriptExcerpt,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      capturedAt:
          data.capturedAt.present ? data.capturedAt.value : this.capturedAt,
      isClosure: data.isClosure.present ? data.isClosure.value : this.isClosure,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Evidence(')
          ..write('id: $id, ')
          ..write('packetId: $packetId, ')
          ..write('type: $type, ')
          ..write('localUri: $localUri, ')
          ..write('thumbnailUri: $thumbnailUri, ')
          ..write('durationSec: $durationSec, ')
          ..write('transcriptExcerpt: $transcriptExcerpt, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('isClosure: $isClosure')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, packetId, type, localUri, thumbnailUri,
      durationSec, transcriptExcerpt, metadataJson, capturedAt, isClosure);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Evidence &&
          other.id == this.id &&
          other.packetId == this.packetId &&
          other.type == this.type &&
          other.localUri == this.localUri &&
          other.thumbnailUri == this.thumbnailUri &&
          other.durationSec == this.durationSec &&
          other.transcriptExcerpt == this.transcriptExcerpt &&
          other.metadataJson == this.metadataJson &&
          other.capturedAt == this.capturedAt &&
          other.isClosure == this.isClosure);
}

class EvidencesCompanion extends UpdateCompanion<Evidence> {
  final Value<String> id;
  final Value<String?> packetId;
  final Value<String> type;
  final Value<String> localUri;
  final Value<String?> thumbnailUri;
  final Value<int?> durationSec;
  final Value<String?> transcriptExcerpt;
  final Value<String> metadataJson;
  final Value<DateTime> capturedAt;
  final Value<bool> isClosure;
  final Value<int> rowid;
  const EvidencesCompanion({
    this.id = const Value.absent(),
    this.packetId = const Value.absent(),
    this.type = const Value.absent(),
    this.localUri = const Value.absent(),
    this.thumbnailUri = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.transcriptExcerpt = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.isClosure = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EvidencesCompanion.insert({
    required String id,
    this.packetId = const Value.absent(),
    required String type,
    required String localUri,
    this.thumbnailUri = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.transcriptExcerpt = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.isClosure = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        localUri = Value(localUri);
  static Insertable<Evidence> custom({
    Expression<String>? id,
    Expression<String>? packetId,
    Expression<String>? type,
    Expression<String>? localUri,
    Expression<String>? thumbnailUri,
    Expression<int>? durationSec,
    Expression<String>? transcriptExcerpt,
    Expression<String>? metadataJson,
    Expression<DateTime>? capturedAt,
    Expression<bool>? isClosure,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packetId != null) 'packet_id': packetId,
      if (type != null) 'type': type,
      if (localUri != null) 'local_uri': localUri,
      if (thumbnailUri != null) 'thumbnail_uri': thumbnailUri,
      if (durationSec != null) 'duration_sec': durationSec,
      if (transcriptExcerpt != null) 'transcript_excerpt': transcriptExcerpt,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (isClosure != null) 'is_closure': isClosure,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EvidencesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? packetId,
      Value<String>? type,
      Value<String>? localUri,
      Value<String?>? thumbnailUri,
      Value<int?>? durationSec,
      Value<String?>? transcriptExcerpt,
      Value<String>? metadataJson,
      Value<DateTime>? capturedAt,
      Value<bool>? isClosure,
      Value<int>? rowid}) {
    return EvidencesCompanion(
      id: id ?? this.id,
      packetId: packetId ?? this.packetId,
      type: type ?? this.type,
      localUri: localUri ?? this.localUri,
      thumbnailUri: thumbnailUri ?? this.thumbnailUri,
      durationSec: durationSec ?? this.durationSec,
      transcriptExcerpt: transcriptExcerpt ?? this.transcriptExcerpt,
      metadataJson: metadataJson ?? this.metadataJson,
      capturedAt: capturedAt ?? this.capturedAt,
      isClosure: isClosure ?? this.isClosure,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (packetId.present) {
      map['packet_id'] = Variable<String>(packetId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (localUri.present) {
      map['local_uri'] = Variable<String>(localUri.value);
    }
    if (thumbnailUri.present) {
      map['thumbnail_uri'] = Variable<String>(thumbnailUri.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (transcriptExcerpt.present) {
      map['transcript_excerpt'] = Variable<String>(transcriptExcerpt.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (isClosure.present) {
      map['is_closure'] = Variable<bool>(isClosure.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvidencesCompanion(')
          ..write('id: $id, ')
          ..write('packetId: $packetId, ')
          ..write('type: $type, ')
          ..write('localUri: $localUri, ')
          ..write('thumbnailUri: $thumbnailUri, ')
          ..write('durationSec: $durationSec, ')
          ..write('transcriptExcerpt: $transcriptExcerpt, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('isClosure: $isClosure, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActionPacketsTable extends ActionPackets
    with TableInfo<$ActionPacketsTable, ActionPacket> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActionPacketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workspaceIdMeta =
      const VerificationMeta('workspaceId');
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
      'workspace_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('ws_default'));
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _requiresHumanApprovalMeta =
      const VerificationMeta('requiresHumanApproval');
  @override
  late final GeneratedColumn<bool> requiresHumanApproval =
      GeneratedColumn<bool>('requires_human_approval', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("requires_human_approval" IN (0, 1))'),
          defaultValue: const Constant(true));
  static const VerificationMeta _captureDurationMsMeta =
      const VerificationMeta('captureDurationMs');
  @override
  late final GeneratedColumn<int> captureDurationMs = GeneratedColumn<int>(
      'capture_duration_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workspaceId,
        version,
        status,
        title,
        category,
        priority,
        summary,
        payloadJson,
        requiresHumanApproval,
        captureDurationMs,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'action_packets';
  @override
  VerificationContext validateIntegrity(Insertable<ActionPacket> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
          _workspaceIdMeta,
          workspaceId.isAcceptableOrUnknown(
              data['workspace_id']!, _workspaceIdMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('requires_human_approval')) {
      context.handle(
          _requiresHumanApprovalMeta,
          requiresHumanApproval.isAcceptableOrUnknown(
              data['requires_human_approval']!, _requiresHumanApprovalMeta));
    }
    if (data.containsKey('capture_duration_ms')) {
      context.handle(
          _captureDurationMsMeta,
          captureDurationMs.isAcceptableOrUnknown(
              data['capture_duration_ms']!, _captureDurationMsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActionPacket map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActionPacket(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      workspaceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workspace_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      requiresHumanApproval: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}requires_human_approval'])!,
      captureDurationMs: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}capture_duration_ms']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ActionPacketsTable createAlias(String alias) {
    return $ActionPacketsTable(attachedDatabase, alias);
  }
}

class ActionPacket extends DataClass implements Insertable<ActionPacket> {
  final String id;
  final String workspaceId;
  final int version;
  final String status;
  final String title;
  final String category;
  final String priority;
  final String summary;
  final String payloadJson;
  final bool requiresHumanApproval;
  final int? captureDurationMs;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ActionPacket(
      {required this.id,
      required this.workspaceId,
      required this.version,
      required this.status,
      required this.title,
      required this.category,
      required this.priority,
      required this.summary,
      required this.payloadJson,
      required this.requiresHumanApproval,
      this.captureDurationMs,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['version'] = Variable<int>(version);
    map['status'] = Variable<String>(status);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['priority'] = Variable<String>(priority);
    map['summary'] = Variable<String>(summary);
    map['payload_json'] = Variable<String>(payloadJson);
    map['requires_human_approval'] = Variable<bool>(requiresHumanApproval);
    if (!nullToAbsent || captureDurationMs != null) {
      map['capture_duration_ms'] = Variable<int>(captureDurationMs);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ActionPacketsCompanion toCompanion(bool nullToAbsent) {
    return ActionPacketsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      version: Value(version),
      status: Value(status),
      title: Value(title),
      category: Value(category),
      priority: Value(priority),
      summary: Value(summary),
      payloadJson: Value(payloadJson),
      requiresHumanApproval: Value(requiresHumanApproval),
      captureDurationMs: captureDurationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(captureDurationMs),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ActionPacket.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActionPacket(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      version: serializer.fromJson<int>(json['version']),
      status: serializer.fromJson<String>(json['status']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      priority: serializer.fromJson<String>(json['priority']),
      summary: serializer.fromJson<String>(json['summary']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      requiresHumanApproval:
          serializer.fromJson<bool>(json['requiresHumanApproval']),
      captureDurationMs: serializer.fromJson<int?>(json['captureDurationMs']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'version': serializer.toJson<int>(version),
      'status': serializer.toJson<String>(status),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'priority': serializer.toJson<String>(priority),
      'summary': serializer.toJson<String>(summary),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'requiresHumanApproval': serializer.toJson<bool>(requiresHumanApproval),
      'captureDurationMs': serializer.toJson<int?>(captureDurationMs),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ActionPacket copyWith(
          {String? id,
          String? workspaceId,
          int? version,
          String? status,
          String? title,
          String? category,
          String? priority,
          String? summary,
          String? payloadJson,
          bool? requiresHumanApproval,
          Value<int?> captureDurationMs = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ActionPacket(
        id: id ?? this.id,
        workspaceId: workspaceId ?? this.workspaceId,
        version: version ?? this.version,
        status: status ?? this.status,
        title: title ?? this.title,
        category: category ?? this.category,
        priority: priority ?? this.priority,
        summary: summary ?? this.summary,
        payloadJson: payloadJson ?? this.payloadJson,
        requiresHumanApproval:
            requiresHumanApproval ?? this.requiresHumanApproval,
        captureDurationMs: captureDurationMs.present
            ? captureDurationMs.value
            : this.captureDurationMs,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ActionPacket copyWithCompanion(ActionPacketsCompanion data) {
    return ActionPacket(
      id: data.id.present ? data.id.value : this.id,
      workspaceId:
          data.workspaceId.present ? data.workspaceId.value : this.workspaceId,
      version: data.version.present ? data.version.value : this.version,
      status: data.status.present ? data.status.value : this.status,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      priority: data.priority.present ? data.priority.value : this.priority,
      summary: data.summary.present ? data.summary.value : this.summary,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      requiresHumanApproval: data.requiresHumanApproval.present
          ? data.requiresHumanApproval.value
          : this.requiresHumanApproval,
      captureDurationMs: data.captureDurationMs.present
          ? data.captureDurationMs.value
          : this.captureDurationMs,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActionPacket(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('status: $status, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('summary: $summary, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('requiresHumanApproval: $requiresHumanApproval, ')
          ..write('captureDurationMs: $captureDurationMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      workspaceId,
      version,
      status,
      title,
      category,
      priority,
      summary,
      payloadJson,
      requiresHumanApproval,
      captureDurationMs,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActionPacket &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.version == this.version &&
          other.status == this.status &&
          other.title == this.title &&
          other.category == this.category &&
          other.priority == this.priority &&
          other.summary == this.summary &&
          other.payloadJson == this.payloadJson &&
          other.requiresHumanApproval == this.requiresHumanApproval &&
          other.captureDurationMs == this.captureDurationMs &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ActionPacketsCompanion extends UpdateCompanion<ActionPacket> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<int> version;
  final Value<String> status;
  final Value<String> title;
  final Value<String> category;
  final Value<String> priority;
  final Value<String> summary;
  final Value<String> payloadJson;
  final Value<bool> requiresHumanApproval;
  final Value<int?> captureDurationMs;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ActionPacketsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.status = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.priority = const Value.absent(),
    this.summary = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.requiresHumanApproval = const Value.absent(),
    this.captureDurationMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActionPacketsCompanion.insert({
    required String id,
    this.workspaceId = const Value.absent(),
    this.version = const Value.absent(),
    this.status = const Value.absent(),
    required String title,
    required String category,
    required String priority,
    required String summary,
    required String payloadJson,
    this.requiresHumanApproval = const Value.absent(),
    this.captureDurationMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        category = Value(category),
        priority = Value(priority),
        summary = Value(summary),
        payloadJson = Value(payloadJson);
  static Insertable<ActionPacket> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<int>? version,
    Expression<String>? status,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? priority,
    Expression<String>? summary,
    Expression<String>? payloadJson,
    Expression<bool>? requiresHumanApproval,
    Expression<int>? captureDurationMs,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (version != null) 'version': version,
      if (status != null) 'status': status,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (priority != null) 'priority': priority,
      if (summary != null) 'summary': summary,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (requiresHumanApproval != null)
        'requires_human_approval': requiresHumanApproval,
      if (captureDurationMs != null) 'capture_duration_ms': captureDurationMs,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActionPacketsCompanion copyWith(
      {Value<String>? id,
      Value<String>? workspaceId,
      Value<int>? version,
      Value<String>? status,
      Value<String>? title,
      Value<String>? category,
      Value<String>? priority,
      Value<String>? summary,
      Value<String>? payloadJson,
      Value<bool>? requiresHumanApproval,
      Value<int?>? captureDurationMs,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ActionPacketsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      status: status ?? this.status,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      summary: summary ?? this.summary,
      payloadJson: payloadJson ?? this.payloadJson,
      requiresHumanApproval:
          requiresHumanApproval ?? this.requiresHumanApproval,
      captureDurationMs: captureDurationMs ?? this.captureDurationMs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (requiresHumanApproval.present) {
      map['requires_human_approval'] =
          Variable<bool>(requiresHumanApproval.value);
    }
    if (captureDurationMs.present) {
      map['capture_duration_ms'] = Variable<int>(captureDurationMs.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActionPacketsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('version: $version, ')
          ..write('status: $status, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('priority: $priority, ')
          ..write('summary: $summary, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('requiresHumanApproval: $requiresHumanApproval, ')
          ..write('captureDurationMs: $captureDurationMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workspaceIdMeta =
      const VerificationMeta('workspaceId');
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
      'workspace_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('ws_default'));
  static const VerificationMeta _packetIdMeta =
      const VerificationMeta('packetId');
  @override
  late final GeneratedColumn<String> packetId = GeneratedColumn<String>(
      'packet_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('approved'));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assignedToMeta =
      const VerificationMeta('assignedTo');
  @override
  late final GeneratedColumn<String> assignedTo = GeneratedColumn<String>(
      'assigned_to', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
      'due_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workspaceId,
        packetId,
        status,
        priority,
        title,
        summary,
        assignedTo,
        dueAt,
        completedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
          _workspaceIdMeta,
          workspaceId.isAcceptableOrUnknown(
              data['workspace_id']!, _workspaceIdMeta));
    }
    if (data.containsKey('packet_id')) {
      context.handle(_packetIdMeta,
          packetId.isAcceptableOrUnknown(data['packet_id']!, _packetIdMeta));
    } else if (isInserting) {
      context.missing(_packetIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('assigned_to')) {
      context.handle(
          _assignedToMeta,
          assignedTo.isAcceptableOrUnknown(
              data['assigned_to']!, _assignedToMeta));
    }
    if (data.containsKey('due_at')) {
      context.handle(
          _dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      workspaceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workspace_id'])!,
      packetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}packet_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary'])!,
      assignedTo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}assigned_to']),
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_at']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String workspaceId;
  final String packetId;
  final String status;
  final String priority;
  final String title;
  final String summary;
  final String? assignedTo;
  final DateTime? dueAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Task(
      {required this.id,
      required this.workspaceId,
      required this.packetId,
      required this.status,
      required this.priority,
      required this.title,
      required this.summary,
      this.assignedTo,
      this.dueAt,
      this.completedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['packet_id'] = Variable<String>(packetId);
    map['status'] = Variable<String>(status);
    map['priority'] = Variable<String>(priority);
    map['title'] = Variable<String>(title);
    map['summary'] = Variable<String>(summary);
    if (!nullToAbsent || assignedTo != null) {
      map['assigned_to'] = Variable<String>(assignedTo);
    }
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      packetId: Value(packetId),
      status: Value(status),
      priority: Value(priority),
      title: Value(title),
      summary: Value(summary),
      assignedTo: assignedTo == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedTo),
      dueAt:
          dueAt == null && nullToAbsent ? const Value.absent() : Value(dueAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      packetId: serializer.fromJson<String>(json['packetId']),
      status: serializer.fromJson<String>(json['status']),
      priority: serializer.fromJson<String>(json['priority']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String>(json['summary']),
      assignedTo: serializer.fromJson<String?>(json['assignedTo']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'packetId': serializer.toJson<String>(packetId),
      'status': serializer.toJson<String>(status),
      'priority': serializer.toJson<String>(priority),
      'title': serializer.toJson<String>(title),
      'summary': serializer.toJson<String>(summary),
      'assignedTo': serializer.toJson<String?>(assignedTo),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Task copyWith(
          {String? id,
          String? workspaceId,
          String? packetId,
          String? status,
          String? priority,
          String? title,
          String? summary,
          Value<String?> assignedTo = const Value.absent(),
          Value<DateTime?> dueAt = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Task(
        id: id ?? this.id,
        workspaceId: workspaceId ?? this.workspaceId,
        packetId: packetId ?? this.packetId,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        title: title ?? this.title,
        summary: summary ?? this.summary,
        assignedTo: assignedTo.present ? assignedTo.value : this.assignedTo,
        dueAt: dueAt.present ? dueAt.value : this.dueAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      workspaceId:
          data.workspaceId.present ? data.workspaceId.value : this.workspaceId,
      packetId: data.packetId.present ? data.packetId.value : this.packetId,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      title: data.title.present ? data.title.value : this.title,
      summary: data.summary.present ? data.summary.value : this.summary,
      assignedTo:
          data.assignedTo.present ? data.assignedTo.value : this.assignedTo,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('packetId: $packetId, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('assignedTo: $assignedTo, ')
          ..write('dueAt: $dueAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workspaceId, packetId, status, priority,
      title, summary, assignedTo, dueAt, completedAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.packetId == this.packetId &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.title == this.title &&
          other.summary == this.summary &&
          other.assignedTo == this.assignedTo &&
          other.dueAt == this.dueAt &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<String> packetId;
  final Value<String> status;
  final Value<String> priority;
  final Value<String> title;
  final Value<String> summary;
  final Value<String?> assignedTo;
  final Value<DateTime?> dueAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.packetId = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
    this.assignedTo = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    this.workspaceId = const Value.absent(),
    required String packetId,
    this.status = const Value.absent(),
    required String priority,
    required String title,
    required String summary,
    this.assignedTo = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        packetId = Value(packetId),
        priority = Value(priority),
        title = Value(title),
        summary = Value(summary);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<String>? packetId,
    Expression<String>? status,
    Expression<String>? priority,
    Expression<String>? title,
    Expression<String>? summary,
    Expression<String>? assignedTo,
    Expression<DateTime>? dueAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (packetId != null) 'packet_id': packetId,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (assignedTo != null) 'assigned_to': assignedTo,
      if (dueAt != null) 'due_at': dueAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith(
      {Value<String>? id,
      Value<String>? workspaceId,
      Value<String>? packetId,
      Value<String>? status,
      Value<String>? priority,
      Value<String>? title,
      Value<String>? summary,
      Value<String?>? assignedTo,
      Value<DateTime?>? dueAt,
      Value<DateTime?>? completedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TasksCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      packetId: packetId ?? this.packetId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      assignedTo: assignedTo ?? this.assignedTo,
      dueAt: dueAt ?? this.dueAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (packetId.present) {
      map['packet_id'] = Variable<String>(packetId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (assignedTo.present) {
      map['assigned_to'] = Variable<String>(assignedTo.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('packetId: $packetId, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('assignedTo: $assignedTo, ')
          ..write('dueAt: $dueAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChecklistItemsTable extends ChecklistItems
    with TableInfo<$ChecklistItemsTable, ChecklistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _textContentMeta =
      const VerificationMeta('textContent');
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
      'text_content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, taskId, position, textContent, isCompleted, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_items';
  @override
  VerificationContext validateIntegrity(Insertable<ChecklistItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('text_content')) {
      context.handle(
          _textContentMeta,
          textContent.isAcceptableOrUnknown(
              data['text_content']!, _textContentMeta));
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      textContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_content'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $ChecklistItemsTable createAlias(String alias) {
    return $ChecklistItemsTable(attachedDatabase, alias);
  }
}

class ChecklistItem extends DataClass implements Insertable<ChecklistItem> {
  final String id;
  final String taskId;
  final int position;
  final String textContent;
  final bool isCompleted;
  final DateTime? completedAt;
  const ChecklistItem(
      {required this.id,
      required this.taskId,
      required this.position,
      required this.textContent,
      required this.isCompleted,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['position'] = Variable<int>(position);
    map['text_content'] = Variable<String>(textContent);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  ChecklistItemsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistItemsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      position: Value(position),
      textContent: Value(textContent),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory ChecklistItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistItem(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      position: serializer.fromJson<int>(json['position']),
      textContent: serializer.fromJson<String>(json['textContent']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'position': serializer.toJson<int>(position),
      'textContent': serializer.toJson<String>(textContent),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  ChecklistItem copyWith(
          {String? id,
          String? taskId,
          int? position,
          String? textContent,
          bool? isCompleted,
          Value<DateTime?> completedAt = const Value.absent()}) =>
      ChecklistItem(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        position: position ?? this.position,
        textContent: textContent ?? this.textContent,
        isCompleted: isCompleted ?? this.isCompleted,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  ChecklistItem copyWithCompanion(ChecklistItemsCompanion data) {
    return ChecklistItem(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      position: data.position.present ? data.position.value : this.position,
      textContent:
          data.textContent.present ? data.textContent.value : this.textContent,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItem(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('position: $position, ')
          ..write('textContent: $textContent, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, position, textContent, isCompleted, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistItem &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.position == this.position &&
          other.textContent == this.textContent &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt);
}

class ChecklistItemsCompanion extends UpdateCompanion<ChecklistItem> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<int> position;
  final Value<String> textContent;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const ChecklistItemsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.position = const Value.absent(),
    this.textContent = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistItemsCompanion.insert({
    required String id,
    required String taskId,
    required int position,
    required String textContent,
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskId = Value(taskId),
        position = Value(position),
        textContent = Value(textContent);
  static Insertable<ChecklistItem> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<int>? position,
    Expression<String>? textContent,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (position != null) 'position': position,
      if (textContent != null) 'text_content': textContent,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<int>? position,
      Value<String>? textContent,
      Value<bool>? isCompleted,
      Value<DateTime?>? completedAt,
      Value<int>? rowid}) {
    return ChecklistItemsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      position: position ?? this.position,
      textContent: textContent ?? this.textContent,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (textContent.present) {
      map['text_content'] = Variable<String>(textContent.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('position: $position, ')
          ..write('textContent: $textContent, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskEventsTable extends TaskEvents
    with TableInfo<$TaskEventsTable, TaskEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actorIdMeta =
      const VerificationMeta('actorId');
  @override
  late final GeneratedColumn<String> actorId = GeneratedColumn<String>(
      'actor_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('usr_operator'));
  static const VerificationMeta _eventTypeMeta =
      const VerificationMeta('eventType');
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
      'event_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, taskId, actorId, eventType, payloadJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_events';
  @override
  VerificationContext validateIntegrity(Insertable<TaskEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('actor_id')) {
      context.handle(_actorIdMeta,
          actorId.isAcceptableOrUnknown(data['actor_id']!, _actorIdMeta));
    }
    if (data.containsKey('event_type')) {
      context.handle(_eventTypeMeta,
          eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta));
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id'])!,
      actorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actor_id'])!,
      eventType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_type'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TaskEventsTable createAlias(String alias) {
    return $TaskEventsTable(attachedDatabase, alias);
  }
}

class TaskEvent extends DataClass implements Insertable<TaskEvent> {
  final String id;
  final String taskId;
  final String actorId;
  final String eventType;
  final String payloadJson;
  final DateTime createdAt;
  const TaskEvent(
      {required this.id,
      required this.taskId,
      required this.actorId,
      required this.eventType,
      required this.payloadJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['actor_id'] = Variable<String>(actorId);
    map['event_type'] = Variable<String>(eventType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaskEventsCompanion toCompanion(bool nullToAbsent) {
    return TaskEventsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      actorId: Value(actorId),
      eventType: Value(eventType),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
    );
  }

  factory TaskEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskEvent(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      actorId: serializer.fromJson<String>(json['actorId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'actorId': serializer.toJson<String>(actorId),
      'eventType': serializer.toJson<String>(eventType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaskEvent copyWith(
          {String? id,
          String? taskId,
          String? actorId,
          String? eventType,
          String? payloadJson,
          DateTime? createdAt}) =>
      TaskEvent(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        actorId: actorId ?? this.actorId,
        eventType: eventType ?? this.eventType,
        payloadJson: payloadJson ?? this.payloadJson,
        createdAt: createdAt ?? this.createdAt,
      );
  TaskEvent copyWithCompanion(TaskEventsCompanion data) {
    return TaskEvent(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      actorId: data.actorId.present ? data.actorId.value : this.actorId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskEvent(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('actorId: $actorId, ')
          ..write('eventType: $eventType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, actorId, eventType, payloadJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskEvent &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.actorId == this.actorId &&
          other.eventType == this.eventType &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt);
}

class TaskEventsCompanion extends UpdateCompanion<TaskEvent> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> actorId;
  final Value<String> eventType;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TaskEventsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.actorId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskEventsCompanion.insert({
    required String id,
    required String taskId,
    this.actorId = const Value.absent(),
    required String eventType,
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        taskId = Value(taskId),
        eventType = Value(eventType);
  static Insertable<TaskEvent> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? actorId,
    Expression<String>? eventType,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (actorId != null) 'actor_id': actorId,
      if (eventType != null) 'event_type': eventType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? taskId,
      Value<String>? actorId,
      Value<String>? eventType,
      Value<String>? payloadJson,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return TaskEventsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      actorId: actorId ?? this.actorId,
      eventType: eventType ?? this.eventType,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (actorId.present) {
      map['actor_id'] = Variable<String>(actorId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskEventsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('actorId: $actorId, ')
          ..write('eventType: $eventType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxItemsTable extends SyncOutboxItems
    with TableInfo<$SyncOutboxItemsTable, SyncOutboxItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workspaceIdMeta =
      const VerificationMeta('workspaceId');
  @override
  late final GeneratedColumn<String> workspaceId = GeneratedColumn<String>(
      'workspace_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('ws_default'));
  static const VerificationMeta _operationTypeMeta =
      const VerificationMeta('operationType');
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
      'operation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idempotencyKeyMeta =
      const VerificationMeta('idempotencyKey');
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
      'idempotency_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _nextAttemptAtMeta =
      const VerificationMeta('nextAttemptAt');
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>('next_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workspaceId,
        operationType,
        entityId,
        idempotencyKey,
        payloadJson,
        status,
        retryCount,
        nextAttemptAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox_items';
  @override
  VerificationContext validateIntegrity(Insertable<SyncOutboxItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workspace_id')) {
      context.handle(
          _workspaceIdMeta,
          workspaceId.isAcceptableOrUnknown(
              data['workspace_id']!, _workspaceIdMeta));
    }
    if (data.containsKey('operation_type')) {
      context.handle(
          _operationTypeMeta,
          operationType.isAcceptableOrUnknown(
              data['operation_type']!, _operationTypeMeta));
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
          _idempotencyKeyMeta,
          idempotencyKey.isAcceptableOrUnknown(
              data['idempotency_key']!, _idempotencyKeyMeta));
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
          _nextAttemptAtMeta,
          nextAttemptAt.isAcceptableOrUnknown(
              data['next_attempt_at']!, _nextAttemptAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOutboxItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      workspaceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workspace_id'])!,
      operationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      idempotencyKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}idempotency_key'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_attempt_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncOutboxItemsTable createAlias(String alias) {
    return $SyncOutboxItemsTable(attachedDatabase, alias);
  }
}

class SyncOutboxItem extends DataClass implements Insertable<SyncOutboxItem> {
  final String id;
  final String workspaceId;
  final String operationType;
  final String entityId;
  final String idempotencyKey;
  final String payloadJson;
  final String status;
  final int retryCount;
  final DateTime? nextAttemptAt;
  final DateTime createdAt;
  const SyncOutboxItem(
      {required this.id,
      required this.workspaceId,
      required this.operationType,
      required this.entityId,
      required this.idempotencyKey,
      required this.payloadJson,
      required this.status,
      required this.retryCount,
      this.nextAttemptAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workspace_id'] = Variable<String>(workspaceId);
    map['operation_type'] = Variable<String>(operationType);
    map['entity_id'] = Variable<String>(entityId);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['payload_json'] = Variable<String>(payloadJson);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncOutboxItemsCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxItemsCompanion(
      id: Value(id),
      workspaceId: Value(workspaceId),
      operationType: Value(operationType),
      entityId: Value(entityId),
      idempotencyKey: Value(idempotencyKey),
      payloadJson: Value(payloadJson),
      status: Value(status),
      retryCount: Value(retryCount),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      createdAt: Value(createdAt),
    );
  }

  factory SyncOutboxItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxItem(
      id: serializer.fromJson<String>(json['id']),
      workspaceId: serializer.fromJson<String>(json['workspaceId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workspaceId': serializer.toJson<String>(workspaceId),
      'operationType': serializer.toJson<String>(operationType),
      'entityId': serializer.toJson<String>(entityId),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncOutboxItem copyWith(
          {String? id,
          String? workspaceId,
          String? operationType,
          String? entityId,
          String? idempotencyKey,
          String? payloadJson,
          String? status,
          int? retryCount,
          Value<DateTime?> nextAttemptAt = const Value.absent(),
          DateTime? createdAt}) =>
      SyncOutboxItem(
        id: id ?? this.id,
        workspaceId: workspaceId ?? this.workspaceId,
        operationType: operationType ?? this.operationType,
        entityId: entityId ?? this.entityId,
        idempotencyKey: idempotencyKey ?? this.idempotencyKey,
        payloadJson: payloadJson ?? this.payloadJson,
        status: status ?? this.status,
        retryCount: retryCount ?? this.retryCount,
        nextAttemptAt:
            nextAttemptAt.present ? nextAttemptAt.value : this.nextAttemptAt,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncOutboxItem copyWithCompanion(SyncOutboxItemsCompanion data) {
    return SyncOutboxItem(
      id: data.id.present ? data.id.value : this.id,
      workspaceId:
          data.workspaceId.present ? data.workspaceId.value : this.workspaceId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxItem(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('operationType: $operationType, ')
          ..write('entityId: $entityId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      workspaceId,
      operationType,
      entityId,
      idempotencyKey,
      payloadJson,
      status,
      retryCount,
      nextAttemptAt,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxItem &&
          other.id == this.id &&
          other.workspaceId == this.workspaceId &&
          other.operationType == this.operationType &&
          other.entityId == this.entityId &&
          other.idempotencyKey == this.idempotencyKey &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.createdAt == this.createdAt);
}

class SyncOutboxItemsCompanion extends UpdateCompanion<SyncOutboxItem> {
  final Value<String> id;
  final Value<String> workspaceId;
  final Value<String> operationType;
  final Value<String> entityId;
  final Value<String> idempotencyKey;
  final Value<String> payloadJson;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<DateTime?> nextAttemptAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SyncOutboxItemsCompanion({
    this.id = const Value.absent(),
    this.workspaceId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxItemsCompanion.insert({
    required String id,
    this.workspaceId = const Value.absent(),
    required String operationType,
    required String entityId,
    required String idempotencyKey,
    required String payloadJson,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        operationType = Value(operationType),
        entityId = Value(entityId),
        idempotencyKey = Value(idempotencyKey),
        payloadJson = Value(payloadJson);
  static Insertable<SyncOutboxItem> custom({
    Expression<String>? id,
    Expression<String>? workspaceId,
    Expression<String>? operationType,
    Expression<String>? entityId,
    Expression<String>? idempotencyKey,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<DateTime>? nextAttemptAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workspaceId != null) 'workspace_id': workspaceId,
      if (operationType != null) 'operation_type': operationType,
      if (entityId != null) 'entity_id': entityId,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? workspaceId,
      Value<String>? operationType,
      Value<String>? entityId,
      Value<String>? idempotencyKey,
      Value<String>? payloadJson,
      Value<String>? status,
      Value<int>? retryCount,
      Value<DateTime?>? nextAttemptAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SyncOutboxItemsCompanion(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      operationType: operationType ?? this.operationType,
      entityId: entityId ?? this.entityId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workspaceId.present) {
      map['workspace_id'] = Variable<String>(workspaceId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxItemsCompanion(')
          ..write('id: $id, ')
          ..write('workspaceId: $workspaceId, ')
          ..write('operationType: $operationType, ')
          ..write('entityId: $entityId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$EchoDatabase extends GeneratedDatabase {
  _$EchoDatabase(QueryExecutor e) : super(e);
  $EchoDatabaseManager get managers => $EchoDatabaseManager(this);
  late final $EvidencesTable evidences = $EvidencesTable(this);
  late final $ActionPacketsTable actionPackets = $ActionPacketsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $ChecklistItemsTable checklistItems = $ChecklistItemsTable(this);
  late final $TaskEventsTable taskEvents = $TaskEventsTable(this);
  late final $SyncOutboxItemsTable syncOutboxItems =
      $SyncOutboxItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        evidences,
        actionPackets,
        tasks,
        checklistItems,
        taskEvents,
        syncOutboxItems
      ];
}

typedef $$EvidencesTableCreateCompanionBuilder = EvidencesCompanion Function({
  required String id,
  Value<String?> packetId,
  required String type,
  required String localUri,
  Value<String?> thumbnailUri,
  Value<int?> durationSec,
  Value<String?> transcriptExcerpt,
  Value<String> metadataJson,
  Value<DateTime> capturedAt,
  Value<bool> isClosure,
  Value<int> rowid,
});
typedef $$EvidencesTableUpdateCompanionBuilder = EvidencesCompanion Function({
  Value<String> id,
  Value<String?> packetId,
  Value<String> type,
  Value<String> localUri,
  Value<String?> thumbnailUri,
  Value<int?> durationSec,
  Value<String?> transcriptExcerpt,
  Value<String> metadataJson,
  Value<DateTime> capturedAt,
  Value<bool> isClosure,
  Value<int> rowid,
});

class $$EvidencesTableFilterComposer
    extends Composer<_$EchoDatabase, $EvidencesTable> {
  $$EvidencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get packetId => $composableBuilder(
      column: $table.packetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localUri => $composableBuilder(
      column: $table.localUri, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thumbnailUri => $composableBuilder(
      column: $table.thumbnailUri, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSec => $composableBuilder(
      column: $table.durationSec, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transcriptExcerpt => $composableBuilder(
      column: $table.transcriptExcerpt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
      column: $table.capturedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isClosure => $composableBuilder(
      column: $table.isClosure, builder: (column) => ColumnFilters(column));
}

class $$EvidencesTableOrderingComposer
    extends Composer<_$EchoDatabase, $EvidencesTable> {
  $$EvidencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get packetId => $composableBuilder(
      column: $table.packetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localUri => $composableBuilder(
      column: $table.localUri, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thumbnailUri => $composableBuilder(
      column: $table.thumbnailUri,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSec => $composableBuilder(
      column: $table.durationSec, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transcriptExcerpt => $composableBuilder(
      column: $table.transcriptExcerpt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
      column: $table.capturedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isClosure => $composableBuilder(
      column: $table.isClosure, builder: (column) => ColumnOrderings(column));
}

class $$EvidencesTableAnnotationComposer
    extends Composer<_$EchoDatabase, $EvidencesTable> {
  $$EvidencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packetId =>
      $composableBuilder(column: $table.packetId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get localUri =>
      $composableBuilder(column: $table.localUri, builder: (column) => column);

  GeneratedColumn<String> get thumbnailUri => $composableBuilder(
      column: $table.thumbnailUri, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
      column: $table.durationSec, builder: (column) => column);

  GeneratedColumn<String> get transcriptExcerpt => $composableBuilder(
      column: $table.transcriptExcerpt, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
      column: $table.capturedAt, builder: (column) => column);

  GeneratedColumn<bool> get isClosure =>
      $composableBuilder(column: $table.isClosure, builder: (column) => column);
}

class $$EvidencesTableTableManager extends RootTableManager<
    _$EchoDatabase,
    $EvidencesTable,
    Evidence,
    $$EvidencesTableFilterComposer,
    $$EvidencesTableOrderingComposer,
    $$EvidencesTableAnnotationComposer,
    $$EvidencesTableCreateCompanionBuilder,
    $$EvidencesTableUpdateCompanionBuilder,
    (Evidence, BaseReferences<_$EchoDatabase, $EvidencesTable, Evidence>),
    Evidence,
    PrefetchHooks Function()> {
  $$EvidencesTableTableManager(_$EchoDatabase db, $EvidencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvidencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvidencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EvidencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> packetId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> localUri = const Value.absent(),
            Value<String?> thumbnailUri = const Value.absent(),
            Value<int?> durationSec = const Value.absent(),
            Value<String?> transcriptExcerpt = const Value.absent(),
            Value<String> metadataJson = const Value.absent(),
            Value<DateTime> capturedAt = const Value.absent(),
            Value<bool> isClosure = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EvidencesCompanion(
            id: id,
            packetId: packetId,
            type: type,
            localUri: localUri,
            thumbnailUri: thumbnailUri,
            durationSec: durationSec,
            transcriptExcerpt: transcriptExcerpt,
            metadataJson: metadataJson,
            capturedAt: capturedAt,
            isClosure: isClosure,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> packetId = const Value.absent(),
            required String type,
            required String localUri,
            Value<String?> thumbnailUri = const Value.absent(),
            Value<int?> durationSec = const Value.absent(),
            Value<String?> transcriptExcerpt = const Value.absent(),
            Value<String> metadataJson = const Value.absent(),
            Value<DateTime> capturedAt = const Value.absent(),
            Value<bool> isClosure = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EvidencesCompanion.insert(
            id: id,
            packetId: packetId,
            type: type,
            localUri: localUri,
            thumbnailUri: thumbnailUri,
            durationSec: durationSec,
            transcriptExcerpt: transcriptExcerpt,
            metadataJson: metadataJson,
            capturedAt: capturedAt,
            isClosure: isClosure,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EvidencesTableProcessedTableManager = ProcessedTableManager<
    _$EchoDatabase,
    $EvidencesTable,
    Evidence,
    $$EvidencesTableFilterComposer,
    $$EvidencesTableOrderingComposer,
    $$EvidencesTableAnnotationComposer,
    $$EvidencesTableCreateCompanionBuilder,
    $$EvidencesTableUpdateCompanionBuilder,
    (Evidence, BaseReferences<_$EchoDatabase, $EvidencesTable, Evidence>),
    Evidence,
    PrefetchHooks Function()>;
typedef $$ActionPacketsTableCreateCompanionBuilder = ActionPacketsCompanion
    Function({
  required String id,
  Value<String> workspaceId,
  Value<int> version,
  Value<String> status,
  required String title,
  required String category,
  required String priority,
  required String summary,
  required String payloadJson,
  Value<bool> requiresHumanApproval,
  Value<int?> captureDurationMs,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$ActionPacketsTableUpdateCompanionBuilder = ActionPacketsCompanion
    Function({
  Value<String> id,
  Value<String> workspaceId,
  Value<int> version,
  Value<String> status,
  Value<String> title,
  Value<String> category,
  Value<String> priority,
  Value<String> summary,
  Value<String> payloadJson,
  Value<bool> requiresHumanApproval,
  Value<int?> captureDurationMs,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ActionPacketsTableFilterComposer
    extends Composer<_$EchoDatabase, $ActionPacketsTable> {
  $$ActionPacketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workspaceId => $composableBuilder(
      column: $table.workspaceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get requiresHumanApproval => $composableBuilder(
      column: $table.requiresHumanApproval,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get captureDurationMs => $composableBuilder(
      column: $table.captureDurationMs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ActionPacketsTableOrderingComposer
    extends Composer<_$EchoDatabase, $ActionPacketsTable> {
  $$ActionPacketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workspaceId => $composableBuilder(
      column: $table.workspaceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get requiresHumanApproval => $composableBuilder(
      column: $table.requiresHumanApproval,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get captureDurationMs => $composableBuilder(
      column: $table.captureDurationMs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ActionPacketsTableAnnotationComposer
    extends Composer<_$EchoDatabase, $ActionPacketsTable> {
  $$ActionPacketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
      column: $table.workspaceId, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<bool> get requiresHumanApproval => $composableBuilder(
      column: $table.requiresHumanApproval, builder: (column) => column);

  GeneratedColumn<int> get captureDurationMs => $composableBuilder(
      column: $table.captureDurationMs, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ActionPacketsTableTableManager extends RootTableManager<
    _$EchoDatabase,
    $ActionPacketsTable,
    ActionPacket,
    $$ActionPacketsTableFilterComposer,
    $$ActionPacketsTableOrderingComposer,
    $$ActionPacketsTableAnnotationComposer,
    $$ActionPacketsTableCreateCompanionBuilder,
    $$ActionPacketsTableUpdateCompanionBuilder,
    (
      ActionPacket,
      BaseReferences<_$EchoDatabase, $ActionPacketsTable, ActionPacket>
    ),
    ActionPacket,
    PrefetchHooks Function()> {
  $$ActionPacketsTableTableManager(_$EchoDatabase db, $ActionPacketsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActionPacketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActionPacketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActionPacketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> workspaceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String> summary = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<bool> requiresHumanApproval = const Value.absent(),
            Value<int?> captureDurationMs = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActionPacketsCompanion(
            id: id,
            workspaceId: workspaceId,
            version: version,
            status: status,
            title: title,
            category: category,
            priority: priority,
            summary: summary,
            payloadJson: payloadJson,
            requiresHumanApproval: requiresHumanApproval,
            captureDurationMs: captureDurationMs,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> workspaceId = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<String> status = const Value.absent(),
            required String title,
            required String category,
            required String priority,
            required String summary,
            required String payloadJson,
            Value<bool> requiresHumanApproval = const Value.absent(),
            Value<int?> captureDurationMs = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ActionPacketsCompanion.insert(
            id: id,
            workspaceId: workspaceId,
            version: version,
            status: status,
            title: title,
            category: category,
            priority: priority,
            summary: summary,
            payloadJson: payloadJson,
            requiresHumanApproval: requiresHumanApproval,
            captureDurationMs: captureDurationMs,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ActionPacketsTableProcessedTableManager = ProcessedTableManager<
    _$EchoDatabase,
    $ActionPacketsTable,
    ActionPacket,
    $$ActionPacketsTableFilterComposer,
    $$ActionPacketsTableOrderingComposer,
    $$ActionPacketsTableAnnotationComposer,
    $$ActionPacketsTableCreateCompanionBuilder,
    $$ActionPacketsTableUpdateCompanionBuilder,
    (
      ActionPacket,
      BaseReferences<_$EchoDatabase, $ActionPacketsTable, ActionPacket>
    ),
    ActionPacket,
    PrefetchHooks Function()>;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  required String id,
  Value<String> workspaceId,
  required String packetId,
  Value<String> status,
  required String priority,
  required String title,
  required String summary,
  Value<String?> assignedTo,
  Value<DateTime?> dueAt,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<String> id,
  Value<String> workspaceId,
  Value<String> packetId,
  Value<String> status,
  Value<String> priority,
  Value<String> title,
  Value<String> summary,
  Value<String?> assignedTo,
  Value<DateTime?> dueAt,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TasksTableFilterComposer extends Composer<_$EchoDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workspaceId => $composableBuilder(
      column: $table.workspaceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get packetId => $composableBuilder(
      column: $table.packetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assignedTo => $composableBuilder(
      column: $table.assignedTo, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TasksTableOrderingComposer
    extends Composer<_$EchoDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workspaceId => $composableBuilder(
      column: $table.workspaceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get packetId => $composableBuilder(
      column: $table.packetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assignedTo => $composableBuilder(
      column: $table.assignedTo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TasksTableAnnotationComposer
    extends Composer<_$EchoDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
      column: $table.workspaceId, builder: (column) => column);

  GeneratedColumn<String> get packetId =>
      $composableBuilder(column: $table.packetId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get assignedTo => $composableBuilder(
      column: $table.assignedTo, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TasksTableTableManager extends RootTableManager<
    _$EchoDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, BaseReferences<_$EchoDatabase, $TasksTable, Task>),
    Task,
    PrefetchHooks Function()> {
  $$TasksTableTableManager(_$EchoDatabase db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> workspaceId = const Value.absent(),
            Value<String> packetId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> summary = const Value.absent(),
            Value<String?> assignedTo = const Value.absent(),
            Value<DateTime?> dueAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            workspaceId: workspaceId,
            packetId: packetId,
            status: status,
            priority: priority,
            title: title,
            summary: summary,
            assignedTo: assignedTo,
            dueAt: dueAt,
            completedAt: completedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> workspaceId = const Value.absent(),
            required String packetId,
            Value<String> status = const Value.absent(),
            required String priority,
            required String title,
            required String summary,
            Value<String?> assignedTo = const Value.absent(),
            Value<DateTime?> dueAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            workspaceId: workspaceId,
            packetId: packetId,
            status: status,
            priority: priority,
            title: title,
            summary: summary,
            assignedTo: assignedTo,
            dueAt: dueAt,
            completedAt: completedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasksTableProcessedTableManager = ProcessedTableManager<
    _$EchoDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, BaseReferences<_$EchoDatabase, $TasksTable, Task>),
    Task,
    PrefetchHooks Function()>;
typedef $$ChecklistItemsTableCreateCompanionBuilder = ChecklistItemsCompanion
    Function({
  required String id,
  required String taskId,
  required int position,
  required String textContent,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$ChecklistItemsTableUpdateCompanionBuilder = ChecklistItemsCompanion
    Function({
  Value<String> id,
  Value<String> taskId,
  Value<int> position,
  Value<String> textContent,
  Value<bool> isCompleted,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

class $$ChecklistItemsTableFilterComposer
    extends Composer<_$EchoDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));
}

class $$ChecklistItemsTableOrderingComposer
    extends Composer<_$EchoDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$ChecklistItemsTableAnnotationComposer
    extends Composer<_$EchoDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);
}

class $$ChecklistItemsTableTableManager extends RootTableManager<
    _$EchoDatabase,
    $ChecklistItemsTable,
    ChecklistItem,
    $$ChecklistItemsTableFilterComposer,
    $$ChecklistItemsTableOrderingComposer,
    $$ChecklistItemsTableAnnotationComposer,
    $$ChecklistItemsTableCreateCompanionBuilder,
    $$ChecklistItemsTableUpdateCompanionBuilder,
    (
      ChecklistItem,
      BaseReferences<_$EchoDatabase, $ChecklistItemsTable, ChecklistItem>
    ),
    ChecklistItem,
    PrefetchHooks Function()> {
  $$ChecklistItemsTableTableManager(
      _$EchoDatabase db, $ChecklistItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> textContent = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChecklistItemsCompanion(
            id: id,
            taskId: taskId,
            position: position,
            textContent: textContent,
            isCompleted: isCompleted,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskId,
            required int position,
            required String textContent,
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChecklistItemsCompanion.insert(
            id: id,
            taskId: taskId,
            position: position,
            textContent: textContent,
            isCompleted: isCompleted,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChecklistItemsTableProcessedTableManager = ProcessedTableManager<
    _$EchoDatabase,
    $ChecklistItemsTable,
    ChecklistItem,
    $$ChecklistItemsTableFilterComposer,
    $$ChecklistItemsTableOrderingComposer,
    $$ChecklistItemsTableAnnotationComposer,
    $$ChecklistItemsTableCreateCompanionBuilder,
    $$ChecklistItemsTableUpdateCompanionBuilder,
    (
      ChecklistItem,
      BaseReferences<_$EchoDatabase, $ChecklistItemsTable, ChecklistItem>
    ),
    ChecklistItem,
    PrefetchHooks Function()>;
typedef $$TaskEventsTableCreateCompanionBuilder = TaskEventsCompanion Function({
  required String id,
  required String taskId,
  Value<String> actorId,
  required String eventType,
  Value<String> payloadJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$TaskEventsTableUpdateCompanionBuilder = TaskEventsCompanion Function({
  Value<String> id,
  Value<String> taskId,
  Value<String> actorId,
  Value<String> eventType,
  Value<String> payloadJson,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$TaskEventsTableFilterComposer
    extends Composer<_$EchoDatabase, $TaskEventsTable> {
  $$TaskEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actorId => $composableBuilder(
      column: $table.actorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$TaskEventsTableOrderingComposer
    extends Composer<_$EchoDatabase, $TaskEventsTable> {
  $$TaskEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actorId => $composableBuilder(
      column: $table.actorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TaskEventsTableAnnotationComposer
    extends Composer<_$EchoDatabase, $TaskEventsTable> {
  $$TaskEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get actorId =>
      $composableBuilder(column: $table.actorId, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TaskEventsTableTableManager extends RootTableManager<
    _$EchoDatabase,
    $TaskEventsTable,
    TaskEvent,
    $$TaskEventsTableFilterComposer,
    $$TaskEventsTableOrderingComposer,
    $$TaskEventsTableAnnotationComposer,
    $$TaskEventsTableCreateCompanionBuilder,
    $$TaskEventsTableUpdateCompanionBuilder,
    (TaskEvent, BaseReferences<_$EchoDatabase, $TaskEventsTable, TaskEvent>),
    TaskEvent,
    PrefetchHooks Function()> {
  $$TaskEventsTableTableManager(_$EchoDatabase db, $TaskEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> taskId = const Value.absent(),
            Value<String> actorId = const Value.absent(),
            Value<String> eventType = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskEventsCompanion(
            id: id,
            taskId: taskId,
            actorId: actorId,
            eventType: eventType,
            payloadJson: payloadJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String taskId,
            Value<String> actorId = const Value.absent(),
            required String eventType,
            Value<String> payloadJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskEventsCompanion.insert(
            id: id,
            taskId: taskId,
            actorId: actorId,
            eventType: eventType,
            payloadJson: payloadJson,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaskEventsTableProcessedTableManager = ProcessedTableManager<
    _$EchoDatabase,
    $TaskEventsTable,
    TaskEvent,
    $$TaskEventsTableFilterComposer,
    $$TaskEventsTableOrderingComposer,
    $$TaskEventsTableAnnotationComposer,
    $$TaskEventsTableCreateCompanionBuilder,
    $$TaskEventsTableUpdateCompanionBuilder,
    (TaskEvent, BaseReferences<_$EchoDatabase, $TaskEventsTable, TaskEvent>),
    TaskEvent,
    PrefetchHooks Function()>;
typedef $$SyncOutboxItemsTableCreateCompanionBuilder = SyncOutboxItemsCompanion
    Function({
  required String id,
  Value<String> workspaceId,
  required String operationType,
  required String entityId,
  required String idempotencyKey,
  required String payloadJson,
  Value<String> status,
  Value<int> retryCount,
  Value<DateTime?> nextAttemptAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$SyncOutboxItemsTableUpdateCompanionBuilder = SyncOutboxItemsCompanion
    Function({
  Value<String> id,
  Value<String> workspaceId,
  Value<String> operationType,
  Value<String> entityId,
  Value<String> idempotencyKey,
  Value<String> payloadJson,
  Value<String> status,
  Value<int> retryCount,
  Value<DateTime?> nextAttemptAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SyncOutboxItemsTableFilterComposer
    extends Composer<_$EchoDatabase, $SyncOutboxItemsTable> {
  $$SyncOutboxItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workspaceId => $composableBuilder(
      column: $table.workspaceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncOutboxItemsTableOrderingComposer
    extends Composer<_$EchoDatabase, $SyncOutboxItemsTable> {
  $$SyncOutboxItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workspaceId => $composableBuilder(
      column: $table.workspaceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operationType => $composableBuilder(
      column: $table.operationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncOutboxItemsTableAnnotationComposer
    extends Composer<_$EchoDatabase, $SyncOutboxItemsTable> {
  $$SyncOutboxItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workspaceId => $composableBuilder(
      column: $table.workspaceId, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
      column: $table.nextAttemptAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncOutboxItemsTableTableManager extends RootTableManager<
    _$EchoDatabase,
    $SyncOutboxItemsTable,
    SyncOutboxItem,
    $$SyncOutboxItemsTableFilterComposer,
    $$SyncOutboxItemsTableOrderingComposer,
    $$SyncOutboxItemsTableAnnotationComposer,
    $$SyncOutboxItemsTableCreateCompanionBuilder,
    $$SyncOutboxItemsTableUpdateCompanionBuilder,
    (
      SyncOutboxItem,
      BaseReferences<_$EchoDatabase, $SyncOutboxItemsTable, SyncOutboxItem>
    ),
    SyncOutboxItem,
    PrefetchHooks Function()> {
  $$SyncOutboxItemsTableTableManager(
      _$EchoDatabase db, $SyncOutboxItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> workspaceId = const Value.absent(),
            Value<String> operationType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> idempotencyKey = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<DateTime?> nextAttemptAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncOutboxItemsCompanion(
            id: id,
            workspaceId: workspaceId,
            operationType: operationType,
            entityId: entityId,
            idempotencyKey: idempotencyKey,
            payloadJson: payloadJson,
            status: status,
            retryCount: retryCount,
            nextAttemptAt: nextAttemptAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> workspaceId = const Value.absent(),
            required String operationType,
            required String entityId,
            required String idempotencyKey,
            required String payloadJson,
            Value<String> status = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<DateTime?> nextAttemptAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncOutboxItemsCompanion.insert(
            id: id,
            workspaceId: workspaceId,
            operationType: operationType,
            entityId: entityId,
            idempotencyKey: idempotencyKey,
            payloadJson: payloadJson,
            status: status,
            retryCount: retryCount,
            nextAttemptAt: nextAttemptAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncOutboxItemsTableProcessedTableManager = ProcessedTableManager<
    _$EchoDatabase,
    $SyncOutboxItemsTable,
    SyncOutboxItem,
    $$SyncOutboxItemsTableFilterComposer,
    $$SyncOutboxItemsTableOrderingComposer,
    $$SyncOutboxItemsTableAnnotationComposer,
    $$SyncOutboxItemsTableCreateCompanionBuilder,
    $$SyncOutboxItemsTableUpdateCompanionBuilder,
    (
      SyncOutboxItem,
      BaseReferences<_$EchoDatabase, $SyncOutboxItemsTable, SyncOutboxItem>
    ),
    SyncOutboxItem,
    PrefetchHooks Function()>;

class $EchoDatabaseManager {
  final _$EchoDatabase _db;
  $EchoDatabaseManager(this._db);
  $$EvidencesTableTableManager get evidences =>
      $$EvidencesTableTableManager(_db, _db.evidences);
  $$ActionPacketsTableTableManager get actionPackets =>
      $$ActionPacketsTableTableManager(_db, _db.actionPackets);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$ChecklistItemsTableTableManager get checklistItems =>
      $$ChecklistItemsTableTableManager(_db, _db.checklistItems);
  $$TaskEventsTableTableManager get taskEvents =>
      $$TaskEventsTableTableManager(_db, _db.taskEvents);
  $$SyncOutboxItemsTableTableManager get syncOutboxItems =>
      $$SyncOutboxItemsTableTableManager(_db, _db.syncOutboxItems);
}
