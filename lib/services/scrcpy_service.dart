import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import '../models/adb_device.dart';
import '../models/scrcpy_config.dart';

class ScrcpyService {
  String _scrcpyPath = '';
  String _adbPath = '';
  Process? _scrcpyProcess;
  final List<String> _logBuffer = [];
  final StreamController<String> _logController =
      StreamController<String>.broadcast();
  final StreamController<bool> _runningController =
      StreamController<bool>.broadcast();

  Stream<String> get logStream => _logController.stream;
  Stream<bool> get runningStream => _runningController.stream;
  List<String> get logs => List.unmodifiable(_logBuffer);
  bool get isRunning => _scrcpyProcess != null;

  String get scrcpyPath => _scrcpyPath;
  String get adbPath => _adbPath;

  void setScrcpyPath(String path) {
    _scrcpyPath = path;
    final ext = Platform.isWindows ? '.exe' : '';
    final scrcpyExe = '$path${Platform.pathSeparator}scrcpy$ext';
    final adbExe = '$path${Platform.pathSeparator}adb$ext';

    if (File(scrcpyExe).existsSync()) {
      _scrcpyPath = scrcpyExe;
    }
    if (File(adbExe).existsSync()) {
      _adbPath = adbExe;
    } else {
      _adbPath = 'adb';
    }
  }

  Future<bool> autoDetect() async {
    try {
      final result = await Process.run(Platform.isWindows ? 'where' : 'which', [
        'scrcpy',
      ], runInShell: true);
      if (result.exitCode == 0) {
        final path = (result.stdout as String).trim().split('\n').first.trim();
        if (path.isNotEmpty) {
          final dir = File(path).parent.path;
          setScrcpyPath(dir);
          return true;
        }
      }
    } catch (_) {}

    if (Platform.isWindows) {
      final commonPaths = [
        '${Platform.environment['USERPROFILE']}\\scrcpy',
        '${Platform.environment['LOCALAPPDATA']}\\scrcpy',
        'C:\\scrcpy',
        '${Platform.environment['ProgramFiles']}\\scrcpy',
      ];
      for (final p in commonPaths) {
        if (File('$p\\scrcpy.exe').existsSync()) {
          setScrcpyPath(p);
          return true;
        }
      }
    } else {
      final commonPaths = ['/opt/homebrew/bin', '/usr/local/bin', '/usr/bin'];
      for (final p in commonPaths) {
        if (File('$p/scrcpy').existsSync()) {
          setScrcpyPath(p);
          return true;
        }
      }
    }

    return false;
  }

  Future<String?> getVersion() async {
    try {
      final result = await Process.run(
        _scrcpyPath.isNotEmpty ? _scrcpyPath : 'scrcpy',
        ['--version'],
        runInShell: true,
      );
      if (result.exitCode == 0) {
        return (result.stdout as String).trim().split('\n').first;
      }
    } catch (_) {}
    return null;
  }

  Future<List<AdbDevice>> listDevices() async {
    try {
      final adb = _adbPath.isNotEmpty ? _adbPath : 'adb';
      final result = await Process.run(adb, [
        'devices',
        '-l',
      ], runInShell: true);
      if (result.exitCode != 0) return [];

      final lines = (result.stdout as String)
          .replaceAll('\r\n', '\n')
          .split('\n');
      final devices = <AdbDevice>[];

      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty ||
            trimmed.startsWith('List of') ||
            trimmed.startsWith('*')) {
          continue;
        }

        final parts = trimmed.split(RegExp(r'\s+'));
        if (parts.length < 2) continue;

        final serial = parts[0];
        final state = parts[1];

        String? model;
        String? product;
        String? transportId;

        for (final part in parts.skip(2)) {
          if (part.startsWith('model:')) {
            model = part.substring(6);
          } else if (part.startsWith('product:')) {
            product = part.substring(8);
          } else if (part.startsWith('transport_id:')) {
            transportId = part.substring(13);
          }
        }

        devices.add(
          AdbDevice(
            serial: serial,
            state: state,
            model: model,
            product: product,
            transportId: transportId,
          ),
        );
      }

      return devices;
    } catch (e) {
      _addLog('Error listing devices: $e');
      return [];
    }
  }

  Future<bool> connectWifi(String ip, {int port = 5555}) async {
    try {
      final adb = _adbPath.isNotEmpty ? _adbPath : 'adb';
      final result = await Process.run(adb, [
        'connect',
        '$ip:$port',
      ], runInShell: true);
      final output = (result.stdout as String).trim();
      _addLog('ADB Connect: $output');
      return output.contains('connected');
    } catch (e) {
      _addLog('Error: $e');
      return false;
    }
  }

  Future<bool> tcpipMode(String serial, {int port = 5555}) async {
    try {
      final adb = _adbPath.isNotEmpty ? _adbPath : 'adb';
      final result = await Process.run(adb, [
        '-s',
        serial,
        'tcpip',
        '$port',
      ], runInShell: true);
      final output = (result.stdout as String).trim();
      _addLog('TCPIP Mode: $output');
      return result.exitCode == 0;
    } catch (e) {
      _addLog('Error: $e');
      return false;
    }
  }

  Future<void> disconnectWifi(String address) async {
    try {
      final adb = _adbPath.isNotEmpty ? _adbPath : 'adb';
      final result = await Process.run(adb, [
        'disconnect',
        address,
      ], runInShell: true);
      _addLog('ADB Disconnect: ${(result.stdout as String).trim()}');
    } catch (e) {
      _addLog('Error: $e');
    }
  }

  Future<bool> pairDevice(String ip, int port, String code) async {
    try {
      final adb = _adbPath.isNotEmpty ? _adbPath : 'adb';
      final result = await Process.run(adb, [
        'pair',
        '$ip:$port',
        code,
      ], runInShell: true);
      final output = (result.stdout as String).trim();
      _addLog('ADB Pair: $output');
      return output.contains('Successfully paired');
    } catch (e) {
      _addLog('Error: $e');
      return false;
    }
  }

  String buildWirelessDebugQrPayload({
    required String pairingCode,
    String serviceName = 'super-scrcpy',
  }) {
    return 'WIFI:T:ADB;S:$serviceName;P:$pairingCode;;';
  }

  Future<bool> connectWithQrPairing({
    required String pairingCode,
    String serviceName = 'super-scrcpy',
    Duration timeout = const Duration(seconds: 35),
  }) async {
    _addLog('Wireless QR: waiting for pairing service...');

    final pairingTarget = await _waitForMdnsService(
      serviceType: '_adb-tls-pairing._tcp',
      timeout: timeout,
      preferredServiceName: serviceName,
    );

    if (pairingTarget == null) {
      _addLog('Wireless QR: no pairing service discovered in time.');
      return false;
    }

    final paired = await pairDevice(
      pairingTarget.ip,
      pairingTarget.port,
      pairingCode,
    );
    if (!paired) {
      _addLog('Wireless QR: pairing failed.');
      return false;
    }

    _addLog('Wireless QR: paired. Waiting for connect service...');
    final connectTarget = await _waitForMdnsService(
      serviceType: '_adb-tls-connect._tcp',
      timeout: const Duration(seconds: 12),
      preferredAddress: pairingTarget.ip,
      preferredServiceName: serviceName,
    );

    if (connectTarget == null) {
      _addLog('Wireless QR: no connect service discovered after pairing.');
      return false;
    }

    return connectWifi(connectTarget.ip, port: connectTarget.port);
  }

  Future<_AdbMdnsService?> _waitForMdnsService({
    required String serviceType,
    required Duration timeout,
    String? preferredAddress,
    String? preferredServiceName,
  }) async {
    final deadline = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(deadline)) {
      final services = await _listMdnsServices();
      final candidates = services.where((s) => s.type == serviceType).toList();

      if (candidates.isNotEmpty) {
        _AdbMdnsService picked = candidates.first;

        if (preferredAddress != null) {
          final byAddress = candidates.where((c) => c.ip == preferredAddress);
          if (byAddress.isNotEmpty) {
            picked = byAddress.first;
          }
        }

        if (preferredServiceName != null && preferredServiceName.isNotEmpty) {
          final needle = preferredServiceName.toLowerCase();
          final byName = candidates.where(
            (c) => c.name.toLowerCase().contains(needle),
          );
          if (byName.isNotEmpty) {
            picked = byName.first;
          }
        }

        return picked;
      }

      await Future.delayed(const Duration(milliseconds: 1200));
    }

    return null;
  }

  Future<List<_AdbMdnsService>> _listMdnsServices() async {
    try {
      final adb = _adbPath.isNotEmpty ? _adbPath : 'adb';
      final result = await Process.run(adb, [
        'mdns',
        'services',
      ], runInShell: true);

      if (result.exitCode != 0) {
        final error = (result.stderr as String).trim();
        if (error.isNotEmpty) {
          _addLog('Wireless QR: adb mdns services failed: $error');
        }
        return [];
      }

      final output = (result.stdout as String).replaceAll('\r\n', '\n');
      final lines = output.split('\n');
      final services = <_AdbMdnsService>[];

      for (final rawLine in lines) {
        final line = rawLine.trim();
        if (line.isEmpty ||
            line.startsWith('List of') ||
            line.startsWith('*')) {
          continue;
        }

        final type = line.contains('_adb-tls-pairing._tcp')
            ? '_adb-tls-pairing._tcp'
            : line.contains('_adb-tls-connect._tcp')
            ? '_adb-tls-connect._tcp'
            : null;
        if (type == null) continue;

        final ipPort = RegExp(r'(\d+\.\d+\.\d+\.\d+):(\d+)').firstMatch(line);
        if (ipPort == null) continue;

        final ip = ipPort.group(1)!;
        final port = int.tryParse(ipPort.group(2)!);
        if (port == null) continue;

        final name = line.split(RegExp(r'\s+')).first;
        services.add(
          _AdbMdnsService(name: name, type: type, ip: ip, port: port),
        );
      }

      return services;
    } catch (e) {
      _addLog('Wireless QR: mdns scan error: $e');
      return [];
    }
  }

  Future<List<String>> listApps(String serial) async {
    try {
      final scrcpy = _scrcpyPath.isNotEmpty ? _scrcpyPath : 'scrcpy';
      final result = await Process.run(scrcpy, [
        '-s',
        serial,
        '--list-apps',
      ], runInShell: true);
      if (result.exitCode == 0) {
        return (result.stdout as String)
            .split('\n')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty && !l.startsWith('['))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<String>> listDisplays(String serial) async {
    try {
      final scrcpy = _scrcpyPath.isNotEmpty ? _scrcpyPath : 'scrcpy';
      final result = await Process.run(scrcpy, [
        '-s',
        serial,
        '--list-displays',
      ], runInShell: true);
      if (result.exitCode == 0) {
        return (result.stdout as String)
            .split('\n')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty && !l.startsWith('['))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<String>> listCameras(String serial) async {
    try {
      final scrcpy = _scrcpyPath.isNotEmpty ? _scrcpyPath : 'scrcpy';
      final result = await Process.run(scrcpy, [
        '-s',
        serial,
        '--list-cameras',
      ], runInShell: true);
      if (result.exitCode == 0) {
        return (result.stdout as String)
            .split('\n')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty && !l.startsWith('['))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<bool> start(String serial, ScrcpyConfig config) async {
    await _closeAnyExistingMirroring();

    final scrcpy = _scrcpyPath.isNotEmpty ? _scrcpyPath : 'scrcpy';
    final args = ['-s', serial, ...config.buildArgs()];

    _addLog('> $scrcpy ${args.join(' ')}');

    try {
      _scrcpyProcess = await Process.start(scrcpy, args, runInShell: true);
      _runningController.add(true);

      _scrcpyProcess!.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
            _addLog(line);
          });

      _scrcpyProcess!.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
            _addLog('[ERR] $line');
          });

      _scrcpyProcess!.exitCode.then((code) {
        _addLog('scrcpy exited with code $code');
        _scrcpyProcess = null;
        _runningController.add(false);
      });

      return true;
    } catch (e) {
      _addLog('Failed to start scrcpy: $e');
      _scrcpyProcess = null;
      _runningController.add(false);
      return false;
    }
  }

  Future<void> _closeAnyExistingMirroring() async {
    if (_scrcpyProcess != null) {
      _addLog('Stopping previous scrcpy instance...');
      await stop();
    }

    try {
      if (Platform.isWindows) {
        final result = await Process.run('taskkill', [
          '/IM',
          'scrcpy.exe',
          '/F',
        ], runInShell: true);

        final output = ((result.stdout as String).trim());
        final error = ((result.stderr as String).trim());

        if (result.exitCode == 0 && output.isNotEmpty) {
          _addLog('Closed existing mirroring session(s).');
        } else if (error.isNotEmpty &&
            !error.toLowerCase().contains('not found')) {
          _addLog('Mirror cleanup warning: $error');
        }
      } else {
        final result = await Process.run('pkill', [
          '-f',
          'scrcpy',
        ], runInShell: true);
        if (result.exitCode == 0) {
          _addLog('Closed existing mirroring session(s).');
        }
      }
    } catch (e) {
      _addLog('Mirror cleanup warning: $e');
    }
  }

  Future<bool> installApk(String serial, String apkPath) async {
    try {
      final adb = _adbPath.isNotEmpty ? _adbPath : 'adb';
      _addLog('> adb -s $serial install -r "$apkPath"');
      final result = await Process.run(adb, [
        '-s',
        serial,
        'install',
        '-r',
        apkPath,
      ], runInShell: true);
      final output = (result.stdout as String).trim();
      final error = (result.stderr as String).trim();
      if (output.isNotEmpty) _addLog(output);
      if (error.isNotEmpty) _addLog('[ERR] $error');
      return output.contains('Success');
    } catch (e) {
      _addLog('Failed to install APK: $e');
      return false;
    }
  }

  Future<void> stop() async {
    if (_scrcpyProcess != null) {
      final process = _scrcpyProcess!;
      _scrcpyProcess = null;
      _runningController.add(false);
      _addLog('Stopping scrcpy...');

      process.kill();

      try {
        await process.exitCode.timeout(
          const Duration(seconds: 2),
          onTimeout: () {
            process.kill(ProcessSignal.sigkill);
            _addLog('Force killed scrcpy process.');
            return -1;
          },
        );
      } catch (_) {}
      _addLog('scrcpy stopped.');
    }
  }

  Future<String?> getDeviceIp(String serial) async {
    try {
      final adb = _adbPath.isNotEmpty ? _adbPath : 'adb';
      final result = await Process.run(adb, [
        '-s',
        serial,
        'shell',
        'ip',
        'route',
      ], runInShell: true);
      if (result.exitCode == 0) {
        final output = result.stdout as String;
        final match = RegExp(r'src (\d+\.\d+\.\d+\.\d+)').firstMatch(output);
        if (match != null) return match.group(1);
      }
    } catch (_) {}
    return null;
  }

  void _addLog(String msg) {
    if (_logController.isClosed) return;
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final entry = '[$timestamp] $msg';
    _logBuffer.add(entry);
    if (_logBuffer.length > 1000) {
      _logBuffer.removeRange(0, _logBuffer.length - 1000);
    }
    _logController.add(entry);
    if (kDebugMode) {
      print(entry);
    }
  }

  void clearLogs() {
    _logBuffer.clear();
  }

  void dispose() {
    stop().then((_) {
      if (!_logController.isClosed) _logController.close();
      if (!_runningController.isClosed) _runningController.close();
    });
  }
}

class _AdbMdnsService {
  final String name;
  final String type;
  final String ip;
  final int port;

  const _AdbMdnsService({
    required this.name,
    required this.type,
    required this.ip,
    required this.port,
  });
}
