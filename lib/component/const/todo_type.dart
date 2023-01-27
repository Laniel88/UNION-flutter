import 'dart:ui';

import 'package:union/component/const/colors.dart';

enum TodoType { meetings, assignment, etc }

TodoType convertTodoType(int index) {
  if (index == 0) {
    return TodoType.meetings;
  } else if (index == 1) {
    return TodoType.assignment;
  } else {
    return TodoType.etc;
  }
}

String typeToString(TodoType type) {
  switch (type) {
    case TodoType.meetings:
      return '회합';
    case TodoType.assignment:
      return '과제';
    default:
      return 'ETC';
  }
}

Color typeToColor(TodoType type) {
  switch (type) {
    case TodoType.meetings:
      return CHECK_1;
    case TodoType.assignment:
      return CHECK_2;
    default:
      return CHECK_3;
  }
}
