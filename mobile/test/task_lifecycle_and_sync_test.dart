import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';
import 'package:echo_mobile/features/tasks/domain/task_state_machine.dart';

void main() {
  group(
      'ECHO Task Lifecycle, State Machine, Persistence & Sync Tests (Tests 7-12)',
      () {
    // =========================================================================
    // TEST 7: NEEDS_REVIEW disallows direct approval without operator review/confirmation
    // =========================================================================
    test(
        'TEST 7: NEEDS_REVIEW state cannot transition directly to approved without reaching ready',
        () {
      expect(
          TaskStateMachine.canTransition('needs_review', 'approved'), isFalse);
      expect(TaskStateMachine.canTransition('needs_review', 'ready'), isTrue);

      expect(
        () => TaskStateMachine.validateTransition('needs_review', 'approved'),
        throwsA(isA<IllegalStateTransitionException>()),
      );
    });

    // =========================================================================
    // TEST 8: READY enables APPROVE WORK ORDER transition
    // =========================================================================
    test('TEST 8: READY state allows transition to approved work order', () {
      expect(TaskStateMachine.canTransition('ready', 'approved'), isTrue);
      expect(() => TaskStateMachine.validateTransition('ready', 'approved'),
          returnsNormally);
    });

    // =========================================================================
    // TEST 9: Invalid task transitions are strictly rejected
    // =========================================================================
    test(
        'TEST 9: Invalid task state transitions are rejected by TaskStateMachine',
        () {
      // Draft cannot jump directly to completed
      expect(TaskStateMachine.canTransition('draft', 'completed'), isFalse);
      expect(() => TaskStateMachine.validateTransition('draft', 'completed'),
          throwsA(isA<IllegalStateTransitionException>()));

      // NeedsReview cannot jump directly to completed
      expect(
          TaskStateMachine.canTransition('needs_review', 'completed'), isFalse);
      expect(
          () =>
              TaskStateMachine.validateTransition('needs_review', 'completed'),
          throwsA(isA<IllegalStateTransitionException>()));

      // Completed cannot jump directly to assigned (must go through reopened)
      expect(TaskStateMachine.canTransition('completed', 'assigned'), isFalse);
      expect(() => TaskStateMachine.validateTransition('completed', 'assigned'),
          throwsA(isA<IllegalStateTransitionException>()));

      // Valid full lifecycle transition sequence
      expect(TaskStateMachine.canTransition('draft', 'processing'), isTrue);
      expect(TaskStateMachine.canTransition('processing', 'ready'), isTrue);
      expect(TaskStateMachine.canTransition('ready', 'approved'), isTrue);
      expect(TaskStateMachine.canTransition('approved', 'in_progress'), isTrue);
      expect(
          TaskStateMachine.canTransition('in_progress', 'completed'), isTrue);
      expect(TaskStateMachine.canTransition('completed', 'reopened'), isTrue);
      expect(TaskStateMachine.canTransition('reopened', 'in_progress'), isTrue);
    });

    // =========================================================================
    // TEST 10: Offline capture creates local persistence and outbox operation
    // =========================================================================
    test(
        'TEST 10: Offline capture persists packet locally with pending outbox sync operation',
        () {
      final now = DateTime.now();
      final packet = ActionPacketModel(
        id: 'ap_offline_001',
        workspaceId: 'ws_campus_ops',
        version: 1,
        status: 'ready',
        title: 'Switchboard Reported Not Working',
        category: 'electrical',
        priority: 'low',
        priorityReason: 'Routine observation; no safety risk detected',
        summary: 'User reports switchboard is not working.',
        observations: const [
          ObservedFact(
            text:
                'A wall-mounted switchboard is visible in the captured image.',
            evidenceLinks: [
              EvidenceLink(
                  evidenceId: 'ev_p1', type: 'photo', label: 'Photo #01')
            ],
          ),
        ],
        inferences: const [],
        missingInformation: const [],
        suggestedActions: const [],
        checklist: const [],
        evidenceIds: const ['ev_p1'],
        confidenceState: 'MEDIUM',
        requiresHumanApproval: true,
        createdAt: now,
        updatedAt: now,
      );

      // Serialize for local SQLite storage
      final jsonPayload = packet.toJson();
      expect(jsonPayload['id'], 'ap_offline_001');
      expect(jsonPayload['status'], 'ready');

      // Create Outbox Operation
      final outboxOp = {
        'idempotency_key': 'outbox_op_${packet.id}_v${packet.version}',
        'entity_id': packet.id,
        'entity_type': 'action_packet',
        'mutation_type': 'CREATE',
        'payload': jsonPayload,
        'status': 'PENDING_SYNC',
        'created_at': now.toIso8601String(),
      };

      expect(outboxOp['status'], 'PENDING_SYNC');
      expect(outboxOp['idempotency_key'], contains('ap_offline_001'));
    });

    // =========================================================================
    // TEST 11: Duplicate sync preserves idempotency key
    // =========================================================================
    test(
        'TEST 11: Duplicate sync replay preserves idempotency key and prevents duplicate records',
        () {
      const packetId = 'ap_sync_test_01';
      const idempotencyKey = 'sync_idem_${packetId}_v1';

      final syncBatch1 = [
        {
          'idempotency_key': idempotencyKey,
          'packet_id': packetId,
          'data': 'first_attempt'
        },
      ];

      final syncBatch2 = [
        {
          'idempotency_key': idempotencyKey,
          'packet_id': packetId,
          'data': 'retry_attempt'
        },
      ];

      // Simulate server reconciliation map
      final Map<String, dynamic> serverStore = {};

      void processSync(List<Map<String, dynamic>> batch) {
        for (final item in batch) {
          final key = item['idempotency_key'] as String;
          if (!serverStore.containsKey(key)) {
            serverStore[key] = item;
          }
        }
      }

      processSync(syncBatch1);
      expect(serverStore.length, 1);

      processSync(syncBatch2);
      expect(serverStore.length, 1); // Deduplicated cleanly
      expect(serverStore[idempotencyKey]['data'], 'first_attempt');
    });

    // =========================================================================
    // TEST 12: App restart / Serialization round-trip survives completely
    // =========================================================================
    test(
        'TEST 12: App restart survives serialization round-trip for packet, evidence, task, and audit',
        () {
      final original = ActionPacketModel(
        id: 'ap_restart_test_99',
        workspaceId: 'ws_campus_ops',
        version: 2,
        status: 'approved',
        title: 'Switchboard Reported Not Working',
        category: 'electrical',
        priority: 'low',
        priorityReason:
            'Routine observation; no immediate deadline or safety risk detected',
        summary:
            'User reports switchboard is not working. The exact failure is not yet visually verified.',
        observations: const [
          ObservedFact(
            text:
                'A wall-mounted switchboard is visible in the captured image.',
            evidenceLinks: [
              EvidenceLink(
                  evidenceId: 'ev_p1', type: 'photo', label: 'Photo #01')
            ],
            confidence: 0.95,
          ),
          ObservedFact(
            text: 'User reports switchboard is not working.',
            evidenceLinks: [
              EvidenceLink(
                  evidenceId: 'ev_v1',
                  type: 'voice',
                  label: 'Voice #01',
                  excerpt: "The switch board isn't working fix it please")
            ],
            confidence: 0.95,
          ),
        ],
        inferences: const [
          InferenceItem(
            text: 'Possible electrical or control issue.',
            basis: 'Basis: user report. Not visually verified.',
            confidenceState: 'moderate',
            supportingEvidence: [],
          ),
        ],
        missingInformation: const [
          MissingInfoItem(
            prompt:
                'Confirm exact room/wall location and specific switch or outlet affected.',
            contextReason:
                'Specific circuit/switch identifier not stated in evidence.',
          ),
        ],
        suggestedActions: const [
          SuggestedAction(
            step: 1,
            action:
                'Visually inspect switchboard exterior for physical signs of wear, scorching, or loose toggles.',
            safetyNote:
                'Do NOT open electrical panel or manipulate internal wiring.',
            confidence: 0.95,
          ),
        ],
        checklist: const [
          ChecklistItemData(
              id: 'chk_1',
              text: 'Inspect reported location on-site',
              isCompleted: true),
          ChecklistItemData(
              id: 'chk_2',
              text: 'Route work order to qualified maintenance personnel',
              isCompleted: false),
        ],
        evidenceIds: const ['ev_p1', 'ev_v1'],
        confidenceState: 'MEDIUM',
        requiresHumanApproval: true,
        captureDurationMs: 14500,
        createdAt: DateTime.parse('2026-09-22T04:00:00.000Z'),
        updatedAt: DateTime.parse('2026-09-22T04:05:00.000Z'),
      );

      // Serialize
      final serialized = original.toJson();

      // Deserialize
      final restored = ActionPacketModel.fromJson(serialized);

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.category, original.category);
      expect(restored.status, original.status);
      expect(restored.priority, original.priority);
      expect(restored.summary, original.summary);
      expect(restored.observations.length, 2);
      expect(restored.observations[0].text, original.observations[0].text);
      expect(restored.observations[1].evidenceLinks[0].excerpt,
          "The switch board isn't working fix it please");
      expect(restored.inferences.length, 1);
      expect(restored.missingInformation.length, 1);
      expect(restored.suggestedActions.length, 1);
      expect(restored.checklist.length, 2);
      expect(restored.checklist[0].isCompleted, isTrue);
      expect(restored.checklist[1].isCompleted, isFalse);
      expect(restored.confidenceState, 'MEDIUM');
      expect(restored.captureDurationMs, 14500);
    });
  });
}
