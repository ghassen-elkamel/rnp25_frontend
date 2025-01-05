
import 'package:flutter/material.dart';

class EnumStyle<E>{
  final E item;
  final Color color;
  final double size;
  final IconData? icon;

  EnumStyle({
    required this.item,
    this.color = Colors.black,
    this.size = 14,
    this.icon,
  });

  TextStyle getStyle(){
    return TextStyle(
      color: color,
      fontSize: size,
    );
  }
}