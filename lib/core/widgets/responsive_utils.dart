import 'package:flutter/material.dart';

extension ReposniveContext on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < 900;

  bool get isDesktop => MediaQuery.of(this).size.width >= 900;
}

extension ReposniveWidget on Widget {
  Widget onlyNotDesktop(BuildContext context) =>
      !context.isDesktop ? this : const SizedBox.shrink();

  Widget onlyDesktop(BuildContext context) =>
      context.isDesktop ? this : const SizedBox.shrink();
}

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return desktop;
    }

    return mobile;
  }
}
