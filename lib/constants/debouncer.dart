import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? timer;

  Debouncer({
    required this.milliseconds,
    this.action,
    this.timer,
  });

  run(VoidCallback action) {
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
