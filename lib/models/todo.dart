import 'dart:convert';

class TodoResponse {
  final List<Todo> todos;
  final String status;

  TodoResponse({required this.todos, required this.status});
}

TodoResponse parseTodos(String responseBody) {
  try {
    dynamic jsonData = json.decode(responseBody);

    if (jsonData is List) {
      List<Todo> todosList = jsonData.map((todoJson) {
        print("TODO : " + todoJson.toString());
        return Todo.fromJson(todoJson);
      }).toList();

      return TodoResponse(todos: todosList, status: 'success');
    } else {
      print(jsonData);
      return TodoResponse(todos: [], status: 'jsonissue');
    }
  } catch (e) {
    return TodoResponse(todos: [], status: 'error $e');
  }
}

class Todo {
  int? userId;
  int? id;
  String? title;
  String? body;
  bool? completed;
  bool? isSync;

  Todo(
      {this.userId,
      this.id,
      this.title,
      this.body,
      this.completed,
      this.isSync});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userId: int.parse(json['userId'] ?? 0),
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      body: json['body'] ?? "",
      completed: json['completed'] ?? false,
      isSync: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
      'completed': completed,
      'isSync': false,
    };
  }
}
