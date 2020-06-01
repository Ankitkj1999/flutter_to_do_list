import 'package:flutter/material.dart';
import 'dart:async';
import 'todoItem.dart';
import 'dataAccess.dart';
import 'addTodoItemScreen.dart';

class TodoListScreen extends StatefulWidget {
  TodoListScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodoListScreenState createState() => new _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoItem> _todoItems = List();
  DataAccess _dataAccess;

  _TodoListScreenState() {
    _dataAccess = DataAccess();
  }

  @override
  initState() {
    super.initState();
    _dataAccess.open().then((result) { 
      _dataAccess.getTodoItems()
                .then((r) {
                  setState(() { _todoItems = r; });
                });
    });
  }

  void _addTodoItem() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => AddTodoItemScreen()));
    _dataAccess.getTodoItems()
                .then((r) {
                  setState(() { _todoItems = r; });
                });
  }

  void _updateTodoCompleteStatus(TodoItem item, bool newStatus) {
    item.isComplete = newStatus;
    _dataAccess.updateTodo(item);
    _dataAccess.getTodoItems()
      .then((items) {
        setState(() { _todoItems = items; });
      });
  }

  void _deleteTodoItem(TodoItem item) {
    _dataAccess.deleteTodo(item);
    _dataAccess.getTodoItems()
      .then((items) {
        setState(() { _todoItems = items; });
      });
  }

  Future<Null> _displayDeleteConfirmationDialog(TodoItem item) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true, // Allow dismiss when tapping away from dialog
      builder: (BuildContext context) {
        return  AlertDialog(
          title: Text("Delete TODO"),
          content: Text("Do you want to delete \"${item.name}\"?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: Navigator.of(context).pop, // Close dialog
            ),
            FlatButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteTodoItem(item);
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      }
    );
  }

  Widget _createTodoItemWidget(TodoItem item) {
    return ListTile(
      title: Text(item.name),
      trailing: Checkbox(
        value: item.isComplete,
        onChanged: (value) => _updateTodoCompleteStatus(item, value),
      ),
      onLongPress: () => _displayDeleteConfirmationDialog(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    _todoItems.sort();
    final todoItemWidgets = _todoItems.map(_createTodoItemWidget).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: todoItemWidgets,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodoItem,
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }
}