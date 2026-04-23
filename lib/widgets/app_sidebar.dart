import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../core/app_dimens.dart';
import '../models/adb_device.dart';
import '../providers/scrcpy_provider.dart';

class AppSidebar extends StatefulWidget {
  const AppSidebar({super.key});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final provider = context.watch<ScrcpyProvider>();
    final width = _isCollapsed
        ? AppDimens.sidebarCollapsedWidth
        : AppDimens.sidebarWidth;

    return AnimatedContainer(
      duration: const Duration(milliseconds: AppDimens.animMedium),
      curve: Curves.easeInOut,
      width: width,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        children: [
          _buildHeader(primary),
          const Divider(color: AppColors.border, height: 1),

          if (!_isCollapsed)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.sm),
                child: Column(
                  children: [
                    _SidebarDevicesPanel(provider: provider),
                    const SizedBox(height: AppDimens.sm),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: AppDimens.sm),
                    const _SidebarApkDrop(),
                  ],
                ),
              ),
            )
          else
            const Spacer(),

          if (provider.isRunning) _buildRunningIndicator(),

          if (!_isCollapsed) _buildFooterLinks(primary),

          const Divider(color: AppColors.border, height: 1),
          _buildCollapseButton(),
        ],
      ),
    );
  }

  Widget _buildHeader(Color primary) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _isCollapsed ? AppDimens.md : AppDimens.md,
        vertical: AppDimens.md,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primary, primary]),
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            ),
            child: const Icon(
              Icons.screen_share_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          if (!_isCollapsed) ...[
            const SizedBox(width: AppDimens.sm),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Super Scrcpy',
                    style: TextStyle(
                      fontSize: AppDimens.fontMd,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'v1.0.0',
                    style: TextStyle(fontSize: 11, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRunningIndicator() {
    return Container(
      margin: const EdgeInsets.all(AppDimens.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.sm,
        vertical: AppDimens.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          if (!_isCollapsed) ...[
            const SizedBox(width: AppDimens.xs),
            const Text(
              'Mirroring Active',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.success,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooterLinks(Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.md,
        vertical: AppDimens.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.xs),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(Icons.favorite_rounded, size: 14, color: primary),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: GestureDetector(
                    onTap: () => launchUrl(
                      Uri.parse('https://github.com/Genymobile/scrcpy'),
                    ),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text.rich(
                        TextSpan(
                          text: 'Powered by ',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                          ),
                          children: [
                            TextSpan(
                              text: 'scrcpy',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: primary,
                              ),
                            ),
                            TextSpan(text: ' by Genymobile'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(AppDimens.xs),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(Icons.public_rounded, size: 14, color: primary),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        launchUrl(Uri.parse('https://superscrcpy.netlify.app')),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text.rich(
                        TextSpan(
                          text: 'Visit ',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                          ),
                          children: [
                            TextSpan(
                              text: 'super_scrcpy website',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  Widget _buildCollapseButton() {
    return InkWell(
      onTap: () => setState(() => _isCollapsed = !_isCollapsed),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.sm),
        child: Row(
          mainAxisAlignment: _isCollapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Icon(
              _isCollapsed
                  ? Icons.chevron_right_rounded
                  : Icons.chevron_left_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
            if (!_isCollapsed) ...[
              const SizedBox(width: AppDimens.xs),
              const Text(
                'Collapse',
                style: TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SidebarDevicesPanel extends StatefulWidget {
  final ScrcpyProvider provider;

  const _SidebarDevicesPanel({required this.provider});

  @override
  State<_SidebarDevicesPanel> createState() => _SidebarDevicesPanelState();
}

enum _WirelessConnectMode { manual, qr }

class _SidebarDevicesPanelState extends State<_SidebarDevicesPanel> {
  final _ipController = TextEditingController();
  final _portController = TextEditingController(text: '5555');
  bool _showConnect = false;
  bool _isConnecting = false;
  bool _isQrConnecting = false;
  _WirelessConnectMode _connectMode = _WirelessConnectMode.manual;
  String? _qrPayload;
  String? _qrPairingCode;

  static const String _qrServiceName = 'super-scrcpy';

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final provider = widget.provider;
    final devices = provider.devices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.xs),
          child: Row(
            children: [
              Icon(Icons.devices_rounded, size: 18, color: primary),
              const SizedBox(width: 6),
              Text(
                'Devices',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primary,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),

              _CompactIconBtn(
                icon: Icons.refresh_rounded,
                tooltip: 'Refresh',
                isLoading: provider.isScanning,
                onTap: () => provider.refreshDevices(),
              ),
              const SizedBox(width: 4),

              _CompactIconBtn(
                icon: _showConnect ? Icons.close_rounded : Icons.add_rounded,
                tooltip: _showConnect ? 'Cancel' : 'Wi-Fi Connect',
                onTap: () => setState(() => _showConnect = !_showConnect),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.sm),

        if (devices.isEmpty && !provider.isScanning)
          _buildEmptyDevice()
        else if (devices.isEmpty && provider.isScanning)
          _buildScanning()
        else
          ...devices.map((d) => _buildDeviceTile(d, provider)),

        if (_showConnect) ...[
          const SizedBox(height: AppDimens.sm),
          _buildConnectRow(provider),
        ],
      ],
    );
  }

  Widget _buildEmptyDevice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.lg,
        horizontal: AppDimens.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: const Column(
        children: [
          Icon(Icons.usb_off_rounded, size: 28, color: AppColors.textHint),
          SizedBox(height: 6),
          Text(
            'No devices connected',
            style: TextStyle(fontSize: 13, color: AppColors.textHint),
          ),
          SizedBox(height: 2),
          Text(
            'Connect via USB or Wi-Fi',
            style: TextStyle(fontSize: 11, color: AppColors.textDisabled),
          ),
        ],
      ),
    );
  }

  Widget _buildScanning() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.lg,
        horizontal: AppDimens.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text(
            'Scanning...',
            style: TextStyle(fontSize: 13, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceTile(AdbDevice device, ScrcpyProvider provider) {
    final primary = Theme.of(context).colorScheme.primary;
    final isSelected = provider.selectedDevice?.serial == device.serial;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: () => provider.selectDevice(device),
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: AppDimens.animFast),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.sm,
            vertical: AppDimens.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: isSelected
                ? Border.all(color: primary.withValues(alpha: 0.3))
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color:
                      (device.isWifi
                              ? AppColors.deviceWifi
                              : AppColors.deviceUsb)
                          .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                ),
                child: Icon(
                  device.isWifi ? Icons.wifi_rounded : Icons.usb_rounded,
                  size: 18,
                  color: device.isWifi
                      ? AppColors.deviceWifi
                      : AppColors.deviceUsb,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.displayName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isSelected ? primary : AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      device.serial,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: device.isOnline
                      ? AppColors.success
                      : device.isUnauthorized
                      ? AppColors.warning
                      : AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectRow(ScrcpyProvider provider) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConnectModeToggle(provider),
          const SizedBox(height: AppDimens.sm),
          if (_connectMode == _WirelessConnectMode.qr)
            _buildQrConnectCard(provider)
          else
            _buildManualConnectCard(provider),
        ],
      ),
    );
  }

  Widget _buildConnectModeToggle(ScrcpyProvider provider) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ConnectModeButton(
              label: 'Manual',
              icon: Icons.wifi_rounded,
              isSelected: _connectMode == _WirelessConnectMode.manual,
              onTap: () {
                _switchConnectMode(provider, _WirelessConnectMode.manual);
              },
            ),
          ),
          Expanded(
            child: _ConnectModeButton(
              label: 'QR',
              icon: Icons.qr_code_rounded,
              isSelected: _connectMode == _WirelessConnectMode.qr,
              onTap: () {
                _switchConnectMode(provider, _WirelessConnectMode.qr);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualConnectCard(ScrcpyProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 32,
                child: TextField(
                  controller: _ipController,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'IP address',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.textHint,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 32,
                child: TextField(
                  controller: _portController,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Port',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.textHint,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          height: 30,
          child: ElevatedButton(
            onPressed: _isConnecting
                ? null
                : () async {
                    final ip = _ipController.text.trim();
                    if (ip.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter an IP address'),
                        ),
                      );
                      return;
                    }

                    if (!_isValidIpv4(ip)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid IPv4 address format'),
                        ),
                      );
                      return;
                    }

                    int? port = int.tryParse(_portController.text.trim());
                    if (port == null || port <= 0 || port > 65535) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid port number')),
                      );
                      return;
                    }

                    setState(() => _isConnecting = true);

                    bool success = false;
                    try {
                      success = await provider.connectWifi(ip, port: port);
                    } finally {
                      if (mounted) {
                        setState(() => _isConnecting = false);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Connected to Wi-Fi successfully'),
                            ),
                          );
                          setState(() => _showConnect = false);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to connect to Wi-Fi'),
                            ),
                          );
                        }
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(fontSize: 13),
            ),
            child: _isConnecting
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Connect'),
          ),
        ),
      ],
    );
  }

  Widget _buildQrConnectCard(ScrcpyProvider provider) {
    final hasQr = _qrPayload != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Scan this QR from Developer Options > Wireless debugging > Pair device with QR code.',
          style: TextStyle(fontSize: 11, color: AppColors.textHint),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.sm),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            border: Border.all(color: AppColors.border),
          ),
          child: hasQr
              ? Column(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: PrettyQrView.data(
                        data: _qrPayload!,
                        decoration: const PrettyQrDecoration(
                          shape: PrettyQrSquaresSymbol(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pairing code: $_qrPairingCode',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text(
                      'Generate a QR code to begin',
                      style: TextStyle(fontSize: 12, color: AppColors.textHint),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        if (_isQrConnecting)
          const Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 8),
              Text(
                'Waiting for scan and pairing...',
                style: TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
            ],
          )
        else if (hasQr)
          const Text(
            'Switch away and back to QR to regenerate a new code.',
            style: TextStyle(fontSize: 11, color: AppColors.textDisabled),
          ),
      ],
    );
  }

  void _switchConnectMode(ScrcpyProvider provider, _WirelessConnectMode mode) {
    final wasMode = _connectMode;
    if (wasMode == mode) return;

    setState(() => _connectMode = mode);

    if (mode == _WirelessConnectMode.qr && !_isQrConnecting) {
      _startQrPairingFlow(provider);
    }
  }

  Future<void> _startQrPairingFlow(ScrcpyProvider provider) async {
    final pairingCode = _generatePairingCode();
    final payload = provider.buildWirelessDebugQrPayload(
      pairingCode: pairingCode,
      serviceName: _qrServiceName,
    );

    setState(() {
      _qrPairingCode = pairingCode;
      _qrPayload = payload;
      _isQrConnecting = true;
    });

    bool success = false;
    try {
      success = await provider.connectWithQrCode(
        pairingCode: pairingCode,
        serviceName: _qrServiceName,
      );
    } finally {
      if (mounted) {
        setState(() => _isQrConnecting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Paired and connected via QR successfully'
                  : 'QR pairing/connect timed out or failed',
            ),
          ),
        );
        if (success) {
          setState(() => _showConnect = false);
        }
      }
    }
  }

  String _generatePairingCode() {
    final value = Random.secure().nextInt(900000) + 100000;
    return value.toString();
  }

  bool _isValidIpv4(String ip) {
    final match = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$').firstMatch(ip);
    if (match == null) return false;
    return ip.split('.').every((octet) {
      final value = int.tryParse(octet);
      return value != null && value >= 0 && value <= 255;
    });
  }
}

class _SidebarApkDrop extends StatefulWidget {
  const _SidebarApkDrop();

  @override
  State<_SidebarApkDrop> createState() => _SidebarApkDropState();
}

class _SidebarApkDropState extends State<_SidebarApkDrop> {
  bool _isDragging = false;
  String? _lastResult;
  String? _lastApkName;

  Future<void> _installApk(String path) async {
    final provider = context.read<ScrcpyProvider>();
    if (provider.selectedDevice == null) {
      setState(() {
        _lastResult = 'error';
        _lastApkName = 'No device selected';
      });
      return;
    }
    final name = path.split(RegExp(r'[/\\]')).last;
    setState(() {
      _lastApkName = name;
      _lastResult = null;
    });
    final ok = await provider.installApk(path);
    if (mounted) setState(() => _lastResult = ok ? 'success' : 'error');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScrcpyProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.xs),
          child: Row(
            children: [
              const Icon(
                Icons.android_rounded,
                size: 18,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              const Text(
                'Install APK',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              _CompactIconBtn(
                icon: Icons.folder_open_rounded,
                tooltip: 'Browse APK',
                onTap: provider.isInstallingApk
                    ? null
                    : () async {
                        final result = await FilePicker.pickFiles(
                          dialogTitle: 'Select APK',
                          type: FileType.custom,
                          allowedExtensions: ['apk'],
                        );
                        if (result != null &&
                            result.files.single.path != null) {
                          _installApk(result.files.single.path!);
                        }
                      },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.sm),

        DropTarget(
          onDragEntered: (_) => setState(() => _isDragging = true),
          onDragExited: (_) => setState(() => _isDragging = false),
          onDragDone: (details) {
            setState(() => _isDragging = false);
            if (details.files.isNotEmpty) {
              final file = details.files.first;
              if (file.path.toLowerCase().endsWith('.apk')) {
                _installApk(file.path);
              } else {
                setState(() {
                  _lastResult = 'error';
                  _lastApkName = 'Not an APK file';
                });
              }
            }
          },
          child: GestureDetector(
            onTap: _lastResult != null
                ? () => setState(() {
                    _lastResult = null;
                    _lastApkName = null;
                  })
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: AppDimens.animFast),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 80),
              padding: const EdgeInsets.symmetric(
                vertical: AppDimens.xl,
                horizontal: AppDimens.md,
              ),
              decoration: BoxDecoration(
                color: _isDragging
                    ? AppColors.success.withValues(alpha: 0.08)
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                border: Border.all(
                  color: _isDragging
                      ? AppColors.success.withValues(alpha: 0.5)
                      : AppColors.border,
                  width: _isDragging ? 2 : 1,
                ),
              ),
              child: provider.isInstallingApk
                  ? _installingWidget()
                  : _lastResult != null
                  ? _resultWidget()
                  : _dropWidget(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropWidget() {
    return Column(
      children: [
        Icon(
          _isDragging ? Icons.file_download_rounded : Icons.upload_file_rounded,
          size: 32,
          color: _isDragging ? AppColors.success : AppColors.textHint,
        ),
        const SizedBox(height: 6),
        Text(
          _isDragging ? 'Drop here' : 'Drag APK here',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _isDragging ? AppColors.success : AppColors.textHint,
          ),
        ),
        if (!_isDragging)
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text(
              'or browse to select',
              style: TextStyle(fontSize: 11, color: AppColors.textDisabled),
            ),
          ),
      ],
    );
  }

  Widget _installingWidget() {
    return Column(
      children: [
        const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
        const SizedBox(height: 6),
        Text(
          'Installing...',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        if (_lastApkName != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              _lastApkName!,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textHint,
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _resultWidget() {
    final ok = _lastResult == 'success';
    return Column(
      children: [
        Icon(
          ok ? Icons.check_circle_rounded : Icons.error_rounded,
          size: 28,
          color: ok ? AppColors.success : AppColors.error,
        ),
        const SizedBox(height: 4),
        Text(
          ok ? 'Installed!' : 'Failed',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ok ? AppColors.success : AppColors.error,
          ),
        ),
        if (_lastApkName != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              _lastApkName!,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textHint,
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            'Tap to dismiss',
            style: TextStyle(fontSize: 11, color: AppColors.textDisabled),
          ),
        ),
      ],
    );
  }
}

class _CompactIconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool isLoading;

  const _CompactIconBtn({
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: isLoading
              ? SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: primary,
                  ),
                )
              : Icon(icon, size: 17, color: AppColors.textHint),
        ),
      ),
    );
  }
}

class _ConnectModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ConnectModeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? primary : AppColors.textHint,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? primary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
