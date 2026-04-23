import 'dart:io';

class ConfigEntry {
  final String configKey;
  final String label;
  final String cliArg;

  const ConfigEntry({
    required this.configKey,
    required this.label,
    required this.cliArg,
  });
}

class ScrcpyConfig {
  String videoCodec;
  int? maxSize;
  int? videoBitRate;
  int? maxFps;
  String? crop;
  int? displayId;
  String? captureOrientation;
  String? videoEncoder;
  String? codecOptions;
  int? displayBuffer;
  int? angle;

  bool audioEnabled;
  String audioCodec;
  int? audioBitRate;
  String audioSource;
  int? audioBuffer;

  bool recording;
  String? recordFile;
  String? recordFolder;
  String recordFormat;

  bool fullscreen;
  bool alwaysOnTop;
  bool borderless;
  String? windowTitle;
  int? windowX;
  int? windowY;
  int? windowWidth;
  int? windowHeight;

  bool controlEnabled;
  bool showTouches;
  bool stayAwake;
  bool turnScreenOff;
  bool hidKeyboard;
  bool hidMouse;
  String? keyboardMode;
  String? mouseMode;
  String? gamepadMode;
  bool forwardAllClicks;
  bool noClipboardAutosync;
  bool noKeyRepeat;
  int? screenOffTimeout;
  int? timeLimit;
  bool powerOffOnClose;
  String? pushTarget;

  bool useNewDisplay;
  String? newDisplaySize;
  String? startApp;

  bool cameraMode;
  String? cameraId;
  String? cameraSize;
  String? cameraFacing;
  String? cameraAr;
  int? cameraFps;
  bool cameraHighSpeed;

  bool otgMode;

  bool forceAdbForward;
  String? tunnelHost;
  int? tunnelPort;

  bool noDisplay;
  bool noVideo;
  bool noAudio;
  bool noControl;
  bool noCleanup;
  bool disableScreensaver;
  String logLevel;

  ScrcpyConfig({
    this.videoCodec = 'h264',
    this.maxSize,
    this.videoBitRate,
    this.maxFps,
    this.crop,
    this.displayId,
    this.captureOrientation,
    this.videoEncoder,
    this.codecOptions,
    this.displayBuffer,
    this.angle,
    this.audioEnabled = true,
    this.audioCodec = 'opus',
    this.audioBitRate,
    this.audioSource = 'output',
    this.audioBuffer,
    this.recording = false,
    this.recordFile,
    this.recordFolder,
    this.recordFormat = 'mkv',
    this.fullscreen = false,
    this.alwaysOnTop = false,
    this.borderless = false,
    this.windowTitle,
    this.windowX,
    this.windowY,
    this.windowWidth,
    this.windowHeight,
    this.controlEnabled = true,
    this.showTouches = false,
    this.stayAwake = false,
    this.turnScreenOff = false,
    this.hidKeyboard = false,
    this.hidMouse = false,
    this.keyboardMode,
    this.mouseMode,
    this.gamepadMode,
    this.forwardAllClicks = false,
    this.noClipboardAutosync = false,
    this.noKeyRepeat = false,
    this.screenOffTimeout,
    this.timeLimit,
    this.powerOffOnClose = false,
    this.pushTarget,
    this.useNewDisplay = false,
    this.newDisplaySize,
    this.startApp,
    this.cameraMode = false,
    this.cameraId,
    this.cameraSize,
    this.cameraFacing,
    this.cameraAr,
    this.cameraFps,
    this.cameraHighSpeed = false,
    this.otgMode = false,
    this.forceAdbForward = false,
    this.tunnelHost,
    this.tunnelPort,
    this.noDisplay = false,
    this.noVideo = false,
    this.noAudio = false,
    this.noControl = false,
    this.noCleanup = false,
    this.disableScreensaver = false,
    this.logLevel = 'info',
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (videoCodec != 'h264') map['videoCodec'] = videoCodec;
    if (maxSize != null) map['maxSize'] = maxSize;
    if (videoBitRate != null) map['videoBitRate'] = videoBitRate;
    if (maxFps != null) map['maxFps'] = maxFps;
    if (crop != null) map['crop'] = crop;
    if (displayId != null) map['displayId'] = displayId;
    if (captureOrientation != null)
      map['captureOrientation'] = captureOrientation;
    if (videoEncoder != null) map['videoEncoder'] = videoEncoder;
    if (codecOptions != null) map['codecOptions'] = codecOptions;
    if (displayBuffer != null) map['displayBuffer'] = displayBuffer;
    if (angle != null && angle != 0) map['angle'] = angle;
    if (!audioEnabled) map['audioEnabled'] = audioEnabled;
    if (audioCodec != 'opus') map['audioCodec'] = audioCodec;
    if (audioBitRate != null) map['audioBitRate'] = audioBitRate;
    if (audioSource != 'output') map['audioSource'] = audioSource;
    if (audioBuffer != null) map['audioBuffer'] = audioBuffer;
    if (recording) map['recording'] = recording;
    if (recordFile != null) map['recordFile'] = recordFile;
    if (recordFolder != null) map['recordFolder'] = recordFolder;
    if (recordFormat != 'mkv') map['recordFormat'] = recordFormat;
    if (fullscreen) map['fullscreen'] = fullscreen;
    if (alwaysOnTop) map['alwaysOnTop'] = alwaysOnTop;
    if (borderless) map['borderless'] = borderless;
    if (windowTitle != null) map['windowTitle'] = windowTitle;
    if (windowX != null) map['windowX'] = windowX;
    if (windowY != null) map['windowY'] = windowY;
    if (windowWidth != null) map['windowWidth'] = windowWidth;
    if (windowHeight != null) map['windowHeight'] = windowHeight;
    if (!controlEnabled) map['controlEnabled'] = controlEnabled;
    if (showTouches) map['showTouches'] = showTouches;
    if (stayAwake) map['stayAwake'] = stayAwake;
    if (turnScreenOff) map['turnScreenOff'] = turnScreenOff;
    if (hidKeyboard) map['hidKeyboard'] = hidKeyboard;
    if (hidMouse) map['hidMouse'] = hidMouse;
    if (keyboardMode != null) map['keyboardMode'] = keyboardMode;
    if (mouseMode != null) map['mouseMode'] = mouseMode;
    if (gamepadMode != null) map['gamepadMode'] = gamepadMode;
    if (forwardAllClicks) map['forwardAllClicks'] = forwardAllClicks;
    if (noClipboardAutosync) map['noClipboardAutosync'] = noClipboardAutosync;
    if (noKeyRepeat) map['noKeyRepeat'] = noKeyRepeat;
    if (screenOffTimeout != null) map['screenOffTimeout'] = screenOffTimeout;
    if (timeLimit != null) map['timeLimit'] = timeLimit;
    if (powerOffOnClose) map['powerOffOnClose'] = powerOffOnClose;
    if (pushTarget != null) map['pushTarget'] = pushTarget;
    if (useNewDisplay) map['useNewDisplay'] = useNewDisplay;
    if (newDisplaySize != null) map['newDisplaySize'] = newDisplaySize;
    if (startApp != null) map['startApp'] = startApp;
    if (cameraMode) map['cameraMode'] = cameraMode;
    if (cameraId != null) map['cameraId'] = cameraId;
    if (cameraSize != null) map['cameraSize'] = cameraSize;
    if (cameraFacing != null) map['cameraFacing'] = cameraFacing;
    if (cameraAr != null) map['cameraAr'] = cameraAr;
    if (cameraFps != null) map['cameraFps'] = cameraFps;
    if (cameraHighSpeed) map['cameraHighSpeed'] = cameraHighSpeed;
    if (otgMode) map['otgMode'] = otgMode;
    if (forceAdbForward) map['forceAdbForward'] = forceAdbForward;
    if (tunnelHost != null) map['tunnelHost'] = tunnelHost;
    if (tunnelPort != null) map['tunnelPort'] = tunnelPort;
    if (noDisplay) map['noDisplay'] = noDisplay;
    if (noVideo) map['noVideo'] = noVideo;
    if (noAudio) map['noAudio'] = noAudio;
    if (noControl) map['noControl'] = noControl;
    if (noCleanup) map['noCleanup'] = noCleanup;
    if (disableScreensaver) map['disableScreensaver'] = disableScreensaver;
    if (logLevel != 'info') map['logLevel'] = logLevel;
    return map;
  }

  factory ScrcpyConfig.fromJson(Map<String, dynamic> json) {
    return ScrcpyConfig(
      videoCodec: json['videoCodec'] as String? ?? 'h264',
      maxSize: json['maxSize'] as int?,
      videoBitRate: json['videoBitRate'] as int?,
      maxFps: json['maxFps'] as int?,
      crop: json['crop'] as String?,
      displayId: json['displayId'] as int?,
      captureOrientation: json['captureOrientation'] as String?,
      videoEncoder: json['videoEncoder'] as String?,
      codecOptions: json['codecOptions'] as String?,
      displayBuffer: json['displayBuffer'] as int?,
      angle: json['angle'] as int?,
      audioEnabled: json['audioEnabled'] as bool? ?? true,
      audioCodec: json['audioCodec'] as String? ?? 'opus',
      audioBitRate: json['audioBitRate'] as int?,
      audioSource: json['audioSource'] as String? ?? 'output',
      audioBuffer: json['audioBuffer'] as int?,
      recording: json['recording'] as bool? ?? false,
      recordFile: json['recordFile'] as String?,
      recordFolder: json['recordFolder'] as String?,
      recordFormat: json['recordFormat'] as String? ?? 'mkv',
      fullscreen: json['fullscreen'] as bool? ?? false,
      alwaysOnTop: json['alwaysOnTop'] as bool? ?? false,
      borderless: json['borderless'] as bool? ?? false,
      windowTitle: json['windowTitle'] as String?,
      windowX: json['windowX'] as int?,
      windowY: json['windowY'] as int?,
      windowWidth: json['windowWidth'] as int?,
      windowHeight: json['windowHeight'] as int?,
      controlEnabled: json['controlEnabled'] as bool? ?? true,
      showTouches: json['showTouches'] as bool? ?? false,
      stayAwake: json['stayAwake'] as bool? ?? false,
      turnScreenOff: json['turnScreenOff'] as bool? ?? false,
      hidKeyboard: json['hidKeyboard'] as bool? ?? false,
      hidMouse: json['hidMouse'] as bool? ?? false,
      keyboardMode: json['keyboardMode'] as String?,
      mouseMode: json['mouseMode'] as String?,
      gamepadMode: json['gamepadMode'] as String?,
      forwardAllClicks: json['forwardAllClicks'] as bool? ?? false,
      noClipboardAutosync: json['noClipboardAutosync'] as bool? ?? false,
      noKeyRepeat: json['noKeyRepeat'] as bool? ?? false,
      screenOffTimeout: json['screenOffTimeout'] as int?,
      timeLimit: json['timeLimit'] as int?,
      powerOffOnClose: json['powerOffOnClose'] as bool? ?? false,
      pushTarget: json['pushTarget'] as String?,
      useNewDisplay: json['useNewDisplay'] as bool? ?? false,
      newDisplaySize: json['newDisplaySize'] as String?,
      startApp: json['startApp'] as String?,
      cameraMode: json['cameraMode'] as bool? ?? false,
      cameraId: json['cameraId'] as String?,
      cameraSize: json['cameraSize'] as String?,
      cameraFacing: json['cameraFacing'] as String?,
      cameraAr: json['cameraAr'] as String?,
      cameraFps: json['cameraFps'] as int?,
      cameraHighSpeed: json['cameraHighSpeed'] as bool? ?? false,
      otgMode: json['otgMode'] as bool? ?? false,
      forceAdbForward: json['forceAdbForward'] as bool? ?? false,
      tunnelHost: json['tunnelHost'] as String?,
      tunnelPort: json['tunnelPort'] as int?,
      noDisplay: json['noDisplay'] as bool? ?? false,
      noVideo: json['noVideo'] as bool? ?? false,
      noAudio: json['noAudio'] as bool? ?? false,
      noControl: json['noControl'] as bool? ?? false,
      noCleanup: json['noCleanup'] as bool? ?? false,
      disableScreensaver: json['disableScreensaver'] as bool? ?? false,
      logLevel: json['logLevel'] as String? ?? 'info',
    );
  }

  List<String> buildArgs() {
    final args = <String>[];

    if (videoCodec != 'h264') {
      args.addAll(['--video-codec', videoCodec]);
    }
    if (maxSize != null) args.addAll(['-m', '$maxSize']);
    if (videoBitRate != null) args.addAll(['-b', '${videoBitRate}']);
    if (maxFps != null) args.addAll(['--max-fps', '$maxFps']);
    if (crop != null && crop!.isNotEmpty) args.addAll(['--crop', crop!]);
    if (displayId != null && displayId != 0) {
      args.addAll(['--display', '$displayId']);
    }
    if (captureOrientation != null && captureOrientation!.isNotEmpty) {
      args.addAll(['--capture-orientation', captureOrientation!]);
    }
    if (videoEncoder != null && videoEncoder!.isNotEmpty) {
      args.addAll(['--encoder', videoEncoder!]);
    }
    if (codecOptions != null && codecOptions!.isNotEmpty) {
      args.addAll(['--codec-options', codecOptions!]);
    }
    if (displayBuffer != null) {
      args.addAll(['--display-buffer', '$displayBuffer']);
    }
    if (angle != null && angle != 0) {
      args.addAll(['--angle', '$angle']);
    }

    if (!audioEnabled) {
      args.add('--no-audio');
    } else {
      if (audioCodec != 'opus') {
        args.addAll(['--audio-codec', audioCodec]);
      }
      if (audioBitRate != null) {
        args.addAll(['--audio-bit-rate', '$audioBitRate']);
      }
      if (audioSource != 'output') {
        args.addAll(['--audio-source', audioSource]);
      }
      if (audioBuffer != null) {
        args.addAll(['--audio-buffer', '$audioBuffer']);
      }
    }

    if (recording) {
      final effectiveRecordFile =
          (recordFile != null && recordFile!.trim().isNotEmpty)
          ? (_isAutoGeneratedRecordPath(recordFile!)
                ? _buildDefaultRecordPath()
                : recordFile!.trim())
          : _buildDefaultRecordPath();
      args.addAll(['-r', effectiveRecordFile]);
      args.addAll(['--record-format', recordFormat]);
    }

    if (fullscreen) args.add('-f');
    if (alwaysOnTop) args.add('--always-on-top');
    if (borderless) args.add('--window-borderless');
    if (windowTitle != null && windowTitle!.isNotEmpty) {
      args.addAll(['--window-title', windowTitle!]);
    }
    if (windowX != null) args.addAll(['--window-x', '$windowX']);
    if (windowY != null) args.addAll(['--window-y', '$windowY']);
    if (windowWidth != null) {
      args.addAll(['--window-width', '$windowWidth']);
    }
    if (windowHeight != null) {
      args.addAll(['--window-height', '$windowHeight']);
    }

    if (!controlEnabled) {
      args.add('-n');
    } else {
      if (showTouches) args.add('-t');

      if (keyboardMode != null && keyboardMode!.isNotEmpty) {
        args.addAll(['--keyboard', keyboardMode!]);
      } else if (hidKeyboard) {
        args.add('-K');
      }

      if (mouseMode != null && mouseMode!.isNotEmpty) {
        args.addAll(['--mouse', mouseMode!]);
      } else if (hidMouse) {
        args.add('-M');
      }

      if (gamepadMode != null && gamepadMode!.isNotEmpty) {
        args.addAll(['--gamepad', gamepadMode!]);
      }

      if (forwardAllClicks) args.add('--forward-all-clicks');
      if (noClipboardAutosync) args.add('--no-clipboard-autosync');
      if (noKeyRepeat) args.add('--no-key-repeat');
    }

    if (stayAwake) args.add('-w');
    if (turnScreenOff) args.add('-S');
    if (screenOffTimeout != null) {
      args.addAll(['--screen-off-timeout', '$screenOffTimeout']);
    }
    if (timeLimit != null) {
      args.addAll(['--time-limit', '$timeLimit']);
    }
    if (powerOffOnClose) args.add('--power-off-on-close');
    if (disableScreensaver) args.add('--disable-screensaver');

    if (pushTarget != null && pushTarget!.isNotEmpty) {
      args.addAll(['--push-target', pushTarget!]);
    }

    if (useNewDisplay) {
      if (newDisplaySize != null && newDisplaySize!.isNotEmpty) {
        args.addAll(['--new-display=$newDisplaySize']);
      } else {
        args.add('--new-display');
      }
    }
    if (startApp != null && startApp!.isNotEmpty) {
      args.addAll(['--start-app', startApp!]);
    }

    if (cameraMode) {
      args.add('--video-source=camera');
      if (cameraId != null && cameraId!.isNotEmpty) {
        args.addAll(['--camera-id', cameraId!]);
      }
      if (cameraSize != null && cameraSize!.isNotEmpty) {
        args.addAll(['--camera-size', cameraSize!]);
      }
      if (cameraFacing != null && cameraFacing!.isNotEmpty) {
        args.addAll(['--camera-facing', cameraFacing!]);
      }
      if (cameraAr != null && cameraAr!.isNotEmpty) {
        args.addAll(['--camera-ar', cameraAr!]);
      }
      if (cameraFps != null) {
        args.addAll(['--camera-fps', '$cameraFps']);
      }
      if (cameraHighSpeed) args.add('--camera-high-speed');
    }

    if (otgMode) args.add('--otg');

    if (forceAdbForward) args.add('--force-adb-forward');
    if (tunnelHost != null && tunnelHost!.isNotEmpty) {
      args.addAll(['--tunnel-host', tunnelHost!]);
    }
    if (tunnelPort != null) {
      args.addAll(['--tunnel-port', '$tunnelPort']);
    }

    if (noDisplay) args.add('--no-display');
    if (noVideo) args.add('--no-video');
    if (noAudio && audioEnabled) args.add('--no-audio');
    if (noControl && controlEnabled) args.add('--no-control');
    if (noCleanup) args.add('--no-cleanup');
    if (logLevel != 'info') {
      args.addAll(['--log-level', logLevel]);
    }

    return args;
  }

  String _buildDefaultRecordPath() {
    final now = DateTime.now();
    final timestamp =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}';
    final ext = recordFormat.toLowerCase();
    final fileName = 'super_scrcpy_$timestamp.$ext';
    final folder = _resolveRecordFolder();
    if (folder.isEmpty) return fileName;
    return '$folder${Platform.pathSeparator}$fileName';
  }

  String _resolveRecordFolder() {
    if (recordFolder != null && recordFolder!.trim().isNotEmpty) {
      return recordFolder!.trim();
    }

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

  bool _isAutoGeneratedRecordPath(String path) {
    final normalized = path.trim().replaceAll('\\', '/');
    if (normalized.isEmpty) return false;
    final name = normalized.split('/').last.toLowerCase();
    return name.startsWith('super_scrcpy_');
  }

  ScrcpyConfig copyWith({
    String? videoCodec,
    int? maxSize,
    int? videoBitRate,
    int? maxFps,
    String? crop,
    int? displayId,
    String? captureOrientation,
    String? videoEncoder,
    String? codecOptions,
    int? displayBuffer,
    int? angle,
    bool? audioEnabled,
    String? audioCodec,
    int? audioBitRate,
    String? audioSource,
    int? audioBuffer,
    bool? recording,
    String? recordFile,
    String? recordFolder,
    String? recordFormat,
    bool? fullscreen,
    bool? alwaysOnTop,
    bool? borderless,
    String? windowTitle,
    int? windowX,
    int? windowY,
    int? windowWidth,
    int? windowHeight,
    bool? controlEnabled,
    bool? showTouches,
    bool? stayAwake,
    bool? turnScreenOff,
    bool? hidKeyboard,
    bool? hidMouse,
    String? keyboardMode,
    String? mouseMode,
    String? gamepadMode,
    bool? forwardAllClicks,
    bool? noClipboardAutosync,
    bool? noKeyRepeat,
    int? screenOffTimeout,
    int? timeLimit,
    bool? powerOffOnClose,
    String? pushTarget,
    bool? useNewDisplay,
    String? newDisplaySize,
    String? startApp,
    bool? cameraMode,
    String? cameraId,
    String? cameraSize,
    String? cameraFacing,
    String? cameraAr,
    int? cameraFps,
    bool? cameraHighSpeed,
    bool? otgMode,
    bool? forceAdbForward,
    String? tunnelHost,
    int? tunnelPort,
    bool? noDisplay,
    bool? noVideo,
    bool? noAudio,
    bool? noControl,
    bool? noCleanup,
    bool? disableScreensaver,
    String? logLevel,
    Set<String>? clearFields,
  }) {
    bool clear(String field) => clearFields?.contains(field) ?? false;

    return ScrcpyConfig(
      videoCodec: videoCodec ?? this.videoCodec,
      maxSize: clear('maxSize') ? null : (maxSize ?? this.maxSize),
      videoBitRate: clear('videoBitRate')
          ? null
          : (videoBitRate ?? this.videoBitRate),
      maxFps: clear('maxFps') ? null : (maxFps ?? this.maxFps),
      crop: clear('crop') ? null : (crop ?? this.crop),
      displayId: clear('displayId') ? null : (displayId ?? this.displayId),
      captureOrientation: clear('captureOrientation')
          ? null
          : (captureOrientation ?? this.captureOrientation),
      videoEncoder: clear('videoEncoder')
          ? null
          : (videoEncoder ?? this.videoEncoder),
      codecOptions: clear('codecOptions')
          ? null
          : (codecOptions ?? this.codecOptions),
      displayBuffer: clear('displayBuffer')
          ? null
          : (displayBuffer ?? this.displayBuffer),
      angle: clear('angle') ? null : (angle ?? this.angle),
      audioEnabled: audioEnabled ?? this.audioEnabled,
      audioCodec: audioCodec ?? this.audioCodec,
      audioBitRate: clear('audioBitRate')
          ? null
          : (audioBitRate ?? this.audioBitRate),
      audioSource: audioSource ?? this.audioSource,
      audioBuffer: clear('audioBuffer')
          ? null
          : (audioBuffer ?? this.audioBuffer),
      recording: recording ?? this.recording,
      recordFile: clear('recordFile') ? null : (recordFile ?? this.recordFile),
      recordFolder: clear('recordFolder')
          ? null
          : (recordFolder ?? this.recordFolder),
      recordFormat: recordFormat ?? this.recordFormat,
      fullscreen: fullscreen ?? this.fullscreen,
      alwaysOnTop: alwaysOnTop ?? this.alwaysOnTop,
      borderless: borderless ?? this.borderless,
      windowTitle: clear('windowTitle')
          ? null
          : (windowTitle ?? this.windowTitle),
      windowX: clear('windowX') ? null : (windowX ?? this.windowX),
      windowY: clear('windowY') ? null : (windowY ?? this.windowY),
      windowWidth: clear('windowWidth')
          ? null
          : (windowWidth ?? this.windowWidth),
      windowHeight: clear('windowHeight')
          ? null
          : (windowHeight ?? this.windowHeight),
      controlEnabled: controlEnabled ?? this.controlEnabled,
      showTouches: showTouches ?? this.showTouches,
      stayAwake: stayAwake ?? this.stayAwake,
      turnScreenOff: turnScreenOff ?? this.turnScreenOff,
      hidKeyboard: hidKeyboard ?? this.hidKeyboard,
      hidMouse: hidMouse ?? this.hidMouse,
      keyboardMode: clear('keyboardMode')
          ? null
          : (keyboardMode ?? this.keyboardMode),
      mouseMode: clear('mouseMode') ? null : (mouseMode ?? this.mouseMode),
      gamepadMode: clear('gamepadMode')
          ? null
          : (gamepadMode ?? this.gamepadMode),
      forwardAllClicks: forwardAllClicks ?? this.forwardAllClicks,
      noClipboardAutosync: noClipboardAutosync ?? this.noClipboardAutosync,
      noKeyRepeat: noKeyRepeat ?? this.noKeyRepeat,
      screenOffTimeout: clear('screenOffTimeout')
          ? null
          : (screenOffTimeout ?? this.screenOffTimeout),
      timeLimit: clear('timeLimit') ? null : (timeLimit ?? this.timeLimit),
      powerOffOnClose: powerOffOnClose ?? this.powerOffOnClose,
      pushTarget: clear('pushTarget') ? null : (pushTarget ?? this.pushTarget),
      useNewDisplay: useNewDisplay ?? this.useNewDisplay,
      newDisplaySize: clear('newDisplaySize')
          ? null
          : (newDisplaySize ?? this.newDisplaySize),
      startApp: clear('startApp') ? null : (startApp ?? this.startApp),
      cameraMode: cameraMode ?? this.cameraMode,
      cameraId: clear('cameraId') ? null : (cameraId ?? this.cameraId),
      cameraSize: clear('cameraSize') ? null : (cameraSize ?? this.cameraSize),
      cameraFacing: clear('cameraFacing')
          ? null
          : (cameraFacing ?? this.cameraFacing),
      cameraAr: clear('cameraAr') ? null : (cameraAr ?? this.cameraAr),
      cameraFps: clear('cameraFps') ? null : (cameraFps ?? this.cameraFps),
      cameraHighSpeed: cameraHighSpeed ?? this.cameraHighSpeed,
      otgMode: otgMode ?? this.otgMode,
      forceAdbForward: forceAdbForward ?? this.forceAdbForward,
      tunnelHost: clear('tunnelHost') ? null : (tunnelHost ?? this.tunnelHost),
      tunnelPort: clear('tunnelPort') ? null : (tunnelPort ?? this.tunnelPort),
      noDisplay: noDisplay ?? this.noDisplay,
      noVideo: noVideo ?? this.noVideo,
      noAudio: noAudio ?? this.noAudio,
      noControl: noControl ?? this.noControl,
      noCleanup: noCleanup ?? this.noCleanup,
      disableScreensaver: disableScreensaver ?? this.disableScreensaver,
      logLevel: logLevel ?? this.logLevel,
    );
  }

  List<ConfigEntry> getConfigEntries() {
    final defaults = ScrcpyConfig();
    final entries = <ConfigEntry>[];

    if (videoCodec != defaults.videoCodec) {
      entries.add(
        ConfigEntry(
          configKey: 'videoCodec',
          label: 'Codec: $videoCodec',
          cliArg: '--video-codec $videoCodec',
        ),
      );
    }
    if (maxSize != defaults.maxSize) {
      entries.add(
        ConfigEntry(
          configKey: 'maxSize',
          label: 'Max Size: $maxSize',
          cliArg: '-m $maxSize',
        ),
      );
    }
    if (videoBitRate != defaults.videoBitRate) {
      final brStr = videoBitRate! >= 1000000
          ? '${(videoBitRate! / 1000000).toStringAsFixed(1)}M'
          : '${videoBitRate}';
      entries.add(
        ConfigEntry(
          configKey: 'videoBitRate',
          label: 'Bitrate: $brStr',
          cliArg: '-b $videoBitRate',
        ),
      );
    }
    if (maxFps != defaults.maxFps) {
      entries.add(
        ConfigEntry(
          configKey: 'maxFps',
          label: 'FPS: $maxFps',
          cliArg: '--max-fps $maxFps',
        ),
      );
    }
    if (crop != defaults.crop) {
      entries.add(
        ConfigEntry(
          configKey: 'crop',
          label: 'Crop: $crop',
          cliArg: '--crop $crop',
        ),
      );
    }
    if (displayId != defaults.displayId) {
      entries.add(
        ConfigEntry(
          configKey: 'displayId',
          label: 'Display: $displayId',
          cliArg: '--display $displayId',
        ),
      );
    }
    if (captureOrientation != defaults.captureOrientation) {
      entries.add(
        ConfigEntry(
          configKey: 'captureOrientation',
          label: 'Orientation: $captureOrientation',
          cliArg: '--capture-orientation $captureOrientation',
        ),
      );
    }
    if (videoEncoder != defaults.videoEncoder) {
      entries.add(
        ConfigEntry(
          configKey: 'videoEncoder',
          label: 'Encoder: $videoEncoder',
          cliArg: '--encoder $videoEncoder',
        ),
      );
    }
    if (codecOptions != defaults.codecOptions) {
      entries.add(
        ConfigEntry(
          configKey: 'codecOptions',
          label: 'Codec Opts',
          cliArg: '--codec-options $codecOptions',
        ),
      );
    }
    if (displayBuffer != defaults.displayBuffer) {
      entries.add(
        ConfigEntry(
          configKey: 'displayBuffer',
          label: 'Buffer: ${displayBuffer}ms',
          cliArg: '--display-buffer $displayBuffer',
        ),
      );
    }
    if (angle != defaults.angle) {
      entries.add(
        ConfigEntry(
          configKey: 'angle',
          label: 'Angle: $angle°',
          cliArg: '--angle $angle',
        ),
      );
    }
    if (audioEnabled != defaults.audioEnabled) {
      entries.add(
        ConfigEntry(
          configKey: 'audioEnabled',
          label: 'No Audio',
          cliArg: '--no-audio',
        ),
      );
    }
    if (audioCodec != defaults.audioCodec) {
      entries.add(
        ConfigEntry(
          configKey: 'audioCodec',
          label: 'Audio: $audioCodec',
          cliArg: '--audio-codec $audioCodec',
        ),
      );
    }
    if (audioBitRate != defaults.audioBitRate) {
      entries.add(
        ConfigEntry(
          configKey: 'audioBitRate',
          label: 'Audio BR: $audioBitRate',
          cliArg: '--audio-bit-rate $audioBitRate',
        ),
      );
    }
    if (audioSource != defaults.audioSource) {
      entries.add(
        ConfigEntry(
          configKey: 'audioSource',
          label: 'Source: $audioSource',
          cliArg: '--audio-source $audioSource',
        ),
      );
    }
    if (audioBuffer != defaults.audioBuffer) {
      entries.add(
        ConfigEntry(
          configKey: 'audioBuffer',
          label: 'Audio Buf: ${audioBuffer}ms',
          cliArg: '--audio-buffer $audioBuffer',
        ),
      );
    }
    if (recording != defaults.recording) {
      entries.add(
        ConfigEntry(
          configKey: 'recording',
          label: 'Recording',
          cliArg: '-r ${recordFile ?? _buildDefaultRecordPath()}',
        ),
      );
    }
    if (recordFolder != defaults.recordFolder) {
      entries.add(
        ConfigEntry(
          configKey: 'recordFolder',
          label: 'Record Folder: $recordFolder',
          cliArg: '--record-folder $recordFolder',
        ),
      );
    }
    if (fullscreen != defaults.fullscreen) {
      entries.add(
        ConfigEntry(configKey: 'fullscreen', label: 'Fullscreen', cliArg: '-f'),
      );
    }
    if (alwaysOnTop != defaults.alwaysOnTop) {
      entries.add(
        ConfigEntry(
          configKey: 'alwaysOnTop',
          label: 'Always On Top',
          cliArg: '--always-on-top',
        ),
      );
    }
    if (borderless != defaults.borderless) {
      entries.add(
        ConfigEntry(
          configKey: 'borderless',
          label: 'Borderless',
          cliArg: '--window-borderless',
        ),
      );
    }
    if (windowTitle != defaults.windowTitle) {
      entries.add(
        ConfigEntry(
          configKey: 'windowTitle',
          label: 'Title: $windowTitle',
          cliArg: '--window-title $windowTitle',
        ),
      );
    }
    if (controlEnabled != defaults.controlEnabled) {
      entries.add(
        ConfigEntry(
          configKey: 'controlEnabled',
          label: 'No Control',
          cliArg: '-n',
        ),
      );
    }
    if (showTouches != defaults.showTouches) {
      entries.add(
        ConfigEntry(
          configKey: 'showTouches',
          label: 'Show Touches',
          cliArg: '-t',
        ),
      );
    }
    if (stayAwake != defaults.stayAwake) {
      entries.add(
        ConfigEntry(configKey: 'stayAwake', label: 'Stay Awake', cliArg: '-w'),
      );
    }
    if (turnScreenOff != defaults.turnScreenOff) {
      entries.add(
        ConfigEntry(
          configKey: 'turnScreenOff',
          label: 'Screen Off',
          cliArg: '-S',
        ),
      );
    }
    if (keyboardMode != defaults.keyboardMode) {
      entries.add(
        ConfigEntry(
          configKey: 'keyboardMode',
          label: 'KB Mode: $keyboardMode',
          cliArg: '--keyboard $keyboardMode',
        ),
      );
    } else if (hidKeyboard != defaults.hidKeyboard) {
      entries.add(
        ConfigEntry(
          configKey: 'hidKeyboard',
          label: 'HID Keyboard',
          cliArg: '-K',
        ),
      );
    }

    if (mouseMode != defaults.mouseMode) {
      entries.add(
        ConfigEntry(
          configKey: 'mouseMode',
          label: 'Mouse Mode: $mouseMode',
          cliArg: '--mouse $mouseMode',
        ),
      );
    } else if (hidMouse != defaults.hidMouse) {
      entries.add(
        ConfigEntry(configKey: 'hidMouse', label: 'HID Mouse', cliArg: '-M'),
      );
    }

    if (gamepadMode != defaults.gamepadMode) {
      entries.add(
        ConfigEntry(
          configKey: 'gamepadMode',
          label: 'Gamepad: $gamepadMode',
          cliArg: '--gamepad $gamepadMode',
        ),
      );
    }
    if (forwardAllClicks != defaults.forwardAllClicks) {
      entries.add(
        ConfigEntry(
          configKey: 'forwardAllClicks',
          label: 'Fwd Clicks',
          cliArg: '--forward-all-clicks',
        ),
      );
    }
    if (noClipboardAutosync != defaults.noClipboardAutosync) {
      entries.add(
        ConfigEntry(
          configKey: 'noClipboardAutosync',
          label: 'No Clipboard',
          cliArg: '--no-clipboard-autosync',
        ),
      );
    }
    if (noKeyRepeat != defaults.noKeyRepeat) {
      entries.add(
        ConfigEntry(
          configKey: 'noKeyRepeat',
          label: 'No Key Repeat',
          cliArg: '--no-key-repeat',
        ),
      );
    }
    if (powerOffOnClose != defaults.powerOffOnClose) {
      entries.add(
        ConfigEntry(
          configKey: 'powerOffOnClose',
          label: 'Power Off',
          cliArg: '--power-off-on-close',
        ),
      );
    }
    if (useNewDisplay != defaults.useNewDisplay) {
      final suffix = (newDisplaySize != null && newDisplaySize!.isNotEmpty)
          ? '=$newDisplaySize'
          : '';
      entries.add(
        ConfigEntry(
          configKey: 'useNewDisplay',
          label: 'New Display$suffix',
          cliArg: '--new-display$suffix',
        ),
      );
    }
    if (startApp != defaults.startApp) {
      entries.add(
        ConfigEntry(
          configKey: 'startApp',
          label: 'App: $startApp',
          cliArg: '--start-app $startApp',
        ),
      );
    }
    if (cameraMode != defaults.cameraMode) {
      entries.add(
        ConfigEntry(
          configKey: 'cameraMode',
          label: 'Camera',
          cliArg: '--video-source=camera',
        ),
      );
    }
    if (otgMode != defaults.otgMode) {
      entries.add(
        ConfigEntry(configKey: 'otgMode', label: 'OTG', cliArg: '--otg'),
      );
    }
    if (noDisplay != defaults.noDisplay) {
      entries.add(
        ConfigEntry(
          configKey: 'noDisplay',
          label: 'No Display',
          cliArg: '--no-display',
        ),
      );
    }
    if (noVideo != defaults.noVideo) {
      entries.add(
        ConfigEntry(
          configKey: 'noVideo',
          label: 'No Video',
          cliArg: '--no-video',
        ),
      );
    }
    if (noCleanup != defaults.noCleanup) {
      entries.add(
        ConfigEntry(
          configKey: 'noCleanup',
          label: 'No Cleanup',
          cliArg: '--no-cleanup',
        ),
      );
    }
    if (disableScreensaver != defaults.disableScreensaver) {
      entries.add(
        ConfigEntry(
          configKey: 'disableScreensaver',
          label: 'No Screensaver',
          cliArg: '--disable-screensaver',
        ),
      );
    }
    if (logLevel != defaults.logLevel) {
      entries.add(
        ConfigEntry(
          configKey: 'logLevel',
          label: 'Log: $logLevel',
          cliArg: '--log-level $logLevel',
        ),
      );
    }
    if (timeLimit != defaults.timeLimit) {
      entries.add(
        ConfigEntry(
          configKey: 'timeLimit',
          label: 'Time Limit: ${timeLimit}s',
          cliArg: '--time-limit $timeLimit',
        ),
      );
    }

    return entries;
  }

  void resetSingleConfig(String configKey) {
    final defaults = ScrcpyConfig();
    switch (configKey) {
      case 'videoCodec':
        videoCodec = defaults.videoCodec;
      case 'maxSize':
        maxSize = defaults.maxSize;
      case 'videoBitRate':
        videoBitRate = defaults.videoBitRate;
      case 'maxFps':
        maxFps = defaults.maxFps;
      case 'crop':
        crop = defaults.crop;
      case 'displayId':
        displayId = defaults.displayId;
      case 'captureOrientation':
        captureOrientation = defaults.captureOrientation;
      case 'videoEncoder':
        videoEncoder = defaults.videoEncoder;
      case 'codecOptions':
        codecOptions = defaults.codecOptions;
      case 'displayBuffer':
        displayBuffer = defaults.displayBuffer;
      case 'angle':
        angle = defaults.angle;
      case 'audioEnabled':
        audioEnabled = defaults.audioEnabled;
      case 'audioCodec':
        audioCodec = defaults.audioCodec;
      case 'audioBitRate':
        audioBitRate = defaults.audioBitRate;
      case 'audioSource':
        audioSource = defaults.audioSource;
      case 'audioBuffer':
        audioBuffer = defaults.audioBuffer;
      case 'recording':
        recording = defaults.recording;
        recordFile = defaults.recordFile;
        recordFolder = defaults.recordFolder;
      case 'recordFormat':
        recordFormat = defaults.recordFormat;
      case 'recordFolder':
        recordFolder = defaults.recordFolder;
      case 'fullscreen':
        fullscreen = defaults.fullscreen;
      case 'alwaysOnTop':
        alwaysOnTop = defaults.alwaysOnTop;
      case 'borderless':
        borderless = defaults.borderless;
      case 'windowTitle':
        windowTitle = defaults.windowTitle;
      case 'controlEnabled':
        controlEnabled = defaults.controlEnabled;
      case 'showTouches':
        showTouches = defaults.showTouches;
      case 'stayAwake':
        stayAwake = defaults.stayAwake;
      case 'turnScreenOff':
        turnScreenOff = defaults.turnScreenOff;
      case 'hidKeyboard':
        hidKeyboard = defaults.hidKeyboard;
      case 'hidMouse':
        hidMouse = defaults.hidMouse;
      case 'keyboardMode':
        keyboardMode = defaults.keyboardMode;
      case 'mouseMode':
        mouseMode = defaults.mouseMode;
      case 'gamepadMode':
        gamepadMode = defaults.gamepadMode;
      case 'forwardAllClicks':
        forwardAllClicks = defaults.forwardAllClicks;
      case 'noClipboardAutosync':
        noClipboardAutosync = defaults.noClipboardAutosync;
      case 'noKeyRepeat':
        noKeyRepeat = defaults.noKeyRepeat;
      case 'timeLimit':
        timeLimit = defaults.timeLimit;
      case 'powerOffOnClose':
        powerOffOnClose = defaults.powerOffOnClose;
      case 'useNewDisplay':
        useNewDisplay = defaults.useNewDisplay;
        newDisplaySize = defaults.newDisplaySize;
      case 'startApp':
        startApp = defaults.startApp;
      case 'cameraMode':
        cameraMode = defaults.cameraMode;
      case 'otgMode':
        otgMode = defaults.otgMode;
      case 'noDisplay':
        noDisplay = defaults.noDisplay;
      case 'noVideo':
        noVideo = defaults.noVideo;
      case 'noCleanup':
        noCleanup = defaults.noCleanup;
      case 'disableScreensaver':
        disableScreensaver = defaults.disableScreensaver;
      case 'logLevel':
        logLevel = defaults.logLevel;
    }
  }
}
