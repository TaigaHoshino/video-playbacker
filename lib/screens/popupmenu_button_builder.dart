import 'package:flutter/material.dart';

class PopupMenuButtonBuilder {

  final List<Widget> _widgets = [];
  final List<Function> _functions = [];

  void addMenu(Widget widget, Function onSelected) {
      _widgets.add(widget);
      _functions.add(onSelected);
  }

  PopupMenuButton build() {

    List<PopupMenuItem<int>> menuItems = [];

    for(int i = 0; i < _widgets.length; i++) {
      menuItems.add(PopupMenuItem(value: i, child: _widgets.elementAt(i)));
    }

    return PopupMenuButton<int>(
      onSelected: ((value) {
        _functions.elementAt(value).call();
      }),
      itemBuilder: (context) => [...menuItems]);
  }
}