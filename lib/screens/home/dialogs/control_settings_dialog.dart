import 'package:flutter/material.dart';
import '../../../providers/scrcpy_provider.dart';
import '../../../widgets/toggle_option.dart';
import 'config_dialog_helper.dart';

void showControlDialog(BuildContext context, ScrcpyProvider provider) {
  showConfigDialog(
    context: context,
    title: 'Control & Input',
    icon: Icons.touch_app_rounded,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final config = provider.config;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleOption(
              label: 'Control Enabled',
              value: config.controlEnabled,
              icon: Icons.touch_app_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.controlEnabled = v;
                  return c;
                });
                setState(() {});
              },
            ),
            if (config.controlEnabled) ...[
              ToggleOption(
                label: 'Show Touches',
                description: 'Show touch indicators on device',
                value: config.showTouches,
                icon: Icons.touch_app_outlined,
                onChanged: (v) {
                  provider.updateConfig((c) {
                    c.showTouches = v;
                    return c;
                  });
                  setState(() {});
                },
              ),
              ToggleOption(
                label: 'Forward All Clicks',
                description: 'Forward right/middle clicks',
                value: config.forwardAllClicks,
                icon: Icons.mouse_rounded,
                onChanged: (v) {
                  provider.updateConfig((c) {
                    c.forwardAllClicks = v;
                    return c;
                  });
                  setState(() {});
                },
              ),
              ToggleOption(
                label: 'Disable Clipboard Sync',
                value: config.noClipboardAutosync,
                icon: Icons.content_paste_off_rounded,
                onChanged: (v) {
                  provider.updateConfig((c) {
                    c.noClipboardAutosync = v;
                    return c;
                  });
                  setState(() {});
                },
              ),
              ToggleOption(
                label: 'No Key Repeat',
                description: 'Disable repeating key events on hold',
                value: config.noKeyRepeat,
                icon: Icons.keyboard_hide_rounded,
                onChanged: (v) {
                  provider.updateConfig((c) {
                    c.noKeyRepeat = v;
                    return c;
                  });
                  setState(() {});
                },
              ),
            ],
          ],
        );
      },
    ),
  );
}
