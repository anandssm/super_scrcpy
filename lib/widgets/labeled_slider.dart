import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_dimens.dart';

class LabeledSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String Function(double)? valueLabel;
  final ValueChanged<double> onChanged;
  final IconData? icon;

  const LabeledSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.valueLabel,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppDimens.iconSm, color: AppColors.textHint),
              const SizedBox(width: AppDimens.sm),
            ],
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: AppDimens.fontSm,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.sm,
                vertical: AppDimens.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceHighlight,
                borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              ),
              child: Text(
                valueLabel?.call(value) ?? value.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: AppDimens.fontSm,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.xs),
        SliderTheme(
          data: Theme.of(context).sliderTheme,
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
