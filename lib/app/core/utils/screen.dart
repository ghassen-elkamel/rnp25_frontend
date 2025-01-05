import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool isMobile(BuildContext context) {
  return !kIsWeb || MediaQuery.of(context).size.width < 750;
}
