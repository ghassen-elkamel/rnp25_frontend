
import 'package:flutter/material.dart';

extension HexColor on String {
  Color toColor (){
    String formattedHex = toUpperCase().replaceAll("#", "");
    return Color(int.parse(formattedHex, radix: 16));
  }
}