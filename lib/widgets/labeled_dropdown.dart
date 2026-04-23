import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_dimens.dart';

class LabeledDropdown<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final IconData? icon;

  const LabeledDropdown({
    super.key,
    required this.label,
    this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppDimens.iconSm, color: AppColors.textHint),
              const SizedBox(width: AppDimens.sm),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: AppDimens.fontSm,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.sm),
        Container(
          height: AppDimens.inputHeight,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              isExpanded: true,
              dropdownColor: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
              style: const TextStyle(
                fontSize: AppDimens.fontMd,
                color: AppColors.textPrimary,
              ),
              hint: hint != null
                  ? Text(
                      hint!,
                      style: const TextStyle(color: AppColors.textHint),
                    )
                  : null,
              icon: const Icon(
                Icons.expand_more,
                color: AppColors.textHint,
                size: AppDimens.iconMd,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
