import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_dimens.dart';

class ToggleOption extends StatelessWidget {
  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;

  const ToggleOption({
    super.key,
    required this.label,
    this.description,
    required this.value,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.xs),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppDimens.iconMd, color: AppColors.textHint),
            const SizedBox(width: AppDimens.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: AppDimens.fontMd,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (description != null)
                  Text(
                    description!,
                    style: const TextStyle(
                      fontSize: AppDimens.fontSm,
                      color: AppColors.textHint,
                    ),
                  ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
