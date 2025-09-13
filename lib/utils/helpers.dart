import 'package:flutter/material.dart';

void push(BuildContext context, String route, {Object? args}) {
  Navigator.pushNamed(context, route, arguments: args);
}

void replace(BuildContext context, String route, {Object? args}) {
  Navigator.pushReplacementNamed(context, route, arguments: args);
}
