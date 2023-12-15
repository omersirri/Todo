import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos/models/todo.dart';

class LocalTodoManager {
  static const String todosKey = 'todos';

  static Future<void> saveTodoLocally(Todo todo) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? todosData = prefs.getStringList(todosKey);

    todosData ??= [];

    todosData.add(todo.toMap().toString());
    prefs.setStringList(todosKey, todosData);
  }

  static Future<List<Todo>> getLocalTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosData = prefs.getStringList(todosKey);

    if (todosData != null) {
      try {
        return todosData
            .map((data) => Todo.fromJson(jsonDecode(data)))
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      return [];
    }
  }

  static Future<void> updateLocalTodo(Todo updatedTodo) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? todosData = prefs.getStringList(todosKey);

    if (todosData != null) {
      for (int i = 0; i < todosData.length; i++) {
        final Map<String, dynamic> todoMap =
            Todo.fromJson(jsonDecode(todosData[i])).toMap();
        if (todoMap['title'] == updatedTodo.title) {
          todosData[i] = updatedTodo.toMap().toString();
          prefs.setStringList(todosKey, todosData);
          break;
        }
      }
    }
  }

  static Future<void> deleteLocalTodo(Todo todo) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? todosData = prefs.getStringList(todosKey);

    if (todosData != null) {
      todosData.removeWhere((data) {
        final Map<String, dynamic> todoMap =
            Todo.fromJson(jsonDecode(data)).toMap();
        return todoMap['title'] == todo.title;
      });

      prefs.setStringList(todosKey, todosData);
    }
  }

  static Future<void> clearLocalTodos() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(todosKey);
  }
}
