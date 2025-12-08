import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../core/constants/colors.dart';
import 'components.dart';

class CommonDropdown extends StatelessWidget {
  final String? initialValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final double? borderRadius;
  final bool enabled;
  final String? customText;
  final String? hint; // 👈 Added hint property
  const CommonDropdown({
    super.key,
    this.customText,
    required this.items,
    this.initialValue,
    this.enabled = true, // default true
    this.borderRadius = 30.0,
    required this.onChanged,
    this.hint, // 👈 Added hint
  });

  @override
  Widget build(BuildContext context) {
    final displayText = customText ?? initialValue;
    return DropdownButtonFormField2<String>(
      value: (initialValue != null && items.contains(initialValue))
          ? initialValue
          : null,
      decoration: InputDecoration(
        enabled: enabled,
        border: commonTextFiledBorder(borderRadius: borderRadius,borderColor: color3.withValues(alpha: 0.05)),
        enabledBorder: commonTextFiledBorder(
            borderColor: color3.withValues(alpha: 0.5),
            borderRadius: borderRadius),
        focusedBorder: commonTextFiledBorder(borderRadius: borderRadius),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
      ),

      isExpanded: true,
      hint: hint != null
          ? loadSubText(
              fontSize: 12,
              title: displayText ?? hint ?? '',
              fontColor: displayText != null ? Colors.black : Colors.grey.shade500,
              textOverflow: TextOverflow.ellipsis,
            )
          : null,
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: loadSubText(title: item, textOverflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: enabled ? onChanged : null, // 👈 अब disable होगा
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
