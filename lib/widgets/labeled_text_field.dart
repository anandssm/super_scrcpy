import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../core/app_dimens.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? value;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final IconData? icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? suffix;
  final bool readOnly;
  final VoidCallback? onTap;

  const LabeledTextField({
    super.key,
    required this.label,
    this.hint,
    this.value,
    this.onChanged,
    this.controller,
    this.icon,
    this.keyboardType,
    this.inputFormatters,
    this.suffix,
    this.readOnly = false,
    this.onTap,
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
        SizedBox(
          height: AppDimens.inputHeight,
          child: TextField(
            controller:
                controller ??
                (value != null ? TextEditingController(text: value) : null),
            onChanged: onChanged,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            onTap: onTap,
            style: const TextStyle(
              fontSize: AppDimens.fontMd,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              suffixText: suffix,
              suffixStyle: const TextStyle(
                fontSize: AppDimens.fontSm,
                color: AppColors.textHint,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
