import 'dart:convert';

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
}

/// A fact directly observed and backed by captured media
class ObservedFact {
  final String text;
  final List<EvidenceLink> evidenceLinks;
  final double confidence;

  const ObservedFact({
    required this.text,
    required this.evidenceLinks,
    this.confidence = 1.0,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'evidence_links': evidenceLinks.map((e) => e.toJson()).toList(),
    'confidence': confidence,
  };

  factory ObservedFact.fromJson(Map<String, dynamic> json) => ObservedFact(
    text: json['text'] ?? '',
    evidenceLinks: (json['evidence_links'] as List? ?? [])
        .map((e) => EvidenceLink.fromJson(e as Map<String, dynamic>))
        .toList(),
    confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
  );
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
    required this.supportingEvidence,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'basis': basis,
    'confidence_state': confidenceState,
    'supporting_evidence': supportingEvidence.map((e) => e.toJson()).toList(),
  };

  factory InferenceItem.fromJson(Map<String, dynamic> json) => InferenceItem(
    text: json['text'] ?? '',
    basis: json['basis'] ?? 'Inferred from context',
    confidenceState: json['confidence_state'] ?? 'moderate',
    supportingEvidence: (json['supporting_evidence'] as List? ?? [])
        .map((e) => EvidenceLink.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
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
    'context_reason': contextReason,
    if (suggestedCheck != null) 'suggested_check': suggestedCheck,
    'is_resolved': isResolved,
    if (resolutionText != null) 'resolution_text': resolutionText,
  };

  factory MissingInfoItem.fromJson(Map<String, dynamic> json) => MissingInfoItem(
    prompt: json['prompt'] ?? '',
    contextReason: json['context_reason'] ?? '',
    suggestedCheck: json['suggested_check'],
    isResolved: json['is_resolved'] ?? false,
    resolutionText: json['resolution_text'],
  );
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

  factory SuggestedAction.fromJson(Map<String, dynamic> json) => SuggestedAction(
    step: json['step'] ?? 1,
    action: json['action'] ?? '',
    safetyNote: json['safety_note'],
    confidence: (json['confidence'] as num?)?.toDouble() ?? 0.9,
  );
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

  ChecklistItemData copyWith({bool? isCompleted}) {
    return ChecklistItemData(
      id: id,
      text: text,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'is_completed': isCompleted,
  };

  factory ChecklistItemData.fromJson(Map<String, dynamic> json) => ChecklistItemData(
    id: json['id'] ?? '',
    text: json['text'] ?? '',
    isCompleted: json['is_completed'] ?? false,
  );
}

/// The core Action Packet object
class ActionPacketModel {
  final String id;
  final String workspaceId;
  final int version;
  final String status; // 'draft', 'processing', 'needs_review', 'ready', 'approved'
  final String title;
  final String category; // 'equipment', 'facility', 'electrical', 'plumbing', 'safety'
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
    required this.createdAt,
    required this.updatedAt,
  });

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
      requiresHumanApproval: requiresHumanApproval ?? this.requiresHumanApproval,
      captureDurationMs: captureDurationMs ?? this.captureDurationMs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'workspace_id': workspaceId,
    'version': version,
    'status': status,
    'title': title,
    'category': category,
    'priority': priority,
    'priority_reason': priorityReason,
    'summary': summary,
    'observations': observations.map((o) => o.toJson()).toList(),
    'inferences': inferences.map((i) => i.toJson()).toList(),
    'missing_information': missingInformation.map((m) => m.toJson()).toList(),
    'suggested_actions': suggestedActions.map((s) => s.toJson()).toList(),
    'checklist': checklist.map((c) => c.toJson()).toList(),
    'evidence_ids': evidenceIds,
    'confidence_state': confidenceState,
    'requires_human_approval': requiresHumanApproval,
    if (captureDurationMs != null) 'capture_duration_ms': captureDurationMs,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory ActionPacketModel.fromJson(Map<String, dynamic> json) => ActionPacketModel(
    id: json['id'] ?? '',
    workspaceId: json['workspace_id'] ?? 'ws_default',
    version: json['version'] ?? 1,
    status: json['status'] ?? 'draft',
    title: json['title'] ?? '',
    category: json['category'] ?? 'equipment',
    priority: json['priority'] ?? 'medium',
    priorityReason: json['priority_reason'] ?? 'Standard assessment',
    summary: json['summary'] ?? '',
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
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
  );
}
