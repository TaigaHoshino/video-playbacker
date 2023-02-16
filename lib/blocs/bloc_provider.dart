import 'package:flutter/widgets.dart';

import 'app_bloc.dart';

class BlocProvider extends InheritedWidget {
  final AppBloc bloc;

  const BlocProvider({Key? key, required this.bloc, required Widget child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return oldWidget != this;
  }

  static BlocProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BlocProvider>();
  }
}
