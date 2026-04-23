import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimens.dart';

Future<void> showConfigDialog({
  required BuildContext context,
  required String title,
  required IconData icon,
  required WidgetBuilder builder,
  VoidCallback? onDone,
  VoidCallback? onCancel,
}) {
  return showDialog(
    context: context,
    builder: (ctx) {
      final primary = Theme.of(ctx).colorScheme.primary;
      return AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [primary, primary]),
                borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              ),
              child: Icon(icon, size: 16, color: Colors.white),
            ),
            const SizedBox(width: AppDimens.md),
            Text(
              title,
              style: const TextStyle(
                fontSize: AppDimens.fontLg,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(child: builder(ctx)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onDone?.call();
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Done',
              style: TextStyle(color: primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    },
  ).then((_) {});
}
