import 'package:flutter/material.dart';
import '../../../core/app_dimens.dart';
import '../../../providers/scrcpy_provider.dart';
import '../../../widgets/labeled_dropdown.dart';
import '../../../widgets/labeled_text_field.dart';
import '../../../widgets/labeled_slider.dart';
import '../../../widgets/toggle_option.dart';
import 'config_dialog_helper.dart';

void showCameraDialog(BuildContext context, ScrcpyProvider provider) {
  showConfigDialog(
    context: context,
    title: 'Camera',
    icon: Icons.camera_alt_rounded,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final config = provider.config;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleOption(
              label: 'Camera Mode',
              description: 'Use device camera as webcam (Android 12+)',
              value: config.cameraMode,
              icon: Icons.camera_alt_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.cameraMode = v;
                  return c;
                });
                setState(() {});
              },
            ),
            if (config.cameraMode) ...[
              const SizedBox(height: AppDimens.lg),
              Row(
                children: [
                  Expanded(
                    child: LabeledDropdown<String>(
                      label: 'Camera Facing',
                      value: config.cameraFacing,
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Auto')),
                        DropdownMenuItem(value: 'front', child: Text('Front')),
                        DropdownMenuItem(value: 'back', child: Text('Back')),
                        DropdownMenuItem(
                          value: 'external',
                          child: Text('External'),
                        ),
                      ],
                      onChanged: (v) {
                        provider.updateConfig((c) {
                          c.cameraFacing = v;
                          return c;
                        });
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: AppDimens.lg),
                  Expanded(
                    child: LabeledTextField(
                      label: 'Camera ID',
                      hint: 'Auto',
                      value: config.cameraId ?? '',
                      onChanged: (v) => provider.updateConfig((c) {
                        c.cameraId = v.isEmpty ? null : v;
                        return c;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.lg),
              Row(
                children: [
                  Expanded(
                    child: LabeledTextField(
                      label: 'Camera Size',
                      hint: '1920x1080',
                      icon: Icons.aspect_ratio_rounded,
                      value: config.cameraSize ?? '',
                      onChanged: (v) => provider.updateConfig((c) {
                        c.cameraSize = v.isEmpty ? null : v;
                        return c;
                      }),
                    ),
                  ),
                  const SizedBox(width: AppDimens.lg),
                  Expanded(
                    child: LabeledDropdown<String>(
                      label: 'Aspect Ratio',
                      value: config.cameraAr,
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Auto')),
                        DropdownMenuItem(value: '16:9', child: Text('16:9')),
                        DropdownMenuItem(value: '4:3', child: Text('4:3')),
                        DropdownMenuItem(value: '1:1', child: Text('1:1')),
                      ],
                      onChanged: (v) {
                        provider.updateConfig((c) {
                          c.cameraAr = v;
                          return c;
                        });
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.lg),
              LabeledSlider(
                label: 'Camera FPS',
                icon: Icons.speed_rounded,
                value: (config.cameraFps ?? 30).toDouble(),
                min: 15,
                max: 120,
                divisions: 21,
                valueLabel: (v) => '${v.toInt()} fps',
                onChanged: (v) {
                  provider.updateConfig((c) {
                    c.cameraFps = v.toInt();
                    return c;
                  });
                  setState(() {});
                },
              ),
              const SizedBox(height: AppDimens.sm),
              ToggleOption(
                label: 'High Speed Mode',
                description: 'Higher FPS camera mode',
                value: config.cameraHighSpeed,
                icon: Icons.shutter_speed_rounded,
                onChanged: (v) {
                  provider.updateConfig((c) {
                    c.cameraHighSpeed = v;
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
