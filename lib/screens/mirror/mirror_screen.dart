import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../providers/scrcpy_provider.dart';
import '../../models/scrcpy_config.dart';

class MirrorScreen extends StatelessWidget {
  const MirrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final provider = context.watch<ScrcpyProvider>();

    return Padding(
      padding: const EdgeInsets.all(AppDimens.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, provider, primary),
          const SizedBox(height: AppDimens.md),

          _buildStatusCard(context, provider),
          const SizedBox(height: AppDimens.sm),

          _buildConfigSummary(context, provider, primary),
          const SizedBox(height: AppDimens.sm),

          _buildCommandPreview(context, provider, primary),
          const SizedBox(height: AppDimens.sm),

          _buildQuickConfig(context, provider, primary),
          const SizedBox(height: AppDimens.md),

          _buildActionButtons(context, provider, primary),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ScrcpyProvider provider,
    Color primary,
  ) {
    final hasCustomConfig = _countCustomOptions(provider.config) > 0;

    return Row(
      children: [
        Icon(Icons.cast_rounded, size: 18, color: primary),
        const SizedBox(width: AppDimens.xs),
        const Text(
          'Mirror',
          style: TextStyle(
            fontSize: AppDimens.fontMd,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),

        if (hasCustomConfig)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showResetConfirmation(context, provider),
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: AppDimens.animFast),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.restart_alt_rounded,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildConfigSummary(
    BuildContext context,
    ScrcpyProvider provider,
    Color primary,
  ) {
    final count = _countCustomOptions(provider.config);
    if (count == 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.sm,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
        child: const Row(
          children: [
            Icon(Icons.tune_rounded, size: 15, color: AppColors.textHint),
            SizedBox(width: 6),
            Text(
              'Default configuration',
              style: TextStyle(fontSize: 12, color: AppColors.textHint),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(color: primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.tune_rounded, size: 15, color: primary),
          const SizedBox(width: 6),
          Text(
            '$count custom option${count > 1 ? 's' : ''} applied',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: primary,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () => _showResetConfirmation(context, provider),
            child: Icon(Icons.close_rounded, size: 15, color: primary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, ScrcpyProvider provider) {
    final device = provider.selectedDevice;
    final isRunning = provider.isRunning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.md),
      decoration: BoxDecoration(
        color: isRunning
            ? AppColors.success.withValues(alpha: 0.06)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(
          color: isRunning
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: AppDimens.animFast),
            padding: const EdgeInsets.all(AppDimens.sm),
            decoration: BoxDecoration(
              color:
                  (isRunning ? AppColors.success : AppColors.surfaceHighlight)
                      .withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRunning
                  ? Icons.screen_share_rounded
                  : Icons.screen_share_outlined,
              size: 22,
              color: isRunning ? AppColors.success : AppColors.textHint,
            ),
          ),
          const SizedBox(width: AppDimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRunning ? 'Mirroring Active' : 'Ready',
                  style: TextStyle(
                    fontSize: AppDimens.fontSm,
                    fontWeight: FontWeight.w600,
                    color: isRunning
                        ? AppColors.success
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                if (device != null)
                  Row(
                    children: [
                      Icon(
                        device.isWifi ? Icons.wifi_rounded : Icons.usb_rounded,
                        size: 14,
                        color: device.isWifi
                            ? AppColors.deviceWifi
                            : AppColors.deviceUsb,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${device.displayName} · ${device.serial}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                else
                  const Text(
                    'No device selected',
                    style: TextStyle(fontSize: 12, color: AppColors.textHint),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandPreview(
    BuildContext context,
    ScrcpyProvider provider,
    Color primary,
  ) {
    final entries = provider.config.getConfigEntries();
    final command = provider.buildCommandPreview();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.terminal_rounded, size: 15, color: primary),
              const SizedBox(width: 4),
              Text(
                'Command',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: command));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied', style: TextStyle(fontSize: 13)),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          if (entries.isNotEmpty)
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                _buildBaseChip(provider, primary),

                ...entries.map(
                  (entry) =>
                      _buildConfigChip(context, provider, entry, primary),
                ),
              ],
            )
          else
            SelectableText(
              command,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontFamily: 'monospace',
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBaseChip(ScrcpyProvider provider, Color primary) {
    final device = provider.selectedDevice;
    final baseCmd = device != null ? 'scrcpy -s ${device.serial}' : 'scrcpy';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: primary.withValues(alpha: 0.25)),
      ),
      child: Text(
        baseCmd,
        style: TextStyle(
          fontSize: 11,
          fontFamily: 'monospace',
          fontWeight: FontWeight.w600,
          color: primary,
        ),
      ),
    );
  }

  Widget _buildConfigChip(
    BuildContext context,
    ScrcpyProvider provider,
    ConfigEntry entry,
    Color primary,
  ) {
    return Container(
      padding: const EdgeInsets.only(left: 6, top: 2, bottom: 2, right: 2),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            entry.label,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              color: primary,
            ),
          ),
          const SizedBox(width: 3),
          InkWell(
            onTap: () => provider.resetSingleConfigKey(entry.configKey),
            borderRadius: BorderRadius.circular(3),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Icon(
                Icons.content_cut_rounded,
                size: 13,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickConfig(
    BuildContext context,
    ScrcpyProvider provider,
    Color primary,
  ) {
    final config = provider.config;

    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = (constraints.maxWidth - 12) / 4;
        final showLabels = buttonWidth >= 70;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bolt_rounded, size: 16, color: primary),
                SizedBox(width: 4),
                Text(
                  'Quick Config',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              children: [
                Expanded(
                  child: _quickToggle(
                    icon: Icons.screen_rotation_rounded,
                    label: 'Landscape',
                    isActive: config.captureOrientation == '90',
                    showLabel: showLabels,
                    onTap: () => provider.updateConfig((c) {
                      c.captureOrientation = c.captureOrientation == '90'
                          ? null
                          : '90';
                      return c;
                    }),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _quickToggle(
                    icon: Icons.add_to_queue_rounded,
                    label: 'New Display',
                    isActive: config.useNewDisplay,
                    showLabel: showLabels,
                    onTap: () => provider.updateConfig((c) {
                      c.useNewDisplay = !c.useNewDisplay;
                      return c;
                    }),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _quickToggle(
                    icon: Icons.speed_rounded,
                    label: 'Bitrate 8M',
                    isActive: config.videoBitRate == 8000000,
                    showLabel: showLabels,
                    onTap: () => provider.updateConfig((c) {
                      c.videoBitRate = c.videoBitRate == 8000000
                          ? null
                          : 8000000;
                      return c;
                    }),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _quickToggle(
                    icon: Icons.fullscreen_rounded,
                    label: 'Fullscreen',
                    isActive: config.fullscreen,
                    showLabel: showLabels,
                    onTap: () => provider.updateConfig((c) {
                      c.fullscreen = !c.fullscreen;
                      return c;
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            Row(
              children: [
                Expanded(
                  child: _quickToggle(
                    icon: Icons.volume_off_rounded,
                    label: 'No Audio',
                    isActive: !config.audioEnabled,
                    showLabel: showLabels,
                    onTap: () => provider.updateConfig((c) {
                      c.audioEnabled = !c.audioEnabled;
                      return c;
                    }),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _quickToggle(
                    icon: Icons.vertical_align_top_rounded,
                    label: 'On Top',
                    isActive: config.alwaysOnTop,
                    showLabel: showLabels,
                    onTap: () => provider.updateConfig((c) {
                      c.alwaysOnTop = !c.alwaysOnTop;
                      return c;
                    }),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _quickToggle(
                    icon: Icons.mobile_screen_share_rounded,
                    label: 'Screen Off',
                    isActive: config.turnScreenOff,
                    showLabel: showLabels,
                    onTap: () => provider.updateConfig((c) {
                      c.turnScreenOff = !c.turnScreenOff;
                      return c;
                    }),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _quickToggle(
                    icon: Icons.border_clear_rounded,
                    label: 'Borderless',
                    isActive: config.borderless,
                    showLabel: showLabels,
                    onTap: () => provider.updateConfig((c) {
                      c.borderless = !c.borderless;
                      return c;
                    }),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _quickToggle({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    bool showLabel = true,
  }) {
    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: AppDimens.animFast),
          padding: EdgeInsets.symmetric(
            horizontal: showLabel ? 8 : 0,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.success.withValues(alpha: 0.12)
                : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            border: Border.all(
              color: isActive
                  ? AppColors.success.withValues(alpha: 0.5)
                  : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isActive ? AppColors.success : AppColors.textHint,
              ),
              if (showLabel) ...[
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? AppColors.successLight
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
              if (isActive) ...[
                const SizedBox(width: 3),
                Icon(
                  Icons.check_circle_rounded,
                  size: 13,
                  color: AppColors.success.withValues(alpha: 0.8),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (!showLabel) {
      return Tooltip(message: label, preferBelow: true, child: button);
    }
    return button;
  }

  Widget _buildActionButtons(
    BuildContext context,
    ScrcpyProvider provider,
    Color primary,
  ) {
    return SizedBox(
      height: 36,
      width: double.infinity,
      child: provider.isRunning
          ? ElevatedButton.icon(
              onPressed: provider.stopMirror,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
              ),
              icon: const Icon(Icons.stop_rounded, size: 20),
              label: const Text(
                'Stop',
                style: TextStyle(
                  fontSize: AppDimens.fontSm,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: provider.selectedDevice != null
                  ? () async {
                      final ok = await provider.startMirror();
                      if (!ok && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Failed. Check console.',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                disabledBackgroundColor: primary.withValues(alpha: 0.3),
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
              ),
              icon: const Icon(Icons.play_arrow_rounded, size: 22),
              label: const Text(
                'Start Mirroring',
                style: TextStyle(
                  fontSize: AppDimens.fontSm,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  void _showResetConfirmation(BuildContext context, ScrcpyProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Row(
          children: [
            Icon(Icons.restart_alt_rounded, size: 22, color: AppColors.warning),
            SizedBox(width: AppDimens.sm),
            Text(
              'Reset Configuration',
              style: TextStyle(
                fontSize: AppDimens.fontMd,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: const Text(
          'This will reset all scrcpy options back to their defaults. This action cannot be undone.',
          style: TextStyle(
            fontSize: AppDimens.fontSm,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppDimens.fontSm,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              provider.resetConfig();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: AppColors.success,
                      ),
                      SizedBox(width: AppDimens.sm),
                      Text(
                        'Configuration reset to defaults',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.surfaceLight,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.md,
                vertical: AppDimens.sm,
              ),
            ),
            icon: const Icon(Icons.restart_alt_rounded, size: 18),
            label: const Text(
              'Reset',
              style: TextStyle(
                fontSize: AppDimens.fontSm,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _countCustomOptions(ScrcpyConfig config) {
    return config.getConfigEntries().length;
  }
}
