import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('ChecklistItemData Serialization & Toggle Tests', () {
    test('ChecklistItemData serialization roundtrip works correctly', () {
      const item = ChecklistItemData(
          id: 'chk_101', text: 'Verify power connection', isCompleted: false);
      final json = item.toJson();
      final restored = ChecklistItemData.fromJson(json);

      expect(restored.id, equals('chk_101'));
      expect(restored.text, equals('Verify power connection'));
      expect(restored.isCompleted, isFalse);
    });

    test('ChecklistItemData copyWith updates completed status', () {
      const item = ChecklistItemData(
          id: 'chk_102', text: 'Clean air filter', isCompleted: false);
      final updated = item.copyWith(isCompleted: true);

      expect(updated.isCompleted, isTrue);
      expect(updated.text, equals('Clean air filter'));
    });
  });
}
