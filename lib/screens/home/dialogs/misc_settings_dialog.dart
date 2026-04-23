import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimens.dart';
import '../../../providers/scrcpy_provider.dart';
import '../../../widgets/labeled_dropdown.dart';
import '../../../widgets/labeled_text_field.dart';
import '../../../widgets/toggle_option.dart';
import 'config_dialog_helper.dart';

void showMiscDialog(BuildContext context, ScrcpyProvider provider) {
  showConfigDialog(
    context: context,
    title: 'Connection & Misc',
    icon: Icons.settings_ethernet_rounded,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final config = provider.config;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleOption(
              label: 'Force ADB Forward',
              value: config.forceAdbForward,
              icon: Icons.sync_alt_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.forceAdbForward = v;
                  return c;
                });
                setState(() {});
              },
            ),
            const SizedBox(height: AppDimens.lg),
            Row(
              children: [
                Expanded(
                  child: LabeledTextField(
                    label: 'Tunnel Host',
                    hint: 'IP address',
                    value: config.tunnelHost ?? '',
                    onChanged: (v) => provider.updateConfig((c) {
                      c.tunnelHost = v.isEmpty ? null : v;
                      return c;
                    }),
                  ),
                ),
                const SizedBox(width: AppDimens.lg),
                Expanded(
                  child: LabeledTextField(
                    label: 'Tunnel Port',
                    hint: 'Port',
                    value: config.tunnelPort?.toString() ?? '',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) => provider.updateConfig((c) {
                      c.tunnelPort = v.isEmpty ? null : int.tryParse(v);
                      return c;
                    }),
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.border, height: 32),
            LabeledTextField(
              label: 'Time Limit',
              hint: 'Auto-stop after N seconds',
              suffix: 'sec',
              icon: Icons.timer_rounded,
              value: config.timeLimit?.toString() ?? '',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (v) => provider.updateConfig((c) {
                c.timeLimit = v.isEmpty ? null : int.tryParse(v);
                return c;
              }),
            ),
            const Divider(color: AppColors.border, height: 32),
            ToggleOption(
              label: 'No Video',
              value: config.noVideo,
              icon: Icons.videocam_off_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.noVideo = v;
                  return c;
                });
                setState(() {});
              },
            ),
            ToggleOption(
              label: 'No Audio',
              value: config.noAudio,
              icon: Icons.volume_off_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.noAudio = v;
                  return c;
                });
                setState(() {});
              },
            ),
            ToggleOption(
              label: 'No Control',
              value: config.noControl,
              icon: Icons.do_not_touch_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.noControl = v;
                  return c;
                });
                setState(() {});
              },
            ),
            ToggleOption(
              label: 'No Cleanup',
              value: config.noCleanup,
              icon: Icons.cleaning_services_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.noCleanup = v;
                  return c;
                });
                setState(() {});
              },
            ),
            ToggleOption(
              label: 'Disable Screensaver',
              value: config.disableScreensaver,
              icon: Icons.desktop_access_disabled_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.disableScreensaver = v;
                  return c;
                });
                setState(() {});
              },
            ),
            const SizedBox(height: AppDimens.lg),
            LabeledDropdown<String>(
              label: 'Log Level',
              value: config.logLevel,
              items: const [
                DropdownMenuItem(value: 'verbose', child: Text('Verbose')),
                DropdownMenuItem(value: 'debug', child: Text('Debug')),
                DropdownMenuItem(value: 'info', child: Text('Info (Default)')),
                DropdownMenuItem(value: 'warn', child: Text('Warn')),
                DropdownMenuItem(value: 'error', child: Text('Error')),
              ],
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.logLevel = v ?? 'info';
                  return c;
                });
                setState(() {});
              },
            ),
          ],
        );
      },
    ),
  );
}
