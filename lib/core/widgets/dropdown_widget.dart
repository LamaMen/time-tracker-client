import 'package:flutter/material.dart';
import 'package:time_tracker_client/core/theme/dimensions.dart';

class DropdownWidget<T> extends StatelessWidget {
  final List<T> _elements;
  final ValueChanged<T?>? _onChanged;
  final T? _currentElement;
  final String? hintText;
  final bool isExpanded;

  const DropdownWidget({
    Key? key,
    required List<T> elements,
    required ValueChanged<T?>? onChanged,
    required T? currentElement,
    this.hintText,
    this.isExpanded = false,
  })  : assert(currentElement != null || hintText != null),
        _elements = elements,
        _onChanged = onChanged,
        _currentElement = currentElement,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      isExpanded: isExpanded,
      value: _currentElement,
      icon: const Icon(Icons.keyboard_arrow_down),
      iconSize: defaultPadding * 3,
      hint: Text(hintText!),
      onChanged: _onChanged,
      items: _elements.map((T element) {
        return DropdownMenuItem<T>(
          value: element,
          child: Text(element.toString()),
        );
      }).toList(),
    );
  }
}
