import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_playground/todo_app/blocs/blocs.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        if (state is StatsLoadInProgress) {
          return Center(child: CircularProgressIndicator());
        } else if (state is StatsLoaded) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Completed Todos",
                    style: Theme.of(context).textTheme.title,
                  )),
              Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  '${state.numCompleted}',
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Active Todos",
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  "${state.numActive}",
                  style: Theme.of(context).textTheme.subhead,
                ),
              )
            ],
          ));
        } else {
          return Container();
        }
      },
    );
  }
}
