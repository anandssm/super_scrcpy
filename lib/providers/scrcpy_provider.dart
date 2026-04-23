import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/adb_device.dart';
import '../models/scrcpy_config.dart';
import '../services/scrcpy_service.dart';
import 'settings_provider.dart';

class ScrcpyProvider extends ChangeNotifier {
  final ScrcpyService _service = ScrcpyService();

  List<AdbDevice> _devices = [];
  AdbDevice? _selectedDevice;
  ScrcpyConfig _config = ScrcpyConfig();
  bool _isScanning = false;
  bool _isRunning = false;
  bool _isPathConfigured = false;
  String? _scrcpyVersion;
  int _selectedNavIndex = 0;
  final List<String> _logs = [];
  Timer? _autoRefreshTimer;

  List<String> _cachedApps = [];
  bool _isAppsFetched = false;
  SettingsProvider? _settings;
  String? _lastProfileName;

  bool _isFetchingApps = false;

  ScrcpyService get service => _service;
  List<AdbDevice> get devices => _devices;
  AdbDevice? get selectedDevice => _selectedDevice;
  ScrcpyConfig get config => _config;
  bool get isScanning => _isScanning;
  bool get isRunning => _isRunning;
  bool get isPathConfigured => _isPathConfigured;
  String? get scrcpyVersion => _scrcpyVersion;
  int get selectedNavIndex => _selectedNavIndex;
  List<String> get logs => _logs;
  String get scrcpyPath => _service.scrcpyPath;

  List<String> get cachedApps => _cachedApps;
  bool get isAppsFetched => _isAppsFetched;
  bool get isFetchingApps => _isFetchingApps;

  ScrcpyProvider() {
    _init();
    _service.logStream.listen((log) {
      _logs.add(log);
      if (_logs.length > 1000) {
        _logs.removeRange(0, _logs.length - 1000);
      }
      notifyListeners();
    });
    _service.runningStream.listen((running) {
      _isRunning = running;
      notifyListeners();
    });

    _autoRefreshTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _autoRefreshDevices(),
    );
  }

  Future<void> _autoRefreshDevices() async {
    if (!_isPathConfigured || _isScanning) return;
    try {
      final newDevices = await _service.listDevices();
      final changed =
          _devices.length != newDevices.length ||
          !_devicesMatch(_devices, newDevices);
      if (changed) {
        _devices = newDevices;

        if (_selectedDevice != null &&
            !_devices.any((d) => d.serial == _selectedDevice!.serial)) {
          _selectedDevice = null;
          _clearCachedApps();
        }

        if (_selectedDevice == null && _devices.length == 1) {
          _selectedDevice = _devices.first;
        }
        notifyListeners();
      }
    } catch (e) {
      _logs.add('Auto-refresh error: $e');
      if (_logs.length > 1000) _logs.removeRange(0, _logs.length - 1000);
      notifyListeners();
    }
  }

  bool _devicesMatch(List<AdbDevice> a, List<AdbDevice> b) {
    if (a.length != b.length) return false;
    final aMap = {for (var d in a) d.serial: d};
    final bMap = {for (var d in b) d.serial: d};
    for (final serial in aMap.keys) {
      if (bMap[serial]?.state != aMap[serial]?.state) return false;
    }
    return true;
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString('scrcpy_path');

    if (savedPath != null && savedPath.isNotEmpty) {
      _service.setScrcpyPath(savedPath);
      _isPathConfigured = true;
      _scrcpyVersion = await _service.getVersion();
      notifyListeners();
      refreshDevices();
    } else {
      final detected = await _service.autoDetect();
      if (detected) {
        _isPathConfigured = true;
        _scrcpyVersion = await _service.getVersion();
        await prefs.setString('scrcpy_path', _service.scrcpyPath);
        notifyListeners();
        refreshDevices();
      }
    }
  }

  Future<void> setScrcpyPath(String path) async {
    _service.setScrcpyPath(path);
    _isPathConfigured = true;
    _scrcpyVersion = await _service.getVersion();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('scrcpy_path', path);
    notifyListeners();
    refreshDevices();
  }

  Future<void> refreshDevices() async {
    _isScanning = true;
    notifyListeners();

    _devices = await _service.listDevices();

    if (_selectedDevice != null &&
        !_devices.any((d) => d.serial == _selectedDevice!.serial)) {
      _selectedDevice = null;
    }

    if (_selectedDevice == null && _devices.length == 1) {
      _selectedDevice = _devices.first;
    }

    _isScanning = false;
    notifyListeners();
  }

  void selectDevice(AdbDevice? device) {
    if (_selectedDevice?.serial != device?.serial) {
      _clearCachedApps();
    }
    _selectedDevice = device;
    notifyListeners();
  }

  Future<bool> connectWifi(String ip, {int port = 5555}) async {
    final result = await _service.connectWifi(ip, port: port);
    if (result) {
      await Future.delayed(const Duration(milliseconds: 500));
      await refreshDevices();
    }
    return result;
  }

  Future<bool> pairDevice(String ip, int port, String code) async {
    return await _service.pairDevice(ip, port, code);
  }

  String buildWirelessDebugQrPayload({
    required String pairingCode,
    String serviceName = 'super-scrcpy',
  }) {
    return _service.buildWirelessDebugQrPayload(
      pairingCode: pairingCode,
      serviceName: serviceName,
    );
  }

  Future<bool> connectWithQrCode({
    required String pairingCode,
    String serviceName = 'super-scrcpy',
  }) async {
    final result = await _service.connectWithQrPairing(
      pairingCode: pairingCode,
      serviceName: serviceName,
    );
    if (result) {
      await Future.delayed(const Duration(milliseconds: 500));
      await refreshDevices();
    }
    return result;
  }

  Future<bool> switchToTcpip(String serial, {int port = 5555}) async {
    return await _service.tcpipMode(serial, port: port);
  }

  Future<String?> getDeviceIp(String serial) async {
    return await _service.getDeviceIp(serial);
  }

  Future<void> disconnectWifi(String address) async {
    await _service.disconnectWifi(address);
    await refreshDevices();
  }

  Future<bool> startMirror() async {
    if (_selectedDevice == null) return false;
    final device = _selectedDevice!;
    if (!_devices.any((d) => d.serial == device.serial)) return false;

    if (_restartCompleter != null && !_restartCompleter!.isCompleted) {
      await _restartCompleter!.future;
    }

    if (_isRunning || _service.isRunning) {
      await _service.stop();
    }

    return await _service.start(device.serial, _config);
  }

  Future<void> stopMirror() async {
    await _service.stop();
  }

  void updateConfig(ScrcpyConfig Function(ScrcpyConfig) updater) {
    _config = updater(_config);
    notifyListeners();
    _restartIfRunning();
  }

  void updateConfigSilent(ScrcpyConfig Function(ScrcpyConfig) updater) {
    _config = updater(_config);
  }

  void commitConfig() {
    _settings?.saveActiveConfig(_config.copyWith());
    notifyListeners();
    _restartIfRunning();
  }

  void syncWithSettings(SettingsProvider settings) {
    if (_settings == null || _lastProfileName != settings.activeProfileName) {
      _settings = settings;
      _lastProfileName = settings.activeProfileName;
      _config = settings.getActiveConfig().copyWith();
      notifyListeners();
      _restartIfRunning();
    } else {
      _settings = settings;
    }
  }

  void revertConfig(ScrcpyConfig snapshot) {
    _config = snapshot;
    notifyListeners();
  }

  void resetConfig() {
    _config = ScrcpyConfig();
    notifyListeners();
    _restartIfRunning();
  }

  void resetSingleConfigKey(String configKey) {
    _config.resetSingleConfig(configKey);
    notifyListeners();
    _restartIfRunning();
  }

  Completer<void>? _restartCompleter;
  bool _restartPending = false;

  Future<void> _restartIfRunning() async {
    if (!_isRunning && _service.isRunning == false) return;
    if (_selectedDevice == null) return;

    if (_restartCompleter != null && !_restartCompleter!.isCompleted) {
      _restartPending = true;

      await _restartCompleter!.future;
      return;
    }

    _restartCompleter = Completer<void>();
    try {
      do {
        _restartPending = false;
        final device = _selectedDevice;
        if (device == null) break;

        await _service.stop();

        if (!_devices.any((d) => d.serial == device.serial)) break;

        if (_selectedDevice?.serial != device.serial) break;

        final success = await _service.start(device.serial, _config);
        if (!success) {
          _logs.add('[ERR] Failed to restart scrcpy during config update.');
          if (_logs.length > 1000) _logs.removeRange(0, _logs.length - 1000);
          notifyListeners();
        }
      } while (_restartPending);
    } finally {
      _restartCompleter!.complete();
      _restartCompleter = null;
    }
  }

  void setNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    _service.clearLogs();
    notifyListeners();
  }

  Future<List<String>> listApps() async {
    if (_selectedDevice == null) return [];
    return await _service.listApps(_selectedDevice!.serial);
  }

  Future<void> fetchAndCacheApps() async {
    if (_selectedDevice == null) return;
    _isFetchingApps = true;
    notifyListeners();
    try {
      final apps = await _service.listApps(_selectedDevice!.serial);
      _cachedApps = apps;
      _isAppsFetched = true;
    } catch (_) {
    } finally {
      _isFetchingApps = false;
      notifyListeners();
    }
  }

  void _clearCachedApps() {
    _cachedApps = [];
    _isAppsFetched = false;
  }

  Future<List<String>> listDisplays() async {
    if (_selectedDevice == null) return [];
    return await _service.listDisplays(_selectedDevice!.serial);
  }

  Future<List<String>> listCameras() async {
    if (_selectedDevice == null) return [];
    return await _service.listCameras(_selectedDevice!.serial);
  }

  bool _isInstallingApk = false;
  bool get isInstallingApk => _isInstallingApk;

  Future<bool> installApk(String apkPath) async {
    if (_selectedDevice == null) return false;
    _isInstallingApk = true;
    notifyListeners();
    final result = await _service.installApk(_selectedDevice!.serial, apkPath);
    if (result) {
      _clearCachedApps();
    }
    _isInstallingApk = false;
    notifyListeners();
    return result;
  }

  String buildCommandPreview() {
    if (_selectedDevice == null) return 'scrcpy (no device selected)';
    final args = ['-s', _selectedDevice!.serial, ..._config.buildArgs()];
    return 'scrcpy ${args.join(' ')}';
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    _service.dispose();
    super.dispose();
  }
}
