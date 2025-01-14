import 'package:fast_app_base/data/memory/todo_data_notifier.dart';
import 'package:fast_app_base/data/memory/todo_status.dart';
import 'package:fast_app_base/data/memory/vo_todo.dart';
import 'package:fast_app_base/screen/main/write/d_write_todo.dart';
import 'package:flutter/material.dart';

class TodoDataHolder extends InheritedWidget {
  final TodoDataNotifier notifier;

  const TodoDataHolder({
    super.key,
    required super.child,
    required this.notifier,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static TodoDataHolder _of(BuildContext context) {
    TodoDataHolder inherited =
        (context.dependOnInheritedWidgetOfExactType<TodoDataHolder>())!;
    return inherited;
  }

  void changeTodoStatus(Todo todo) async {
    switch (todo.status) {
      case TodoStatus.incomplete:
        todo.status = TodoStatus.ongoing;
      case TodoStatus.ongoing:
        todo.status = TodoStatus.complete;
      case TodoStatus.complete:
        todo.status = TodoStatus.incomplete;
      // final result = ConfirmDialog("정말로 처음 상태로 변경하시겠습니까?").show();
      // result?.runIfSuccess((data) {
      //   todo.status = TodoStatus.incomplete;
      // });
    }

    notifier.notify();
  }

  void addTodo() async {
    final result = await WriteTodoDialog().show();
    if (result != null) {
      notifier.addTodo(Todo(
        id: DateTime.now().microsecondsSinceEpoch,
        title: result.text,
        dueDate: result.dateTime,
      ));
    }
  }

  void editTodo(Todo todo) async {
    final result = await WriteTodoDialog(todoForEdit: todo).show();
    if (result != null) {
      todo.title = result.text;
      todo.dueDate = result.dateTime;
      notifier.notify();
    }
  }

  void removeTodo(Todo todo) {
    notifier.value.remove(todo);
    notifier.notify();
  }
}

extension TodoDataHolderContextExtension on BuildContext {
  TodoDataHolder get holder => TodoDataHolder._of(this);
}
