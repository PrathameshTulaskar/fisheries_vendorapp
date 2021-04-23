import 'package:flutter/material.dart';

SnackBar errorOccured() {
  return SnackBar(
    content: Text('Something went wrong... try again.'),
    backgroundColor: Colors.red,
  );
}

SnackBar successNotify() {
  return SnackBar(
    content: Text('Success'),
    backgroundColor: Colors.green,
  );
}
