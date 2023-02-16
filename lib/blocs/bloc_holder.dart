import 'package:flutter/widgets.dart';
import 'package:video_playbacker/blocs/app_bloc.dart';

import 'bloc_provider.dart';

class BlocHolder extends StatefulWidget {
  final Widget child;

  const BlocHolder({Key? key, required this.child}): super(key: key);

  @override
  _BlocHolderState createState() => _BlocHolderState();
}

class _BlocHolderState extends State<BlocHolder> {
  final _bloc = AppBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(bloc: _bloc, child: widget.child,);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}