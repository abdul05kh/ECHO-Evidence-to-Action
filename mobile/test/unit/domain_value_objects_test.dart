import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('Domain Value Objects & Equality Tests', () {
    test('ObservedFact equality and hashCode work correctly', () {
      const fact1 = ObservedFact(
          text: 'Keyboard missing key',
          confidence: 0.95);
      const fact2 = ObservedFact(
          text: 'Keyboard missing key',
          confidence: 0.95);
      const fact3 = ObservedFact(
          text: 'Display broken',
          confidence: 0.90);

      expect(fact1, equals(fact2));
      expect(fact1.hashCode, equals(fact2.hashCode));
      expect(fact1, isNot(equals(fact3)));
    });

    test('InferenceItem equality and hashCode work correctly', () {
      const inf1 = InferenceItem(
          text: 'Hardware fault',
          basis: 'Keyboard missing key',
          confidenceState: 'high');
      const inf2 = InferenceItem(
          text: 'Hardware fault',
          basis: 'Keyboard missing key',
          confidenceState: 'high');
      const inf3 = InferenceItem(
          text: 'Software bug',
          basis: 'Error code 500',
          confidenceState: 'moderate');

      expect(inf1, equals(inf2));
      expect(inf1.hashCode, equals(inf2.hashCode));
      expect(inf1, isNot(equals(inf3)));
    });

    test('MissingInfoItem equality and hashCode work correctly', () {
      const missing1 = MissingInfoItem(
          prompt: 'Is power cable connected?',
          contextReason: 'Determines power fix');
      const missing2 = MissingInfoItem(
          prompt: 'Is power cable connected?',
          contextReason: 'Determines power fix');
      const missing3 = MissingInfoItem(
          prompt: 'What is asset ID?',
          contextReason: 'Asset tagging');

      expect(missing1, equals(missing2));
      expect(missing1.hashCode, equals(missing2.hashCode));
      expect(missing1, isNot(equals(missing3)));
    });

    test('SuggestedAction equality and hashCode work correctly', () {
      const action1 = SuggestedAction(
          step: 1,
          action: 'Replace keyboard',
          safetyNote: 'Disconnect power first');
      const action2 = SuggestedAction(
          step: 1,
          action: 'Replace keyboard',
          safetyNote: 'Disconnect power first');
      const action3 = SuggestedAction(step: 2, action: 'Test keys');

      expect(action1, equals(action2));
      expect(action1.hashCode, equals(action2.hashCode));
      expect(action1, isNot(equals(action3)));
    });

    test('ChecklistItemData equality and copyWith work correctly', () {
      const item1 = ChecklistItemData(
          id: 'chk_1', text: 'Inspect cables', isCompleted: false);
      final item2 = item1.copyWith(isCompleted: true);

      expect(item1.isCompleted, isFalse);
      expect(item2.isCompleted, isTrue);
      expect(item1.id, equals(item2.id));
      expect(item1, isNot(equals(item2)));
    });

    test(
        'ActionPacketModel cleanTitle and cleanSummary sanitize whitespace and blank inputs',
        () {
      expect(ActionPacketModel.cleanTitle('   Broken Monitor   '),
          equals('Broken Monitor'));
      expect(ActionPacketModel.cleanTitle('   ', fallback: 'Default Title'),
          equals('Default Title'));

      expect(
          ActionPacketModel.cleanSummary('   Screen flickers continuously.  '),
          equals('Screen flickers continuously.'));
      expect(ActionPacketModel.cleanSummary(''),
          equals('No summary details provided.'));
    });
  });
}
