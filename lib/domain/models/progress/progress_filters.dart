import 'package:flutter/material.dart';

class ProgressFilters {
  final bool isFull;
  final DateTimeRange? range;

  const ProgressFilters(this.isFull, this.range);

  factory ProgressFilters.initial() {
    return const ProgressFilters(false, null);
  }
}