import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/app_dimens.dart';
import '../../../providers/scrcpy_provider.dart';
import '../../../widgets/labeled_dropdown.dart';
import '../../../widgets/labeled_text_field.dart';
import '../../../widgets/labeled_slider.dart';
import 'config_dialog_helper.dart';

void showVideoDialog(BuildContext context, ScrcpyProvider provider) {
  bool isCommitted = false;
  final snapshot = provider.config.copyWith();

  showConfigDialog(
    context: context,
    title: 'Video Settings',
    icon: Icons.videocam_rounded,
    onDone: () {
      isCommitted = true;
      provider.commitConfig();
    },
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          final config = provider.config;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: LabeledDropdown<String>(
                      label: 'Video Codec',
                      value: config.videoCodec,
                      items: const [
                        DropdownMenuItem(
                          value: 'h264',
                          child: Text('H.264 (Default)'),
                        ),
                        DropdownMenuItem(
                          value: 'h265',
                          child: Text('H.265 (HEVC)'),
                        ),
                        DropdownMenuItem(value: 'av1', child: Text('AV1')),
                      ],
                      onChanged: (v) {
                        provider.updateConfigSilent((c) {
                          c.videoCodec = v ?? 'h264';
                          return c;
                        });
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: AppDimens.lg),
                  Expanded(
                    child: LabeledTextField(
                      label: 'Video Encoder',
                      hint: 'Auto (leave empty)',
                      value: config.videoEncoder ?? '',
                      onChanged: (v) => provider.updateConfigSilent((c) {
                        c.videoEncoder = v.isEmpty ? null : v;
                        return c;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.lg),
              LabeledTextField(
                label: 'Codec Options',
                hint: 'key=value,key:type=value',
                value: config.codecOptions ?? '',
                onChanged: (v) => provider.updateConfigSilent((c) {
                  c.codecOptions = v.isEmpty ? null : v;
                  return c;
                }),
              ),
              const SizedBox(height: AppDimens.lg),
              LabeledSlider(
                label: 'Max Size (shorter dimension)',
                value: (config.maxSize ?? 0).toDouble(),
                min: 0,
                max: 2160,
                divisions: 18,
                valueLabel: (v) => v == 0 ? 'Native' : '${v.toInt()}p',
                onChanged: (v) {
                  provider.updateConfigSilent((c) {
                    c.maxSize = v == 0 ? null : v.toInt();
                    return c;
                  });
                  setState(() {});
                },
                icon: Icons.aspect_ratio_rounded,
              ),
              const SizedBox(height: AppDimens.lg),
              LabeledSlider(
                label: 'Max FPS',
                value: (config.maxFps ?? 0).toDouble(),
                min: 0,
                max: 120,
                divisions: 12,
                valueLabel: (v) => v == 0 ? 'Unlimited' : '${v.toInt()} fps',
                onChanged: (v) {
                  provider.updateConfigSilent((c) {
                    c.maxFps = v == 0 ? null : v.toInt();
                    return c;
                  });
                  setState(() {});
                },
                icon: Icons.speed_rounded,
              ),
              const SizedBox(height: AppDimens.lg),
              LabeledSlider(
                label: 'Video Bit Rate',
                value: (config.videoBitRate ?? 8000000) / 1000000,
                min: 1,
                max: 50,
                divisions: 49,
                valueLabel: (v) => '${v.toStringAsFixed(0)} Mbps',
                onChanged: (v) {
                  provider.updateConfigSilent((c) {
                    c.videoBitRate = (v * 1000000).toInt();
                    return c;
                  });
                  setState(() {});
                },
                icon: Icons.data_usage_rounded,
              ),
              const SizedBox(height: AppDimens.lg),
              LabeledTextField(
                label: 'Crop',
                hint: 'width:height:x:y',
                icon: Icons.crop_rounded,
                value: config.crop ?? '',
                onChanged: (v) => provider.updateConfigSilent((c) {
                  c.crop = v.isEmpty ? null : v;
                  return c;
                }),
              ),
              if (config.crop != null && !RegExp(r'^\d+:\d+:\d+:\d+$').hasMatch(config.crop!))
                const Padding(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Warning: Crop format must be width:height:x:y (e.g. 100:200:0:0)',
                    style: TextStyle(color: Colors.redAccent, fontSize: 13),
                  ),
                ),
              const SizedBox(height: AppDimens.lg),
              Row(
                children: [
                  Expanded(
                    child: LabeledDropdown<String>(
                      label: 'Capture Orientation',
                      value: config.captureOrientation,
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Auto')),
                        DropdownMenuItem(
                          value: '0',
                          child: Text('0° (Natural)'),
                        ),
                        DropdownMenuItem(value: '90', child: Text('90°')),
                        DropdownMenuItem(value: '180', child: Text('180°')),
                        DropdownMenuItem(value: '270', child: Text('270°')),
                      ],
                      onChanged: (v) {
                        provider.updateConfigSilent((c) {
                          c.captureOrientation = v;
                          return c;
                        });
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: AppDimens.lg),
                  Expanded(
                    child: LabeledTextField(
                      label: 'Display Buffer',
                      hint: 'milliseconds',
                      suffix: 'ms',
                      value: config.displayBuffer?.toString() ?? '',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) => provider.updateConfigSilent((c) {
                        c.displayBuffer = v.isEmpty ? null : int.tryParse(v);
                        return c;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.lg),
              LabeledSlider(
                label: 'Angle',
                value: (config.angle ?? 0).toDouble(),
                min: 0,
                max: 360,
                divisions: 36,
                valueLabel: (v) => '${v.toInt()}°',
                onChanged: (v) {
                  provider.updateConfigSilent((c) {
                    c.angle = v == 0 ? null : v.toInt();
                    return c;
                  });
                  setState(() {});
                },
                icon: Icons.rotate_right_rounded,
              ),
            ],
          );
        },
      );
    },
  ).then((_) {
    if (!isCommitted) provider.revertConfig(snapshot);
  });
}
