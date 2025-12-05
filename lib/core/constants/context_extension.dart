import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {}

extension StringCasingExtension on String {
  String toCapitalize() {
    if (isEmpty) return this; // Prevent crash on empty string

    var result = this[0].toUpperCase();
    for (int i = 1; i < length; i++) {
      if (this[i - 1] == " ") {
        result = result + this[i].toUpperCase();
      } else {
        result = result + this[i];
      }
    }
    return result;
  }
  String toTitleCase() {
    return replaceAll("_", " ") // remove underscores and replace with space
        .split(" ")
        .map((word) => word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1).toLowerCase()
        : "")
        .join(" ");
  }
}