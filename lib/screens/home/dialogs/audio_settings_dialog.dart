import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/app_dimens.dart';
import '../../../providers/scrcpy_provider.dart';
import '../../../widgets/labeled_dropdown.dart';
import '../../../widgets/labeled_text_field.dart';
import '../../../widgets/labeled_slider.dart';
import '../../../widgets/toggle_option.dart';
import 'config_dialog_helper.dart';

void showAudioDialog(BuildContext context, ScrcpyProvider provider) {
  showConfigDialog(
    context: context,
    title: 'Audio Settings',
    icon: Icons.volume_up_rounded,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final config = provider.config;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleOption(
              label: 'Audio Forwarding',
              value: config.audioEnabled,
              icon: Icons.volume_up_rounded,
              onChanged: (v) {
                provider.updateConfig((c) {
                  c.audioEnabled = v;
                  return c;
                });
                setState(() {});
              },
            ),
            if (config.audioEnabled) ...[
              const SizedBox(height: AppDimens.lg),
              Row(
                children: [
                  Expanded(
                    child: LabeledDropdown<String>(
                      label: 'Audio Codec',
                      value: config.audioCodec,
                      items: const [
                        DropdownMenuItem(
                          value: 'opus',
                          child: Text('Opus (Default)'),
                        ),
                        DropdownMenuItem(value: 'aac', child: Text('AAC')),
                        DropdownMenuItem(value: 'flac', child: Text('FLAC')),
                        DropdownMenuItem(value: 'raw', child: Text('RAW')),
                      ],
                      onChanged: (v) {
                        provider.updateConfig((c) {
                          c.audioCodec = v ?? 'opus';
                          return c;
                        });
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: AppDimens.lg),
                  Expanded(
                    child: LabeledDropdown<String>(
                      label: 'Audio Source',
                      value: config.audioSource,
                      items: const [
                        DropdownMenuItem(
                          value: 'output',
                          child: Text('Device Output'),
                        ),
                        DropdownMenuItem(
                          value: 'mic',
                          child: Text('Microphone'),
                        ),
                        DropdownMenuItem(
                          value: 'playback',
                          child: Text('Playback'),
                        ),
                      ],
                      onChanged: (v) {
                        provider.updateConfig((c) {
                          c.audioSource = v ?? 'output';
                          return c;
                        });
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.lg),
              Row(
                children: [
                  Expanded(
                    child: LabeledSlider(
                      label: 'Audio Bit Rate',
                      icon: Icons.equalizer_rounded,
                      value: (config.audioBitRate ?? 128000) / 1000,
                      min: 32,
                      max: 320,
                      divisions: 18,
                      valueLabel: (v) => '${v.toInt()} kbps',
                      onChanged: (v) {
                        provider.updateConfig((c) {
                          c.audioBitRate = (v * 1000).toInt();
                          return c;
                        });
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: AppDimens.lg),
                  Expanded(
                    child: LabeledTextField(
                      label: 'Audio Buffer',
                      hint: 'milliseconds',
                      suffix: 'ms',
                      value: config.audioBuffer?.toString() ?? '',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) => provider.updateConfig((c) {
                        c.audioBuffer = v.isEmpty ? null : int.tryParse(v);
                        return c;
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    ),
  );
}
