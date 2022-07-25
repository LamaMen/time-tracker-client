import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ProviderUtils on BuildContext {
  T notListenProvider<T>() => Provider.of<T>(this, listen: false);
}
