import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimens.dart';
import '../../../providers/scrcpy_provider.dart';
import 'config_dialog_helper.dart';

void showLibraryDialog(BuildContext context, ScrcpyProvider provider) {
  showConfigDialog(
    context: context,
    title: 'scrcpy Library',
    icon: Icons.folder_special_rounded,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final path = provider.scrcpyPath;
        final version = provider.scrcpyVersion;
        final isConfigured = provider.isPathConfigured;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.md),
              decoration: BoxDecoration(
                color: isConfigured
                    ? AppColors.success.withValues(alpha: 0.08)
                    : AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                border: Border.all(
                  color: isConfigured
                      ? AppColors.success.withValues(alpha: 0.25)
                      : AppColors.warning.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isConfigured
                        ? Icons.check_circle_rounded
                        : Icons.warning_amber_rounded,
                    size: 20,
                    color: isConfigured ? AppColors.success : AppColors.warning,
                  ),
                  const SizedBox(width: AppDimens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isConfigured ? 'scrcpy found' : 'scrcpy not found',
                          style: TextStyle(
                            fontSize: AppDimens.fontMd,
                            fontWeight: FontWeight.w600,
                            color: isConfigured
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                        if (version != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            version,
                            style: const TextStyle(
                              fontSize: AppDimens.fontSm,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.lg),

            const Text(
              'Library Path',
              style: TextStyle(
                fontSize: AppDimens.fontSm,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimens.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.md,
                vertical: AppDimens.sm + 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                path.isNotEmpty ? path : 'Not configured',
                style: TextStyle(
                  fontSize: AppDimens.fontSm,
                  color: path.isNotEmpty
                      ? AppColors.textPrimary
                      : AppColors.textHint,
                  fontFamily: 'monospace',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: AppDimens.lg),

            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.folder_open_rounded,
                    label: 'Browse',
                    onPressed: () async {
                      final result = await FilePicker.getDirectoryPath(
                        dialogTitle: 'Select scrcpy folder',
                      );
                      if (result != null) {
                        await provider.setScrcpyPath(result);
                        setState(() {});
                      }
                    },
                  ),
                ),
                const SizedBox(width: AppDimens.md),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.search_rounded,
                    label: 'Auto-detect',
                    onPressed: () async {
                      final detected = await provider.service.autoDetect();
                      if (detected) {
                        await provider.setScrcpyPath(
                          provider.service.scrcpyPath,
                        );
                        setState(() {});
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                              content: Text('scrcpy detected successfully!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } else {
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Could not find scrcpy. Please browse manually.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.lg),

            Container(
              padding: const EdgeInsets.all(AppDimens.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: AppColors.textHint,
                  ),
                  SizedBox(width: AppDimens.sm),
                  Expanded(
                    child: Text(
                      'Point to the folder containing the scrcpy and adb '
                      'executables. You can download scrcpy from '
                      'github.com/Genymobile/scrcpy.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.md,
          vertical: AppDimens.sm + 2,
        ),
      ),
    );
  }
}
