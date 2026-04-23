import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'core/app_theme.dart';
import 'providers/scrcpy_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    size: Size(1280, 735),
    minimumSize: Size(900, 600),
    center: false,
    title: 'Super Scrcpy',
    backgroundColor: Color(0xFF0F0F1A),
    titleBarStyle: TitleBarStyle.hidden,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const SuperScrcpyApp());
}

class SuperScrcpyApp extends StatelessWidget {
  const SuperScrcpyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProxyProvider<SettingsProvider, ScrcpyProvider>(
          create: (_) => ScrcpyProvider(),
          update: (_, settings, scrcpy) {
            scrcpy!.syncWithSettings(settings);
            return scrcpy;
          },
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return DynamicColorBuilder(
            builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
              ColorScheme? systemScheme;
              if (settings.useDynamicColor && darkDynamic != null) {
                systemScheme = darkDynamic.copyWith(
                  surface: const Color(0xFF1A1A2E),
                  onSurface: const Color(0xFFF0F0F5),
                  error: const Color(0xFFFF6B6B),
                  onError: Colors.white,
                );
              }

              return MaterialApp(
                title: 'Super Scrcpy',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.darkTheme(
                  accent: settings.accentColor,
                  systemScheme: systemScheme,
                ),
                home: const _AppShell(),
              );
            },
          );
        },
      ),
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: Column(
        children: [
          const _TitleBar(),

          const Expanded(child: HomeScreen()),
        ],
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onPanStart: (_) => windowManager.startDragging(),
      child: Container(
        height: 36,
        color: const Color(0xFF0F0F1A),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.screen_share_rounded, size: 16, color: primary),
            const SizedBox(width: 8),
            const Text(
              'Super Scrcpy',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB0B0C8),
              ),
            ),
            const Spacer(),

            _WindowButton(
              icon: Icons.remove_rounded,
              onTap: () => windowManager.minimize(),
            ),
            _WindowButton(
              icon: Icons.crop_square_rounded,
              onTap: () async {
                if (await windowManager.isMaximized()) {
                  windowManager.unmaximize();
                } else {
                  windowManager.maximize();
                }
              },
            ),
            _WindowButton(
              icon: Icons.close_rounded,
              onTap: () async {
                final provider = context.read<ScrcpyProvider>();
                await provider.stopMirror();
                await windowManager.close();
              },
              isClose: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isClose;

  const _WindowButton({
    required this.icon,
    required this.onTap,
    this.isClose = false,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 46,
          height: 36,
          alignment: Alignment.center,
          color: _hovered
              ? (widget.isClose
                    ? const Color(0xFFE81123)
                    : const Color(0xFF2D2D50))
              : Colors.transparent,
          child: Icon(
            widget.icon,
            size: 16,
            color: _hovered && widget.isClose
                ? Colors.white
                : const Color(0xFFB0B0C8),
          ),
        ),
      ),
    );
  }
}
