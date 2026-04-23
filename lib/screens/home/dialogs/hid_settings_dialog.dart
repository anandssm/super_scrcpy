import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimens.dart';
import '../../../providers/scrcpy_provider.dart';
import '../../../widgets/labeled_dropdown.dart';
import '../../../widgets/toggle_option.dart';
import 'config_dialog_helper.dart';

void showHidDialog(BuildContext context, ScrcpyProvider provider) {
  showConfigDialog(
    context: context,
    title: 'HID & OTG',
    icon: Icons.keyboard_rounded,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final config = provider.config;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LabeledDropdown<String>(
              label: 'Keyboard Mode',
              icon: Icons.keyboard_alt_rounded,
              value: config.keyboardMode,
              hint: 'Default (sdk)',
              items: const [
                DropdownMenuItem(value: null, child: Text('Default (sdk)')),
                DropdownMenuItem(value: 'uhid', child: Text('UHID')),
                DropdownMenuItem(value: 'aoa', child: Text('AOA (USB only)')),
                DropdownMenuItem(value: 'disabled', child: Text('Disabled')),
              ],
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.keyboardMode = v;
                  c.hidKeyboard = (v == 'uhid' || v == 'aoa');
                  return c;
                });
                setState(() {});
              },
            ),
            const SizedBox(height: AppDimens.lg),
            LabeledDropdown<String>(
              label: 'Mouse Mode',
              icon: Icons.mouse_rounded,
              value: config.mouseMode,
              hint: 'Default (sdk)',
              items: const [
                DropdownMenuItem(value: null, child: Text('Default (sdk)')),
                DropdownMenuItem(value: 'uhid', child: Text('UHID')),
                DropdownMenuItem(value: 'aoa', child: Text('AOA (USB only)')),
                DropdownMenuItem(value: 'disabled', child: Text('Disabled')),
              ],
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.mouseMode = v;
                  c.hidMouse = (v == 'uhid' || v == 'aoa');
                  return c;
                });
                setState(() {});
              },
            ),
            const SizedBox(height: AppDimens.lg),
            LabeledDropdown<String>(
              label: 'Gamepad Mode',
              icon: Icons.gamepad_rounded,
              value: config.gamepadMode,
              hint: 'Disabled',
              items: const [
                DropdownMenuItem(value: null, child: Text('Disabled')),
                DropdownMenuItem(value: 'uhid', child: Text('UHID')),
                DropdownMenuItem(value: 'aoa', child: Text('AOA (USB only)')),
              ],
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.gamepadMode = v;
                  return c;
                });
                setState(() {});
              },
            ),
            const Divider(color: AppColors.border, height: 32),
            ToggleOption(
              label: 'OTG Mode',
              description: 'Keyboard/mouse only, no mirroring',
              value: config.otgMode,
              icon: Icons.usb_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.otgMode = v;
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
