import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/app_dimens.dart';
import '../../../providers/scrcpy_provider.dart';
import '../../../widgets/labeled_text_field.dart';
import '../../../widgets/toggle_option.dart';
import 'config_dialog_helper.dart';

void showDeviceDialog(BuildContext context, ScrcpyProvider provider) {
  showConfigDialog(
    context: context,
    title: 'Device Behavior',
    icon: Icons.phone_android_rounded,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final config = provider.config;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleOption(
              label: 'Turn Screen Off',
              description: 'Turn off device screen when mirroring',
              value: config.turnScreenOff,
              icon: Icons.screen_lock_portrait_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.turnScreenOff = v;
                  return c;
                });
                setState(() {});
              },
            ),
            ToggleOption(
              label: 'Stay Awake',
              description: 'Prevent device from sleeping',
              value: config.stayAwake,
              icon: Icons.coffee_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.stayAwake = v;
                  return c;
                });
                setState(() {});
              },
            ),
            ToggleOption(
              label: 'Power Off on Close',
              description: 'Turn off screen when scrcpy closes',
              value: config.powerOffOnClose,
              icon: Icons.power_settings_new_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.powerOffOnClose = v;
                  return c;
                });
                setState(() {});
              },
            ),
            ToggleOption(
              label: 'Disable Screensaver',
              description: 'Disable PC screensaver',
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
            LabeledTextField(
              label: 'Screen Off Timeout',
              hint: 'seconds',
              suffix: 'sec',
              icon: Icons.timer_rounded,
              value: config.screenOffTimeout?.toString() ?? '',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (v) => provider.updateConfig((c) {
                c.screenOffTimeout = v.isEmpty ? null : int.tryParse(v);
                return c;
              }),
            ),
            const SizedBox(height: AppDimens.lg),
            LabeledTextField(
              label: 'Push Target Directory',
              hint: '/sdcard/Download',
              icon: Icons.folder_rounded,
              value: config.pushTarget ?? '',
              onChanged: (v) => provider.updateConfig((c) {
                c.pushTarget = v.isEmpty ? null : v;
                return c;
              }),
            ),
          ],
        );
      },
    ),
  );
}
