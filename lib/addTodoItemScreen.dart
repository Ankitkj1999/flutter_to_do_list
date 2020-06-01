import 'package:flutter/material.dart';
import 'dataAccess.dart';
import 'todoItem.dart';

class AddTodoItemScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AddTodoItemScreenState();
}

class _AddTodoItemScreenState extends State<AddTodoItemScreen> {
  final _todoNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add Todo Item")),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Todo Name"),
                controller: _todoNameController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text("Save"),
                    onPressed: () {
                      // Here we're depending on TodoListScreen to have opened our database
                      // In a real app we would want to design this more robustly
                      DataAccess().insertTodo(TodoItem(name: _todoNameController.text));
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          )
        )
      );
  }

  @override
  void dispose() {
    _todoNameController.dispose();
    super.dispose();
  }
}