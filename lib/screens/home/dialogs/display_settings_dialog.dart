import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimens.dart';
import '../../../providers/scrcpy_provider.dart';
import '../../../widgets/labeled_text_field.dart';
import '../../../widgets/toggle_option.dart';
import 'config_dialog_helper.dart';

const List<Map<String, String>> _displaySizePresets = [
  {'label': 'Default', 'value': ''},
  {'label': '800x600 (SVGA)', 'value': '800x600'},
  {'label': '1024x768 (XGA)', 'value': '1024x768'},
  {'label': '1280x720 (720p)', 'value': '1280x720'},
  {'label': '1280x1024 (SXGA)', 'value': '1280x1024'},
  {'label': '1366x768 (WXGA)', 'value': '1366x768'},
  {'label': '1600x900 (HD+)', 'value': '1600x900'},
  {'label': '1920x1080 (FHD)', 'value': '1920x1080'},
  {'label': '2560x1440 (QHD) ⭐', 'value': '2560x1440'},
  {'label': '2560x1600 (WQXGA)', 'value': '2560x1600'},
  {'label': '3840x2160 (4K)', 'value': '3840x2160'},
];

const List<Map<String, String>> _dpiPresets = [
  {'label': 'Auto', 'value': ''},
  {'label': '120 (ldpi)', 'value': '120'},
  {'label': '160 (mdpi)', 'value': '160'},
  {'label': '213 (tvdpi)', 'value': '213'},
  {'label': '240 (hdpi) ⭐', 'value': '240'},
  {'label': '280', 'value': '280'},
  {'label': '320 (xhdpi)', 'value': '320'},
  {'label': '360', 'value': '360'},
  {'label': '420 (Pixel)', 'value': '420'},
  {'label': '480 (xxhdpi)', 'value': '480'},
  {'label': '640 (xxxhdpi)', 'value': '640'},
];

String _parseResolution(String? displaySize) {
  if (displaySize == null || displaySize.isEmpty) return '';
  final slashIndex = displaySize.indexOf('/');
  if (slashIndex != -1) return displaySize.substring(0, slashIndex);
  return displaySize;
}

String _parseDpi(String? displaySize) {
  if (displaySize == null || displaySize.isEmpty) return '';
  final slashIndex = displaySize.indexOf('/');
  if (slashIndex != -1 && slashIndex < displaySize.length - 1) {
    return displaySize.substring(slashIndex + 1);
  }
  return '';
}

String? _combineDisplaySize(String resolution, String dpi) {
  if (resolution.isEmpty && dpi.isEmpty) return null;
  if (resolution.isEmpty) return null;
  if (dpi.isEmpty) return resolution;
  return '$resolution/$dpi';
}

void showDisplayDialog(BuildContext context, ScrcpyProvider provider) {
  final originalConfig = provider.config.copyWith();

  showConfigDialog(
    context: context,
    title: 'Display & Virtual Display',
    icon: Icons.desktop_windows_rounded,
    builder: (ctx) => _DisplayDialogContent(provider: provider),
    onDone: () {
      provider.commitConfig();
    },
    onCancel: () {
      provider.revertConfig(originalConfig);
    },
  );
}

class _DisplayDialogContent extends StatefulWidget {
  final ScrcpyProvider provider;

  const _DisplayDialogContent({required this.provider});

  @override
  State<_DisplayDialogContent> createState() => _DisplayDialogContentState();
}

class _DisplayDialogContentState extends State<_DisplayDialogContent> {
  List<String> _filteredApps = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  ScrcpyProvider get provider => widget.provider;

  @override
  void initState() {
    super.initState();

    if (provider.cachedApps.isNotEmpty) {
      _filteredApps = provider.cachedApps;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchApps() async {
    setState(() {});
    try {
      await provider.fetchAndCacheApps();
      setState(() {
        _filteredApps = provider.cachedApps;
        _searchQuery = '';
        _searchController.clear();
      });
    } catch (_) {
      setState(() {});
    }
  }

  void _filterApps(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredApps = provider.cachedApps;
      } else {
        _filteredApps = provider.cachedApps
            .where((app) => app.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  String _extractPackageName(String appEntry) {
    final stripped = appEntry.replaceFirst(RegExp(r'^\s*-\s*'), '').trim();

    final parts = stripped.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return parts.last;
    }
    return stripped;
  }

  String _extractAppName(String appEntry) {
    final stripped = appEntry.replaceFirst(RegExp(r'^\s*-\s*'), '').trim();

    final parts = stripped.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return parts.sublist(0, parts.length - 1).join(' ');
    }
    return stripped;
  }

  @override
  Widget build(BuildContext context) {
    final config = provider.config;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ToggleOption(
          label: 'Use Virtual Display',
          description: 'Create a new virtual display (scrcpy 3.0+)',
          value: config.useNewDisplay,
          icon: Icons.desktop_windows_rounded,
          onChanged: (v) {
            provider.updateConfigSilent((c) {
              c.useNewDisplay = v;
              return c;
            });
            setState(() {});
          },
        ),
        if (config.useNewDisplay) ...[
          const SizedBox(height: AppDimens.lg),
          _buildDisplaySizeDropdown(config),
        ],
        const SizedBox(height: AppDimens.lg),
        LabeledTextField(
          label: 'Display ID',
          hint: '0 (default)',
          icon: Icons.looks_one_rounded,
          value: config.displayId?.toString() ?? '',
          keyboardType: TextInputType.number,
          onChanged: (v) => provider.updateConfigSilent((c) {
            c.displayId = v.isEmpty ? null : int.tryParse(v);
            return c;
          }),
        ),
        const SizedBox(height: AppDimens.lg),
        _buildStartAppSection(config),
      ],
    );
  }

  Widget _buildDisplaySizeDropdown(dynamic config) {
    final currentDisplaySize = config.newDisplaySize ?? '';
    final currentResolution = _parseResolution(currentDisplaySize);
    final currentDpi = _parseDpi(currentDisplaySize);

    final isPresetResolution = _displaySizePresets.any(
      (p) => p['value'] == currentResolution,
    );
    final isCustomResolution =
        currentResolution.isNotEmpty && !isPresetResolution;

    final isPresetDpi = _dpiPresets.any((p) => p['value'] == currentDpi);
    final isCustomDpi = currentDpi.isNotEmpty && !isPresetDpi;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.aspect_ratio_rounded,
              size: AppDimens.iconSm,
              color: AppColors.textHint,
            ),
            const SizedBox(width: AppDimens.sm),
            const Text(
              'Display Size',
              style: TextStyle(
                fontSize: AppDimens.fontSm,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.density_medium_rounded,
              size: AppDimens.iconSm,
              color: AppColors.textHint,
            ),
            const SizedBox(width: AppDimens.xs),
            const Text(
              'DPI',
              style: TextStyle(
                fontSize: AppDimens.fontSm,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.sm),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: AppDimens.inputHeight,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.sm),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: isCustomResolution
                        ? '__custom__'
                        : currentResolution,
                    isExpanded: true,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(
                      fontSize: AppDimens.fontMd,
                      color: AppColors.textPrimary,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textHint,
                      size: 18,
                    ),
                    items: [
                      ..._displaySizePresets.map(
                        (preset) => DropdownMenuItem<String>(
                          value: preset['value'],
                          child: Text(
                            preset['label']!,
                            style: const TextStyle(
                              fontSize: AppDimens.fontSm,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: '__custom__',
                        child: Text(
                          isCustomResolution
                              ? 'Custom ($currentResolution)'
                              : 'Custom...',
                          style: TextStyle(
                            fontSize: AppDimens.fontSm,
                            color: Theme.of(context).colorScheme.primary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == '__custom__') {
                        _showCustomResolutionDialog(
                          context,
                          currentResolution,
                          currentDpi,
                        );
                      } else {
                        final resolution = value ?? '';
                        provider.updateConfigSilent((c) {
                          c.newDisplaySize = _combineDisplaySize(
                            resolution,
                            currentDpi,
                          );
                          return c;
                        });
                        setState(() {});
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimens.sm),

            Expanded(
              flex: 2,
              child: Container(
                height: AppDimens.inputHeight,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.sm),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: isCustomDpi ? '__custom_dpi__' : currentDpi,
                    isExpanded: true,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(
                      fontSize: AppDimens.fontMd,
                      color: AppColors.textPrimary,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textHint,
                      size: 18,
                    ),
                    items: [
                      ..._dpiPresets.map(
                        (preset) => DropdownMenuItem<String>(
                          value: preset['value'],
                          child: Text(
                            preset['label']!,
                            style: const TextStyle(
                              fontSize: AppDimens.fontSm,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: '__custom_dpi__',
                        child: Text(
                          isCustomDpi ? 'Custom ($currentDpi)' : 'Custom...',
                          style: TextStyle(
                            fontSize: AppDimens.fontSm,
                            color: Theme.of(context).colorScheme.primary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == '__custom_dpi__') {
                        _showCustomDpiDialog(
                          context,
                          currentResolution,
                          currentDpi,
                        );
                      } else {
                        final dpi = value ?? '';
                        provider.updateConfigSilent((c) {
                          c.newDisplaySize = _combineDisplaySize(
                            currentResolution,
                            dpi,
                          );
                          return c;
                        });
                        setState(() {});
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showCustomResolutionDialog(
    BuildContext context,
    String currentResolution,
    String currentDpi,
  ) {
    final controller = TextEditingController(text: currentResolution);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Custom Resolution',
          style: TextStyle(
            fontSize: AppDimens.fontLg,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(
            fontSize: AppDimens.fontMd,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'e.g. 1920x1080',
            hintStyle: const TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              final val = controller.text.trim();
              if (val.isNotEmpty && !RegExp(r'^\d+x\d+$').hasMatch(val)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Invalid resolution format. Use WxH (e.g. 1920x1080)',
                    ),
                  ),
                );
                return;
              }
              provider.updateConfigSilent((c) {
                c.newDisplaySize = _combineDisplaySize(val, currentDpi);
                return c;
              });
              setState(() {});
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Apply',
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomDpiDialog(
    BuildContext context,
    String currentResolution,
    String currentDpi,
  ) {
    final controller = TextEditingController(text: currentDpi);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Custom DPI',
          style: TextStyle(
            fontSize: AppDimens.fontLg,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: AppDimens.fontMd,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'e.g. 420',
            hintStyle: const TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.surfaceLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              final val = controller.text.trim();
              provider.updateConfigSilent((c) {
                c.newDisplaySize = _combineDisplaySize(currentResolution, val);
                return c;
              });
              setState(() {});
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Apply',
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartAppSection(dynamic config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.launch_rounded,
              size: AppDimens.iconSm,
              color: AppColors.textHint,
            ),
            const SizedBox(width: AppDimens.sm),
            const Text(
              'Start App',
              style: TextStyle(
                fontSize: AppDimens.fontSm,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),

            _buildFetchButton(),
          ],
        ),
        const SizedBox(height: AppDimens.sm),

        if (config.startApp != null && config.startApp!.isNotEmpty) ...[
          _buildSelectedAppChip(config.startApp!),
          const SizedBox(height: AppDimens.sm),
        ],

        if (provider.isAppsFetched && provider.cachedApps.isNotEmpty)
          _buildAppSelector(config)
        else
          _buildManualInput(config),
      ],
    );
  }

  Widget _buildFetchButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: provider.isFetchingApps ? null : _fetchApps,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md,
            vertical: AppDimens.xs,
          ),
          decoration: BoxDecoration(
            gradient: provider.isFetchingApps
                ? null
                : LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
            color: provider.isFetchingApps ? AppColors.surfaceHighlight : null,
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (provider.isFetchingApps)
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.textSecondary,
                  ),
                )
              else
                const Icon(
                  Icons.download_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              const SizedBox(width: AppDimens.xs),
              Text(
                provider.isFetchingApps
                    ? 'Fetching...'
                    : provider.isAppsFetched
                    ? 'Refresh'
                    : 'Fetch from Device',
                style: TextStyle(
                  fontSize: AppDimens.fontXs,
                  fontWeight: FontWeight.w600,
                  color: provider.isFetchingApps
                      ? AppColors.textSecondary
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedAppChip(String startApp) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.md,
        vertical: AppDimens.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: AppDimens.iconSm,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppDimens.sm),
          Expanded(
            child: Text(
              startApp,
              style: const TextStyle(
                fontSize: AppDimens.fontSm,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () {
              provider.updateConfigSilent((c) {
                c.startApp = null;
                return c;
              });
              setState(() {});
            },
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(
                Icons.close_rounded,
                size: 14,
                color: AppColors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSelector(dynamic config) {
    return Column(
      children: [
        Container(
          height: AppDimens.inputHeight,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: AppDimens.md),
                child: Icon(
                  Icons.search_rounded,
                  size: AppDimens.iconSm,
                  color: AppColors.textHint,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: _filterApps,
                  style: const TextStyle(
                    fontSize: AppDimens.fontMd,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search apps...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppDimens.sm,
                    ),
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty)
                InkWell(
                  onTap: () {
                    _searchController.clear();
                    _filterApps('');
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(AppDimens.sm),
                    child: Icon(
                      Icons.clear_rounded,
                      size: 14,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.sm),

        Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.xs),
          child: Row(
            children: [
              Text(
                '${_filteredApps.length} app${_filteredApps.length != 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: AppDimens.fontXs,
                  color: AppColors.textHint,
                ),
              ),
              const Spacer(),
              const Text(
                'Tap to select',
                style: TextStyle(
                  fontSize: AppDimens.fontXs,
                  color: AppColors.textHint,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),

        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: _filteredApps.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(AppDimens.lg),
                  child: Center(
                    child: Text(
                      'No apps match your search',
                      style: TextStyle(
                        fontSize: AppDimens.fontSm,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredApps.length,
                  itemBuilder: (context, index) {
                    final appEntry = _filteredApps[index];
                    final packageName = _extractPackageName(appEntry);
                    final appName = _extractAppName(appEntry);
                    final isSelected = config.startApp == packageName;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          provider.updateConfigSilent((c) {
                            c.startApp = packageName;
                            return c;
                          });
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.md,
                            vertical: AppDimens.sm,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1)
                                : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: index < _filteredApps.length - 1
                                    ? AppColors.border.withValues(alpha: 0.5)
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                            .withValues(alpha: 0.2)
                                      : AppColors.surfaceHighlight,
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.radiusSm,
                                  ),
                                ),
                                child: Icon(
                                  isSelected
                                      ? Icons.check_rounded
                                      : Icons.android_rounded,
                                  size: 14,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : AppColors.textHint,
                                ),
                              ),
                              const SizedBox(width: AppDimens.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appName,
                                      style: TextStyle(
                                        fontSize: AppDimens.fontSm,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : AppColors.textPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (packageName != appName)
                                      Text(
                                        packageName,
                                        style: const TextStyle(
                                          fontSize: AppDimens.fontXs,
                                          color: AppColors.textHint,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: AppDimens.sm),

        Row(
          children: [
            Expanded(child: Container(height: 1, color: AppColors.border)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.sm),
              child: Text(
                'or enter manually',
                style: TextStyle(
                  fontSize: AppDimens.fontXs,
                  color: AppColors.textHint,
                ),
              ),
            ),
            Expanded(child: Container(height: 1, color: AppColors.border)),
          ],
        ),
        const SizedBox(height: AppDimens.sm),
        _buildManualInput(config),
      ],
    );
  }

  Widget _buildManualInput(dynamic config) {
    return LabeledTextField(
      label: provider.isAppsFetched ? '' : 'Package Name',
      hint: 'com.example.app',
      icon: provider.isAppsFetched ? null : null,
      value: config.startApp ?? '',
      onChanged: (v) => provider.updateConfigSilent((c) {
        c.startApp = v.isEmpty ? null : v;
        return c;
      }),
    );
  }
}
