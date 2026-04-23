import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../core/app_dimens.dart';
import '../../../providers/scrcpy_provider.dart';
import '../../../widgets/labeled_dropdown.dart';
import '../../../widgets/labeled_text_field.dart';
import '../../../widgets/toggle_option.dart';
import 'config_dialog_helper.dart';

String _defaultVideosFolder() {
  final userProfile = Platform.environment['USERPROFILE'];
  if (userProfile != null && userProfile.isNotEmpty) {
    return '$userProfile${Platform.pathSeparator}Videos';
  }
  final home = Platform.environment['HOME'];
  if (home != null && home.isNotEmpty) {
    return '$home${Platform.pathSeparator}Videos';
  }
  return '';
}

String _buildDefaultRecordPath({
  String format = 'mkv',
  String? folder,
  DateTime? now,
}) {
  final ts = now ?? DateTime.now();
  final timestamp =
      '${ts.year.toString().padLeft(4, '0')}-${ts.month.toString().padLeft(2, '0')}-${ts.day.toString().padLeft(2, '0')}_${ts.hour.toString().padLeft(2, '0')}-${ts.minute.toString().padLeft(2, '0')}-${ts.second.toString().padLeft(2, '0')}';
  final fileName = 'super_scrcpy_$timestamp.${format.toLowerCase()}';
  final targetFolder = (folder != null && folder.trim().isNotEmpty)
      ? folder.trim()
      : _defaultVideosFolder();
  if (targetFolder.isEmpty) return fileName;
  return '$targetFolder${Platform.pathSeparator}$fileName';
}

bool _isGeneratedSuperScrcpyName(String? path) {
  if (path == null || path.trim().isEmpty) return false;
  final normalized = path.replaceAll('\\', '/');
  final name = normalized.split('/').last.toLowerCase();
  return name.startsWith('super_scrcpy_');
}

void showRecordDialog(BuildContext context, ScrcpyProvider provider) {
  bool isCommitted = false;
  final snapshot = provider.config.copyWith();

  showConfigDialog(
    context: context,
    title: 'Recording',
    icon: Icons.fiber_manual_record_rounded,
    onDone: () {
      isCommitted = true;
      provider.commitConfig();
    },
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final config = provider.config;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleOption(
              label: 'Enable Recording',
              value: config.recording,
              icon: Icons.fiber_manual_record_rounded,
              onChanged: (v) {
                provider.updateConfigSilent((c) {
                  c.recording = v;
                  if (v) {
                    c.recordFormat = c.recordFormat.isEmpty
                        ? 'mkv'
                        : c.recordFormat;
                    if (c.recordFile == null || c.recordFile!.trim().isEmpty) {
                      c.recordFile = _buildDefaultRecordPath(
                        format: c.recordFormat,
                        folder: c.recordFolder,
                      );
                    }
                  }
                  return c;
                });
                setState(() {});
              },
            ),
            if (config.recording) ...[
              const SizedBox(height: AppDimens.lg),
              Row(
                children: [
                  Expanded(
                    child: LabeledTextField(
                      label: 'Output File',
                      hint: 'super_scrcpy_YYYY-MM-DD_HH-MM-SS.mkv',
                      icon: Icons.save_rounded,
                      value: config.recordFile ?? '',
                      onChanged: (v) => provider.updateConfigSilent((c) {
                        c.recordFile = v.isEmpty ? null : v;
                        return c;
                      }),
                    ),
                  ),
                  const SizedBox(width: AppDimens.lg),
                  SizedBox(
                    width: 160,
                    child: LabeledDropdown<String>(
                      label: 'Format',
                      value: config.recordFormat,
                      items: const [
                        DropdownMenuItem(value: 'mp4', child: Text('MP4')),
                        DropdownMenuItem(value: 'mkv', child: Text('MKV')),
                      ],
                      onChanged: (v) {
                        provider.updateConfigSilent((c) {
                          c.recordFormat = v ?? 'mkv';
                          if (_isGeneratedSuperScrcpyName(c.recordFile)) {
                            c.recordFile = _buildDefaultRecordPath(
                              format: c.recordFormat,
                              folder: c.recordFolder,
                            );
                          }
                          return c;
                        });
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.md),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Folder: ${config.recordFolder?.trim().isNotEmpty == true ? config.recordFolder : _defaultVideosFolder()}\n(Default: Videos)',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: AppDimens.sm),
                  IconButton(
                    tooltip: 'Choose folder',
                    onPressed: () async {
                      final dir = await FilePicker.getDirectoryPath(
                        dialogTitle: 'Select recording folder',
                      );
                      if (dir == null) return;
                      provider.updateConfigSilent((c) {
                        c.recordFolder = dir;
                        c.recordFile = _buildDefaultRecordPath(
                          format: c.recordFormat,
                          folder: c.recordFolder,
                        );
                        return c;
                      });
                      setState(() {});
                    },
                    icon: const Icon(Icons.folder_open_rounded),
                  ),
                  const SizedBox(width: AppDimens.sm),
                  TextButton(
                    onPressed: () {
                      provider.updateConfigSilent((c) {
                        c.recordFolder = null;
                        c.recordFile = _buildDefaultRecordPath(
                          format: c.recordFormat,
                        );
                        return c;
                      });
                      setState(() {});
                    },
                    child: const Text('Use Default'),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.lg),
              ToggleOption(
                label: 'No Display',
                description: 'Record without mirroring window',
                value: config.noDisplay,
                icon: Icons.visibility_off_rounded,
                onChanged: (v) {
                  provider.updateConfigSilent((c) {
                    c.noDisplay = v;
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
  ).then((_) {
    if (!isCommitted) provider.revertConfig(snapshot);
  });
}
