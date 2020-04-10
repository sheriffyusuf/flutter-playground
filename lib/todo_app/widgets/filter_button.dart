import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_playground/todo_app/blocs/blocs.dart';
import 'package:flutter_playground/todo_app/models/models.dart';

class FilterButton extends StatelessWidget {
  final bool visible;

  FilterButton({Key key, this.visible}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.body1;
    final activeStyle = Theme.of(context)
        .textTheme
        .body1
        .copyWith(color: Theme.of(context).accentColor);
    return BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
      builder: (context, state) {
        final button = _Button(
          activeStyle: activeStyle,
          defaultStyle: defaultStyle,
          onSelected: (filter) {
            BlocProvider.of<FilteredTodosBloc>(context)
                .add(FilterUpdated(filter));
          },
          activeFilter: state is FilteredTodosLoaded
              ? state.activeFilter
              : VisibilityFilter.all,
        );
        return AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 150),
          child: visible ? button : IgnorePointer(child: button),
        );
      },
    );
  }
}

class _Button extends StatelessWidget {
  const _Button(
      {Key key,
      @required this.onSelected,
      @required this.activeFilter,
      @required this.activeStyle,
      @required this.defaultStyle})
      : super(key: key);

  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VisibilityFilter>(
      tooltip: 'Filter Todos',
      onSelected: onSelected,
      itemBuilder: (context) => <PopupMenuItem<VisibilityFilter>>[
        PopupMenuItem<VisibilityFilter>(
          value: VisibilityFilter.all,
          child: Text(
            'Show All',
            style: activeFilter == VisibilityFilter.all
                ? activeStyle
                : defaultStyle,
          ),
        ),
        PopupMenuItem<VisibilityFilter>(
          value: VisibilityFilter.active,
          child: Text(
            'Show Active',
            style: activeFilter == VisibilityFilter.active
                ? activeStyle
                : defaultStyle,
          ),
        ),
        PopupMenuItem<VisibilityFilter>(
          value: VisibilityFilter.completed,
          child: Text(
            'Show Completed',
            style: activeFilter == VisibilityFilter.completed
                ? activeStyle
                : defaultStyle,
          ),
        )
      ],
      icon: Icon(Icons.filter_list),
    );
  }
}
