/// Evidence reference linking a fact/inference to original media
class EvidenceLink {
  final String evidenceId;
  final String type; // 'photo', 'voice', 'text'
  final String label;
  final String? excerpt;
  final int? timestampSec;

  const EvidenceLink({
    required this.evidenceId,
    required this.type,
    required this.label,
    this.excerpt,
    this.timestampSec,
  });

  Map<String, dynamic> toJson() => {
        'evidence_id': evidenceId,
        'type': type,
        'label': label,
        if (excerpt != null) 'excerpt': excerpt,
        if (timestampSec != null) 'timestamp_sec': timestampSec,
      };

  factory EvidenceLink.fromJson(Map<String, dynamic> json) => EvidenceLink(
        evidenceId: json['evidence_id'] ?? json['id'] ?? '',
        type: json['type'] ?? 'photo',
        label: json['label'] ?? 'Evidence',
        excerpt: json['excerpt'],
        timestampSec: json['timestamp_sec'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvidenceLink &&
          runtimeType == other.runtimeType &&
          evidenceId == other.evidenceId &&
          type == other.type;

  @override
  int get hashCode => evidenceId.hashCode ^ type.hashCode;
}

/// A fact directly observed and backed by captured media
class ObservedFact {
  final String text;
  final List<EvidenceLink> evidenceLinks;
  final double confidence;

  const ObservedFact({
    required this.text,
    this.evidenceLinks = const [],
    this.confidence = 1.0,
  });

  String get fact => text;
  String get statement => text;

  Map<String, dynamic> toJson() => {
        'text': text,
        'fact': text,
        'evidence_links': evidenceLinks.map((e) => e.toJson()).toList(),
        'confidence': confidence,
      };

  factory ObservedFact.fromJson(Map<String, dynamic> json) => ObservedFact(
        text: json['text'] ?? json['fact'] ?? json['statement'] ?? '',
        evidenceLinks: (json['evidence_links'] as List? ?? [])
            .map((e) => EvidenceLink.fromJson(e as Map<String, dynamic>))
            .toList(),
        confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObservedFact &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          confidence == other.confidence;

  @override
  int get hashCode => text.hashCode ^ confidence.hashCode;
}

/// An inference derived by AI, explicitly labeled to prevent false factuality
class InferenceItem {
  final String text;
  final String basis;
  final String confidenceState; // 'high', 'moderate', 'low'
  final List<EvidenceLink> supportingEvidence;

  const InferenceItem({
    required this.text,
    required this.basis,
    required this.confidenceState,
    this.supportingEvidence = const [],
  });

  String get inference => text;
  List<String> get groundedFacts => [basis];
  double get confidence =>
      confidenceState == 'high' ? 0.9 : (confidenceState == 'low' ? 0.4 : 0.7);

  Map<String, dynamic> toJson() => {
        'text': text,
        'inference': text,
        'basis': basis,
        'confidence_state': confidenceState,
        'supporting_evidence':
            supportingEvidence.map((e) => e.toJson()).toList(),
      };

  factory InferenceItem.fromJson(Map<String, dynamic> json) => InferenceItem(
        text: json['text'] ?? json['inference'] ?? '',
        basis: json['basis'] ??
            (json['grounded_facts'] is List &&
                    (json['grounded_facts'] as List).isNotEmpty
                ? (json['grounded_facts'] as List).first.toString()
                : 'Inferred from context'),
        confidenceState: json['confidence_state'] ?? 'moderate',
        supportingEvidence: (json['supporting_evidence'] as List? ?? [])
            .map((e) => EvidenceLink.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InferenceItem &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          basis == other.basis &&
          confidenceState == other.confidenceState;

  @override
  int get hashCode => text.hashCode ^ basis.hashCode ^ confidenceState.hashCode;
}

/// Critical missing detail needed for safe execution
class MissingInfoItem {
  final String prompt;
  final String contextReason;
  final String? suggestedCheck;
  final bool isResolved;
  final String? resolutionText;

  const MissingInfoItem({
    required this.prompt,
    required this.contextReason,
    this.suggestedCheck,
    this.isResolved = false,
    this.resolutionText,
  });

  String get question => prompt;

  MissingInfoItem copyWith({
    String? prompt,
    String? contextReason,
    String? suggestedCheck,
    bool? isResolved,
    String? resolutionText,
  }) {
    return MissingInfoItem(
      prompt: prompt ?? this.prompt,
      contextReason: contextReason ?? this.contextReason,
      suggestedCheck: suggestedCheck ?? this.suggestedCheck,
      isResolved: isResolved ?? this.isResolved,
      resolutionText: resolutionText ?? this.resolutionText,
    );
  }

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'question': prompt,
        'context_reason': contextReason,
        if (suggestedCheck != null) 'suggested_check': suggestedCheck,
        'is_resolved': isResolved,
        if (resolutionText != null) 'resolution_text': resolutionText,
      };

  factory MissingInfoItem.fromJson(Map<String, dynamic> json) =>
      MissingInfoItem(
        prompt: json['prompt'] ?? json['question'] ?? '',
        contextReason: json['context_reason'] ?? '',
        suggestedCheck: json['suggested_check'],
        isResolved: json['is_resolved'] ?? false,
        resolutionText: json['resolution_text'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MissingInfoItem &&
          runtimeType == other.runtimeType &&
          prompt == other.prompt &&
          contextReason == other.contextReason &&
          isResolved == other.isResolved;

  @override
  int get hashCode =>
      prompt.hashCode ^ contextReason.hashCode ^ isResolved.hashCode;
}

/// Operational step suggested by ECHO
class SuggestedAction {
  final int step;
  final String action;
  final String? safetyNote;
  final double confidence;

  const SuggestedAction({
    required this.step,
    required this.action,
    this.safetyNote,
    this.confidence = 0.9,
  });

  Map<String, dynamic> toJson() => {
        'step': step,
        'action': action,
        if (safetyNote != null) 'safety_note': safetyNote,
        'confidence': confidence,
      };

  factory SuggestedAction.fromJson(Map<String, dynamic> json) =>
      SuggestedAction(
        step: json['step'] ?? 1,
        action: json['action'] ?? '',
        safetyNote: json['safety_note'],
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.9,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestedAction &&
          runtimeType == other.runtimeType &&
          step == other.step &&
          action == other.action;

  @override
  int get hashCode => step.hashCode ^ action.hashCode;
}

/// Operational Checklist Item
class ChecklistItemData {
  final String id;
  final String text;
  final bool isCompleted;

  const ChecklistItemData({
    required this.id,
    required this.text,
    this.isCompleted = false,
  });

  ChecklistItemData copyWith({
    String? id,
    String? text,
    bool? isCompleted,
  }) {
    return ChecklistItemData(
      id: id ?? this.id,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'is_completed': isCompleted,
      };

  factory ChecklistItemData.fromJson(Map<String, dynamic> json) =>
      ChecklistItemData(
        id: json['id'] ?? '',
        text: json['text'] ?? '',
        isCompleted: json['is_completed'] ?? false,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistItemData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode => id.hashCode ^ text.hashCode ^ isCompleted.hashCode;
}

/// The core Action Packet object
class ActionPacketModel {
  final String id;
  final String workspaceId;
  final int version;
  final String
      status; // 'draft', 'processing', 'needs_review', 'ready', 'approved'
  final String title;
  final String
      category; // 'equipment', 'facility', 'electrical', 'plumbing', 'safety'
  final String priority; // 'critical', 'high', 'medium', 'low'
  final String priorityReason;
  final String summary;
  final List<ObservedFact> observations;
  final List<InferenceItem> inferences;
  final List<MissingInfoItem> missingInformation;
  final List<SuggestedAction> suggestedActions;
  final List<ChecklistItemData> checklist;
  final List<String> evidenceIds;
  final String confidenceState; // 'Verified', 'High Confidence', 'Needs Review'
  final bool requiresHumanApproval;
  final int? captureDurationMs;
  final String
      generationSource; // 'LOCAL_LLM', 'PROTOTYPE_RUNTIME', 'DETERMINISTIC_FALLBACK'
  final String modelName;
  final String
      runtimeMode; // 'LOCAL_DEVICE_RUNTIME', 'PROTOTYPE_RUNTIME', 'DETERMINISTIC_FALLBACK'
  final DateTime createdAt;
  final DateTime updatedAt;

  const ActionPacketModel({
    required this.id,
    this.workspaceId = 'ws_default',
    this.version = 1,
    this.status = 'draft',
    required this.title,
    required this.category,
    required this.priority,
    required this.priorityReason,
    required this.summary,
    this.observations = const [],
    this.inferences = const [],
    this.missingInformation = const [],
    this.suggestedActions = const [],
    this.checklist = const [],
    this.evidenceIds = const [],
    this.confidenceState = 'High Confidence',
    this.requiresHumanApproval = true,
    this.captureDurationMs,
    this.generationSource = 'PROTOTYPE_RUNTIME',
    this.modelName = 'ECHO Grounded Model Adapter (Prototype v1.0)',
    this.runtimeMode = 'PROTOTYPE_RUNTIME',
    required this.createdAt,
    required this.updatedAt,
  });

  static String cleanTitle(String input,
      {String fallback = 'Untitled Action Packet'}) {
    final trimmed = input.trim();
    return trimmed.isEmpty ? fallback : trimmed;
  }

  static String cleanSummary(String input,
      {String fallback = 'No summary details provided.'}) {
    final trimmed = input.trim();
    return trimmed.isEmpty ? fallback : trimmed;
  }

  ActionPacketModel copyWith({
    String? id,
    String? workspaceId,
    int? version,
    String? status,
    String? title,
    String? category,
    String? priority,
    String? priorityReason,
    String? summary,
    List<ObservedFact>? observations,
    List<InferenceItem>? inferences,
    List<MissingInfoItem>? missingInformation,
    List<SuggestedAction>? suggestedActions,
    List<ChecklistItemData>? checklist,
    List<String>? evidenceIds,
    String? confidenceState,
    bool? requiresHumanApproval,
    int? captureDurationMs,
    String? generationSource,
    String? modelName,
    String? runtimeMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActionPacketModel(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      version: version ?? this.version,
      status: status ?? this.status,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      priorityReason: priorityReason ?? this.priorityReason,
      summary: summary ?? this.summary,
      observations: observations ?? this.observations,
      inferences: inferences ?? this.inferences,
      missingInformation: missingInformation ?? this.missingInformation,
      suggestedActions: suggestedActions ?? this.suggestedActions,
      checklist: checklist ?? this.checklist,
      evidenceIds: evidenceIds ?? this.evidenceIds,
      confidenceState: confidenceState ?? this.confidenceState,
      requiresHumanApproval:
          requiresHumanApproval ?? this.requiresHumanApproval,
      captureDurationMs: captureDurationMs ?? this.captureDurationMs,
      generationSource: generationSource ?? this.generationSource,
      modelName: modelName ?? this.modelName,
      runtimeMode: runtimeMode ?? this.runtimeMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'packet_id': id,
        'workspace_id': workspaceId,
        'version': version,
        'packet_version': version,
        'status': status,
        'title': cleanTitle(title),
        'category': category,
        'priority': priority,
        'priority_reason': priorityReason,
        'summary': cleanSummary(summary),
        'observations': observations.map((o) => o.toJson()).toList(),
        'inferences': inferences.map((i) => i.toJson()).toList(),
        'missing_information':
            missingInformation.map((m) => m.toJson()).toList(),
        'suggested_actions': suggestedActions.map((s) => s.toJson()).toList(),
        'checklist': checklist.map((c) => c.toJson()).toList(),
        'evidence_ids': evidenceIds,
        'confidence_state': confidenceState,
        'requires_human_approval': requiresHumanApproval,
        if (captureDurationMs != null) 'capture_duration_ms': captureDurationMs,
        'generation_source': generationSource,
        'model_name': modelName,
        'runtime_mode': runtimeMode,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory ActionPacketModel.fromJson(Map<String, dynamic> json) =>
      ActionPacketModel(
        id: json['id'] ?? json['packet_id'] ?? '',
        workspaceId: json['workspace_id'] ?? 'ws_default',
        version: json['version'] ?? json['packet_version'] ?? 1,
        status: json['status'] ?? 'draft',
        title: cleanTitle(json['title'] ?? ''),
        category: json['category'] ?? 'equipment',
        priority: json['priority'] ?? 'medium',
        priorityReason: json['priority_reason'] ?? 'Standard assessment',
        summary: cleanSummary(json['summary'] ?? ''),
        observations: (json['observations'] as List? ?? [])
            .map((o) => ObservedFact.fromJson(o as Map<String, dynamic>))
            .toList(),
        inferences: (json['inferences'] as List? ?? [])
            .map((i) => InferenceItem.fromJson(i as Map<String, dynamic>))
            .toList(),
        missingInformation: (json['missing_information'] as List? ?? [])
            .map((m) => MissingInfoItem.fromJson(m as Map<String, dynamic>))
            .toList(),
        suggestedActions: (json['suggested_actions'] as List? ?? [])
            .map((s) => SuggestedAction.fromJson(s as Map<String, dynamic>))
            .toList(),
        checklist: (json['checklist'] as List? ?? [])
            .map((c) => ChecklistItemData.fromJson(c as Map<String, dynamic>))
            .toList(),
        evidenceIds: List<String>.from(json['evidence_ids'] ?? []),
        confidenceState: json['confidence_state'] ?? 'High Confidence',
        requiresHumanApproval: json['requires_human_approval'] ?? true,
        captureDurationMs: json['capture_duration_ms'],
        generationSource: json['generation_source'] ?? 'PROTOTYPE_RUNTIME',
        modelName: json['model_name'] ??
            'ECHO Grounded Model Adapter (Prototype v1.0)',
        runtimeMode: json['runtime_mode'] ?? 'PROTOTYPE_RUNTIME',
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : DateTime.now(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionPacketModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          version == other.version &&
          status == other.status;

  @override
  int get hashCode => id.hashCode ^ version.hashCode ^ status.hashCode;
}
