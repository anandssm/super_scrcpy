import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/app_dimens.dart';
import '../../../providers/scrcpy_provider.dart';
import '../../../widgets/labeled_text_field.dart';
import '../../../widgets/toggle_option.dart';
import 'config_dialog_helper.dart';

void showWindowDialog(BuildContext context, ScrcpyProvider provider) {
  showConfigDialog(
    context: context,
    title: 'Window Settings',
    icon: Icons.window_rounded,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final config = provider.config;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleOption(
              label: 'Fullscreen',
              description: 'Start in fullscreen mode',
              value: config.fullscreen,
              icon: Icons.fullscreen_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.fullscreen = v;
                  return c;
                });
                setState(() {});
              },
            ),
            ToggleOption(
              label: 'Always on Top',
              description: 'Keep window above others',
              value: config.alwaysOnTop,
              icon: Icons.push_pin_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.alwaysOnTop = v;
                  return c;
                });
                setState(() {});
              },
            ),
            ToggleOption(
              label: 'Borderless',
              description: 'Remove title bar',
              value: config.borderless,
              icon: Icons.border_style_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.borderless = v;
                  return c;
                });
                setState(() {});
              },
            ),
            const SizedBox(height: AppDimens.lg),
            LabeledTextField(
              label: 'Window Title',
              hint: 'e.g. My Device',
              icon: Icons.label_outline_rounded,
              value: config.windowTitle ?? '',
              onChanged: (v) => provider.updateConfig((c) {
                c.windowTitle = v.isEmpty ? null : v;
                return c;
              }),
            ),
            const SizedBox(height: AppDimens.lg),
            Row(
              children: [
                Expanded(
                  child: LabeledTextField(
                    label: 'X',
                    hint: 'px',
                    suffix: 'px',
                    value: config.windowX?.toString() ?? '',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) => provider.updateConfig((c) {
                      c.windowX = v.isEmpty ? null : int.tryParse(v);
                      return c;
                    }),
                  ),
                ),
                const SizedBox(width: AppDimens.sm),
                Expanded(
                  child: LabeledTextField(
                    label: 'Y',
                    hint: 'px',
                    suffix: 'px',
                    value: config.windowY?.toString() ?? '',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) => provider.updateConfig((c) {
                      c.windowY = v.isEmpty ? null : int.tryParse(v);
                      return c;
                    }),
                  ),
                ),
                const SizedBox(width: AppDimens.sm),
                Expanded(
                  child: LabeledTextField(
                    label: 'Width',
                    hint: 'px',
                    suffix: 'px',
                    value: config.windowWidth?.toString() ?? '',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) => provider.updateConfig((c) {
                      c.windowWidth = v.isEmpty ? null : int.tryParse(v);
                      return c;
                    }),
                  ),
                ),
                const SizedBox(width: AppDimens.sm),
                Expanded(
                  child: LabeledTextField(
                    label: 'Height',
                    hint: 'px',
                    suffix: 'px',
                    value: config.windowHeight?.toString() ?? '',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) => provider.updateConfig((c) {
                      c.windowHeight = v.isEmpty ? null : int.tryParse(v);
                      return c;
                    }),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}
