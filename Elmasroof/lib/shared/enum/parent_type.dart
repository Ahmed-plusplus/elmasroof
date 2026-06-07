import 'package:flutter/material.dart';

enum ParentType {
  father('أب', Icons.face),
  mother('أم', Icons.face_3);

  final String type;
  final IconData icon;
  const ParentType(this.type, this.icon);

  @override
  String toString() => type;
}