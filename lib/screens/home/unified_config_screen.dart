import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../models/scrcpy_config.dart';
import '../../providers/scrcpy_provider.dart';
import '../../providers/settings_provider.dart';
import 'widgets/config_tile.dart';
import 'dialogs/video_settings_dialog.dart';
import 'dialogs/audio_settings_dialog.dart';
import 'dialogs/record_settings_dialog.dart';
import 'dialogs/window_settings_dialog.dart';
import 'dialogs/control_settings_dialog.dart';
import 'dialogs/hid_settings_dialog.dart';
import 'dialogs/device_settings_dialog.dart';
import 'dialogs/camera_settings_dialog.dart';
import 'dialogs/display_settings_dialog.dart';
import 'dialogs/misc_settings_dialog.dart';
import 'dialogs/library_settings_dialog.dart';
import 'dialogs/app_settings_dialog.dart';

class UnifiedConfigScreen extends StatelessWidget {
  const UnifiedConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final provider = context.watch<ScrcpyProvider>();
    final config = provider.config;
    final settings = context.watch<SettingsProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.sm),
            child: Row(
              children: [
                Icon(Icons.tune_rounded, size: 20, color: primary),
                const SizedBox(width: AppDimens.sm),
                const Text(
                  'Configuration',
                  style: TextStyle(
                    fontSize: AppDimens.fontLg,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: AppDimens.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimens.radiusRound),
                    border: Border.all(color: primary.withValues(alpha: 0.25)),
                  ),
                  child: Text(
                    settings.activeProfileName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: primary,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const Spacer(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => showSuperScrcpySettingsDialog(context),
                    borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.settings_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ConfigTile(
            icon: Icons.folder_special_rounded,
            title: 'scrcpy Library',
            summary: _librarySummary(provider),
            hasCustom: provider.isPathConfigured,
            onTap: () => showLibraryDialog(context, provider),
          ),
          ConfigTile(
            icon: Icons.videocam_rounded,
            title: 'Video',
            summary: _videoSummary(config),
            hasCustom: _videoHasCustom(config),
            onTap: () => showVideoDialog(context, provider),
          ),
          ConfigTile(
            icon: Icons.volume_up_rounded,
            title: 'Audio',
            summary: _audioSummary(config),
            hasCustom: _audioHasCustom(config),
            onTap: () => showAudioDialog(context, provider),
          ),
          ConfigTile(
            icon: Icons.fiber_manual_record_rounded,
            title: 'Recording',
            summary: _recordSummary(config),
            hasCustom: config.recording,
            onTap: () => showRecordDialog(context, provider),
          ),
          ConfigTile(
            icon: Icons.window_rounded,
            title: 'Window',
            summary: _windowSummary(config),
            hasCustom: _windowHasCustom(config),
            onTap: () => showWindowDialog(context, provider),
          ),
          ConfigTile(
            icon: Icons.touch_app_rounded,
            title: 'Control & Input',
            summary: _controlSummary(config),
            hasCustom: _controlHasCustom(config),
            onTap: () => showControlDialog(context, provider),
          ),
          ConfigTile(
            icon: Icons.keyboard_rounded,
            title: 'HID & OTG',
            summary: _hidSummary(config),
            hasCustom:
                config.hidKeyboard ||
                config.hidMouse ||
                config.otgMode ||
                config.keyboardMode != null ||
                config.mouseMode != null ||
                config.gamepadMode != null,
            onTap: () => showHidDialog(context, provider),
          ),
          ConfigTile(
            icon: Icons.phone_android_rounded,
            title: 'Device Behavior',
            summary: _deviceSummary(config),
            hasCustom: _deviceHasCustom(config),
            onTap: () => showDeviceDialog(context, provider),
          ),
          ConfigTile(
            icon: Icons.camera_alt_rounded,
            title: 'Camera',
            summary: _cameraSummary(config),
            hasCustom: config.cameraMode,
            onTap: () => showCameraDialog(context, provider),
          ),
          ConfigTile(
            icon: Icons.desktop_windows_rounded,
            title: 'Display',
            summary: _displaySummary(config),
            hasCustom:
                config.useNewDisplay ||
                (config.displayId != null && config.displayId != 0),
            onTap: () => showDisplayDialog(context, provider),
          ),
          ConfigTile(
            icon: Icons.settings_ethernet_rounded,
            title: 'Connection & Misc',
            summary: _miscSummary(config),
            hasCustom: _miscHasCustom(config),
            onTap: () => showMiscDialog(context, provider),
          ),
        ],
      ),
    );
  }

  String _librarySummary(ScrcpyProvider p) {
    if (!p.isPathConfigured) return 'Not configured';
    final parts = <String>[];
    if (p.scrcpyVersion != null) parts.add(p.scrcpyVersion!);
    if (p.scrcpyPath.isNotEmpty) {
      final short = p.scrcpyPath.length > 40
          ? '...${p.scrcpyPath.substring(p.scrcpyPath.length - 37)}'
          : p.scrcpyPath;
      parts.add(short);
    }
    return parts.isEmpty ? 'Configured' : parts.join(' · ');
  }

  String _videoSummary(ScrcpyConfig c) {
    final parts = <String>[];
    parts.add(c.videoCodec.toUpperCase());
    parts.add(c.maxSize != null ? '${c.maxSize}p' : 'Native');
    parts.add(c.maxFps != null ? '${c.maxFps}fps' : '∞ FPS');
    if (c.videoBitRate != null)
      parts.add('${(c.videoBitRate! / 1000000).toStringAsFixed(0)}Mbps');
    return parts.join(' · ');
  }

  bool _videoHasCustom(ScrcpyConfig c) =>
      c.videoCodec != 'h264' ||
      c.maxSize != null ||
      c.maxFps != null ||
      c.videoBitRate != null ||
      c.crop != null ||
      c.videoEncoder != null ||
      c.captureOrientation != null ||
      c.codecOptions != null ||
      c.displayBuffer != null ||
      (c.angle != null && c.angle != 0);

  String _audioSummary(ScrcpyConfig c) {
    if (!c.audioEnabled) return 'Disabled';
    final parts = <String>[c.audioCodec.toUpperCase(), c.audioSource];
    if (c.audioBitRate != null)
      parts.add('${(c.audioBitRate! / 1000).toInt()}kbps');
    return parts.join(' · ');
  }

  bool _audioHasCustom(ScrcpyConfig c) =>
      !c.audioEnabled ||
      c.audioCodec != 'opus' ||
      c.audioSource != 'output' ||
      c.audioBitRate != null ||
      c.audioBuffer != null;

  String _recordSummary(ScrcpyConfig c) {
    if (!c.recording) return 'Disabled';
    return '${c.recordFormat.toUpperCase()}${c.recordFile != null ? ' · ${c.recordFile!.split(RegExp(r'[/\\]')).last}' : ''}';
  }

  String _windowSummary(ScrcpyConfig c) {
    final parts = <String>[];
    if (c.fullscreen) parts.add('Fullscreen');
    if (c.alwaysOnTop) parts.add('On Top');
    if (c.borderless) parts.add('Borderless');
    if (c.windowTitle != null) parts.add('"${c.windowTitle}"');
    return parts.isEmpty ? 'Default' : parts.join(' · ');
  }

  bool _windowHasCustom(ScrcpyConfig c) =>
      c.fullscreen ||
      c.alwaysOnTop ||
      c.borderless ||
      c.windowTitle != null ||
      c.windowX != null ||
      c.windowY != null ||
      c.windowWidth != null ||
      c.windowHeight != null;

  String _controlSummary(ScrcpyConfig c) {
    if (!c.controlEnabled) return 'Disabled (mirror only)';
    final parts = <String>['Enabled'];
    if (c.showTouches) parts.add('Touches');
    if (c.forwardAllClicks) parts.add('All Clicks');
    if (c.noClipboardAutosync) parts.add('No Clipboard');
    if (c.noKeyRepeat) parts.add('No Repeat');
    return parts.join(' · ');
  }

  bool _controlHasCustom(ScrcpyConfig c) =>
      !c.controlEnabled ||
      c.showTouches ||
      c.forwardAllClicks ||
      c.noClipboardAutosync ||
      c.noKeyRepeat;

  String _hidSummary(ScrcpyConfig c) {
    final parts = <String>[];
    if (c.keyboardMode != null) {
      parts.add('KB: ${c.keyboardMode}');
    } else if (c.hidKeyboard) {
      parts.add('HID KB');
    }
    if (c.mouseMode != null) {
      parts.add('Mouse: ${c.mouseMode}');
    } else if (c.hidMouse) {
      parts.add('HID Mouse');
    }
    if (c.gamepadMode != null) parts.add('Gamepad: ${c.gamepadMode}');
    if (c.otgMode) parts.add('OTG');
    return parts.isEmpty ? 'Default' : parts.join(' · ');
  }

  String _deviceSummary(ScrcpyConfig c) {
    final parts = <String>[];
    if (c.turnScreenOff) parts.add('Screen Off');
    if (c.stayAwake) parts.add('Stay Awake');
    if (c.powerOffOnClose) parts.add('Power Off');
    if (c.disableScreensaver) parts.add('No Saver');
    return parts.isEmpty ? 'Default' : parts.join(' · ');
  }

  bool _deviceHasCustom(ScrcpyConfig c) =>
      c.turnScreenOff ||
      c.stayAwake ||
      c.powerOffOnClose ||
      c.disableScreensaver ||
      c.screenOffTimeout != null ||
      c.pushTarget != null;

  String _cameraSummary(ScrcpyConfig c) {
    if (!c.cameraMode) return 'Disabled';
    final parts = <String>['Enabled'];
    if (c.cameraFacing != null) parts.add(c.cameraFacing!);
    if (c.cameraFps != null) parts.add('${c.cameraFps}fps');
    return parts.join(' · ');
  }

  String _displaySummary(ScrcpyConfig c) {
    final parts = <String>[];
    if (c.useNewDisplay) {
      parts.add(
        'Virtual${c.newDisplaySize != null ? ' (${c.newDisplaySize})' : ''}',
      );
    }
    if (c.displayId != null && c.displayId != 0)
      parts.add('Display #${c.displayId}');
    if (c.startApp != null) parts.add(c.startApp!.split('/').first);
    return parts.isEmpty ? 'Default' : parts.join(' · ');
  }

  String _miscSummary(ScrcpyConfig c) {
    final parts = <String>[];
    if (c.forceAdbForward) parts.add('ADB Forward');
    if (c.tunnelHost != null) parts.add('Tunnel');
    if (c.logLevel != 'info') parts.add(c.logLevel);
    if (c.noCleanup) parts.add('No Cleanup');
    if (c.timeLimit != null) parts.add('${c.timeLimit}s limit');
    return parts.isEmpty ? 'Default' : parts.join(' · ');
  }

  bool _miscHasCustom(ScrcpyConfig c) =>
      c.forceAdbForward ||
      c.tunnelHost != null ||
      c.tunnelPort != null ||
      c.noDisplay ||
      c.noVideo ||
      c.noAudio ||
      c.noControl ||
      c.noCleanup ||
      c.logLevel != 'info' ||
      c.timeLimit != null;
}
