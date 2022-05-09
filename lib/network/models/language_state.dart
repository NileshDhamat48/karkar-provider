import 'package:flutter/material.dart';

class LanguageState extends InheritedWidget {
  const LanguageState({
    Key? key,
    required this.locale,
    required this.setLanuage,
    required Widget child,
  }) : super(key: key, child: child);

  final Locale locale;
  final Function(Locale local) setLanuage;
  static LanguageState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LanguageState>();
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(LanguageState old) => locale != old.locale;
}
