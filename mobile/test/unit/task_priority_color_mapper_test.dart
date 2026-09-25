import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/app/task_priority_color_mapper.dart';
import 'package:echo_mobile/app/theme.dart';

void main() {
  group('TaskPriorityColorMapper Unit Tests', () {
    test('maps urgent priority to dangerRed color', () {
      final color = TaskPriorityColorMapper.getColor('urgent');
      expect(color, equals(EchoTheme.dangerRed));
    });

    test('maps high priority to accentGold color', () {
      final color = TaskPriorityColorMapper.getColor('high');
      expect(color, equals(EchoTheme.accentGold));
    });

    test('maps medium priority to actionBlue color', () {
      final color = TaskPriorityColorMapper.getColor('medium');
      expect(color, equals(EchoTheme.actionBlue));
    });

    test('generates transparent background and border colors', () {
      final bg = TaskPriorityColorMapper.getBackgroundColor('urgent');
      final border = TaskPriorityColorMapper.getBorderColor('urgent');
      expect((bg.a * 255.0).round(), equals(38));
      expect((border.a * 255.0).round(), equals(153));
    });
  });
}
