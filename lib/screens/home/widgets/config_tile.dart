import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimens.dart';

class ConfigTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String summary;
  final bool hasCustom;
  final VoidCallback onTap;

  const ConfigTile({
    super.key,
    required this.icon,
    required this.title,
    required this.summary,
    required this.hasCustom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.xs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: AppDimens.animFast),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.md,
              vertical: AppDimens.sm + 2,
            ),
            decoration: BoxDecoration(
              color: hasCustom
                  ? primary.withValues(alpha: 0.06)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              border: Border.all(
                color: hasCustom
                    ? primary.withValues(alpha: 0.25)
                    : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: hasCustom
                        ? primary.withValues(alpha: 0.15)
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    size: 14,
                    color: hasCustom ? primary : AppColors.textHint,
                  ),
                ),
                const SizedBox(width: AppDimens.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: AppDimens.fontSm,
                          fontWeight: FontWeight.w600,
                          color: hasCustom ? primary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        summary,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textHint,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
