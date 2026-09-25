import 'package:flutter/material.dart';
import 'theme.dart';

class TaskPriorityColorMapper {
  static Color getColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return EchoTheme.dangerRed;
      case 'high':
        return EchoTheme.accentGold;
      case 'medium':
        return EchoTheme.actionBlue;
      case 'low':
      default:
        return EchoTheme.textSecondary;
    }
  }

  static Color getBackgroundColor(String priority) {
    return getColor(priority).withAlpha(38);
  }

  static Color getBorderColor(String priority) {
    return getColor(priority).withAlpha(153);
  }
}
