import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../providers/scrcpy_provider.dart';
import '../../widgets/app_sidebar.dart';
import '../mirror/mirror_screen.dart';
import 'unified_config_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          const AppSidebar(),

          Expanded(child: const _ConfigMirrorConsoleLayout()),
        ],
      ),
    );
  }
}

class _ConfigMirrorConsoleLayout extends StatelessWidget {
  const _ConfigMirrorConsoleLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(flex: 3, child: UnifiedConfigScreen()),

        Container(width: 1, color: AppColors.border),

        const Expanded(flex: 2, child: _MirrorAndConsole()),
      ],
    );
  }
}

class _MirrorAndConsole extends StatelessWidget {
  const _MirrorAndConsole();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MirrorScreen(),

        Container(height: 1, color: AppColors.border),

        const Expanded(child: _InlineConsole()),
      ],
    );
  }
}

class _InlineConsole extends StatefulWidget {
  const _InlineConsole();

  @override
  State<_InlineConsole> createState() => _InlineConsoleState();
}

class _InlineConsoleState extends State<_InlineConsole> {
  final ScrollController _scrollController = ScrollController();
  bool _autoScroll = true;
  int _lastLogCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_autoScroll && _scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 80),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final provider = context.watch<ScrcpyProvider>();
    final logs = provider.logs;

    if (logs.length != _lastLogCount) {
      _lastLogCount = logs.length;
      _scrollToBottom();
    }

    return Padding(
      padding: const EdgeInsets.all(AppDimens.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.terminal_rounded, size: 13, color: primary),
              const SizedBox(width: AppDimens.xs),
              Text(
                'Console',
                style: TextStyle(
                  fontSize: AppDimens.fontXs,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
              const Spacer(),

              InkWell(
                onTap: () => setState(() => _autoScroll = !_autoScroll),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    _autoScroll
                        ? Icons.vertical_align_bottom_rounded
                        : Icons.vertical_align_center_rounded,
                    size: 13,
                    color: _autoScroll ? primary : AppColors.textHint,
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.xs),
              InkWell(
                onTap: logs.isEmpty
                    ? null
                    : () {
                        Clipboard.setData(ClipboardData(text: logs.join('\n')));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'All logs copied to clipboard',
                              style: TextStyle(fontSize: 13),
                            ),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(
                    Icons.copy_all_rounded,
                    size: 13,
                    color: AppColors.textHint,
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.xs),
              InkWell(
                onTap: logs.isEmpty ? null : () => provider.clearLogs(),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(
                    Icons.delete_sweep_rounded,
                    size: 13,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.xs),

          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.sm),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D1A),
                borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                border: Border.all(color: AppColors.border),
              ),
              child: logs.isEmpty
                  ? const Center(
                      child: Text(
                        'No logs yet',
                        style: TextStyle(
                          fontSize: AppDimens.fontXs,
                          color: AppColors.textDisabled,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final line = logs[index];
                        final isError = line.contains('[ERR]');
                        final isCmd = line.contains('> ');

                        Color textColor = const Color(0xFFA8B2C8);
                        if (isError) textColor = AppColors.error;
                        if (isCmd) textColor = primary;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.5),
                          child: SelectableText(
                            line,
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'monospace',
                              height: 1.4,
                              color: textColor,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
