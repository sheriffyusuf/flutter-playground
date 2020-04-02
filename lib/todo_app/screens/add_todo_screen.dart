import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_playground/todo_app/models/models.dart';

typedef OnSaveCallback = Function(String task, String note);

class AddTodoScreen extends StatefulWidget {
  AddTodoScreen({Key key, @required this.onSave, this.todo}) : super(key: key);

  final OnSaveCallback onSave;
  final Todo todo;

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title;
  String _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Add New Todo")),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.onSave(_title, _description);
                Navigator.pop(context);
              }
            }),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Neumorphic(
                style: NeumorphicStyle(depth: -1),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration.collapsed(hintText: "Title"),
                    validator: (value) =>
                        value.length == 0 ? "Title cannot be empty" : null,
                    onSaved: (value) => _title = value,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Neumorphic(
                style: NeumorphicStyle(depth: -1),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: TextFormField(
                    decoration:
                        InputDecoration.collapsed(hintText: "Description"),
                    maxLines: 8,
                    onSaved: (value) => _description = value,
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}
