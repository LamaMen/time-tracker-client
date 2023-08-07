import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get key => _globalKey;

  void open() {
    final state = _globalKey.currentState;
    if (state == null) return;

    if (!state.isDrawerOpen) {
      state.openDrawer();
    }
  }

  void close() {
    final state = _globalKey.currentState;
    if (state == null) return;

    if (state.isDrawerOpen) {
      state.closeDrawer();
    }
  }
}
