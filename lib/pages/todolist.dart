import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:todos/api/globalapi.dart';
import 'package:todos/models/todo.dart';
//import 'package:todos/localtodomanger.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  int id = 0;
  String title = "";
  String description = "";
  bool checked = false;
  bool isLoading = true;
  bool pandelclosed = true;
  bool somthingwentwrong = false;
  bool edit = false;
  bool isProccing = false;

  Todo? selectedTodo;

  final PanelController _panelController = PanelController();

  List<Todo> mytodos = [];

  void loadmyTODOs() {
    setState(() {
      isLoading = true;
      somthingwentwrong = false;
    });
    GlobalApi.getAllTodos().then((value) {
      print(value.status);
      if (value.status == "success") {
        setState(() {
          mytodos = value.todos.take(13).toList();
          isLoading = false;
          somthingwentwrong = false;
        });
      } else {
        setState(() {
          isLoading = false;
          somthingwentwrong = true;
        });
      }
    });

    // LocalTodoManager.getLocalTodos().then((value) {
    //   setState(() {
    //     isLoading = false;
    //     mytodos.addAll(value);
    //   });
    // });
  }

  @override
  void initState() {
    super.initState();
    loadmyTODOs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Awesome Todo List"),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 0)).then((value) {
              loadmyTODOs();
            });
          },
          child: Stack(children: [
            SafeArea(
                child: somthingwentwrong
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Sorry Somthing Went Wrong :("),
                            TextButton(
                                onPressed: () {
                                  loadmyTODOs();
                                },
                                child: const Text("Try Again"))
                          ],
                        ),
                      )
                    : isLoading
                        ? const Center(
                            child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: LinearProgressIndicator(),
                          ))
                        : mytodos.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Your Todo List is Empty "),
                                    const SizedBox(
                                      height: 13,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          edit = false;
                                        });
                                        _panelController.open();
                                      },
                                      child: Text(
                                        "Let's add one now !".toUpperCase(),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                    itemCount: mytodos.length,
                                    itemBuilder: (context, index) {
                                      Todo todo = mytodos[index];
                                      return GestureDetector(
                                          onDoubleTap: () {
                                            setState(() {
                                              todo.completed = !todo.completed!;
                                            });
                                          },
                                          onHorizontalDragUpdate: (h) {
                                            setState(() {
                                              todo.completed = true;
                                            });
                                          },
                                          onLongPress: () {
                                            setState(() {
                                              selectedTodo = todo;
                                              titleController.text =
                                                  todo.title!;
                                              bodyController.text = todo.body!;
                                              edit = true;
                                            });
                                            _panelController.open();
                                          },
                                          child: StickyNoteCard(todo: todo));
                                    }),
                              )),
            SlidingUpPanel(
              onPanelClosed: () {
                setState(() {
                  pandelclosed = true;
                });
              },
              onPanelOpened: () {
                setState(() {
                  pandelclosed = false;
                });
              },
              defaultPanelState: PanelState.CLOSED,
              minHeight: 0,
              maxHeight: MediaQuery.of(context).size.height * 0.70,
              controller: _panelController,
              backdropEnabled: true,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              panel: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: GestureDetector(
                            onTap: () {
                              _panelController.close();
                            },
                            child: Center(
                              child: Container(
                                width: 25,
                                height: 5,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 189, 188, 188),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: titleController,
                          initialValue: edit ? title : null,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: myDecoration("Title"),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Please enter task Title";
                            }
                            title = value;
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: bodyController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Please enter task description";
                            }
                            description = value;
                            return null;
                          },
                          maxLines: 4,
                          decoration: myDecoration("Description").copyWith(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Checkbox(
                        //         value: checked,
                        //         onChanged: (value) {
                        //           setState(() {
                        //             checked = value!;
                        //           });
                        //         }),
                        //     const Text(
                        //       "Completed",
                        //       style: TextStyle(fontSize: 20),
                        //     )
                        //   ],
                        // ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      backgroundColor: MaterialStatePropertyAll(
                                          edit ? Colors.blue : Colors.green)),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      edit
                                          ? editNote(selectedTodo!)
                                          : addNote();
                                    }
                                  },
                                  icon: edit
                                      ? const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        )
                                      : const Icon(
                                          LineIcons.plusCircle,
                                          color: Colors.white,
                                        ),
                                  label: Text(
                                    edit
                                        ? "Edit".toUpperCase()
                                        : "Add".toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (edit)
                              Expanded(
                                child: TextButton.icon(
                                    style: ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                Colors.red)),
                                    onPressed: () {
                                      deleteNote(selectedTodo!);
                                    },
                                    icon: const Icon(
                                      LineIcons.trash,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "delete".toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                              ),
                          ],
                        )
                      ],
                    ),
                  )),
            )
          ]),
        ),
        floatingActionButton: Visibility(
          visible: pandelclosed,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                edit = false;
              });
              _panelController.open();
            },
            tooltip: 'add',
            child: isProccing
                ? const SizedBox(
                    height: 20, width: 20, child: CircularProgressIndicator())
                : const Icon(Icons.add),
          ),
        ));
  }

  InputDecoration myDecoration(String hint) {
    return InputDecoration(
        hintText: hint,
        labelText: hint,
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(5),
        ));
  }

  void addNote() {
    setState(() {
      isProccing = true;
    });
    _panelController.close();
    GlobalApi.createTodos(title, description).then((value) {
      if (value.status == "true") {
        setState(() {
          isProccing = false;
          mytodos.insert(0, value.todos.first);
          _formKey.currentState!.reset();

          //  LocalTodoManager.saveTodoLocally(value.todos.first);
        });
      } else {
        setState(() {
          isProccing = false;
          // LocalTodoManager.saveTodoLocally(Todo(
          //     id: 0,
          //     title: title,
          //     body: description,
          //     completed: checked,
          //     isSync: false));
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Sorry somthing went wrong")));
      }
    });
  }

  void editNote(Todo todo) {
    setState(() {
      isProccing = true;
    });
    _panelController.close();
    GlobalApi.updateTodo(todo.id!, title, description).then((value) {
      if (value.status == "true") {
        setState(() {
          isProccing = false;
          todo = value.todos.first;
        });
      } else {
        setState(() {
          todo.title = title;
          todo.body = description;
          todo.completed = checked;
          todo.isSync = false;
          isProccing = false;
        });

        // LocalTodoManager.saveTodoLocally(todo);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("only updated locally, please check your internet")));
      }
    });
  }

  void deleteNote(Todo todo) {
    setState(() {
      isProccing = true;
    });
    _panelController.close();
    GlobalApi.deleteTodo(todo.id!).then((value) {
      if (value == "true") {
        setState(() {
          isProccing = false;
          mytodos.remove(todo);
        });
      } else {
        setState(() {
          isProccing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Sorry somthing went wrong")));
      }
    });
  }
}

class StickyNoteCard extends StatelessWidget {
  const StickyNoteCard({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(230, 205, 109, 1),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title!,
              style: TextStyle(
                fontWeight:
                    todo.completed! ? FontWeight.normal : FontWeight.bold,
                decoration: todo.completed!
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: todo.completed!
                    ? Colors.black.withOpacity(0.4)
                    : Colors.black,
                fontSize: 16.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                todo.body!,
                style: TextStyle(
                  decoration: todo.completed!
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: todo.completed!
                      ? const Color.fromARGB(255, 87, 87, 87).withOpacity(0.4)
                      : const Color.fromARGB(255, 87, 87, 87),
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StickyNoteClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 20); // Left bottom corner
    path.quadraticBezierTo(
        0, size.height, 20, size.height); // Bottom left curve
    path.lineTo(size.width - 20, size.height); // Bottom right corner
    path.quadraticBezierTo(size.width, size.height, size.width,
        size.height - 20); // Bottom right curve
    path.lineTo(size.width, 0); // Right top corner

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
