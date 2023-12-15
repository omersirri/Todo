import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todos/models/todo.dart';

class GlobalApi {
  static String liveMainUrl =
      "https://jsonplaceholder.typicode.com/users/1/todos/";

  static Future<TodoResponse> getAllTodos() async {
    try {
      final http.Response response = await http.get(
        Uri.parse(liveMainUrl),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 60), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return parseTodos(response.body);
      } else {
        return TodoResponse(todos: [], status: 'error');
      }
    } catch (e) {
      return TodoResponse(todos: [], status: 'internet');
    }
  }

  static Future<TodoResponse> createTodos(String title, String body) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(liveMainUrl),
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'body': body,
          'userId': 1,
        }),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 60), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TodoResponse(
            todos: [Todo.fromJson(jsonDecode(response.body))], status: 'true');
      } else {
        return TodoResponse(todos: [], status: 'error');
      }
    } catch (e) {
      print(e.toString());
      return TodoResponse(todos: [], status: 'internet');
    }
  }

  static Future<TodoResponse> updateTodo(
      int id, String title, String body) async {
    try {
      final http.Response response = await http.put(
        Uri.parse("https://jsonplaceholder.typicode.com/todos/$id"),
        body: jsonEncode(<String, dynamic>{
          'id': id,
          'title': title,
          'body': body,
          'userId': 1,
        }),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 60), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TodoResponse(
            todos: [Todo.fromJson(jsonDecode(response.body))], status: 'true');
      } else {
        return TodoResponse(todos: [], status: 'error');
      }
    } catch (e) {
      return TodoResponse(todos: [], status: 'internet');
    }
  }

  static Future<String> deleteTodo(int id) async {
    try {
      final http.Response response = await http.delete(
        Uri.parse("https://jsonplaceholder.typicode.com/todos/$id"),
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 60), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return "true";
      } else {
        return 'error';
      }
    } catch (e) {
      return 'internet';
    }
  }
}
