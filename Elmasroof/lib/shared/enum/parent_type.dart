import 'package:flutter/material.dart';

enum ParentType {
  FATHER('أب', Icons.man),
  MOTHER('أم', Icons.woman);

  final String type;
  final IconData icon;
  const ParentType(this.type, this.icon);

  @override
  String toString() => type;
}