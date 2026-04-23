import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimens.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/scrcpy_provider.dart';

void showSuperScrcpySettingsDialog(BuildContext context) {
  showDialog(context: context, builder: (ctx) => const _SettingsDialog());
}

class _SettingsDialog extends StatefulWidget {
  const _SettingsDialog();

  @override
  State<_SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<_SettingsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        side: const BorderSide(color: AppColors.border),
      ),
      child: SizedBox(
        width: 620,
        height: 560,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.xl,
                AppDimens.xl,
                AppDimens.lg,
                0,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [primary, primary]),
                      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                    ),
                    child: const Icon(
                      Icons.settings_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: AppDimens.md),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Super Scrcpy Settings',
                          style: TextStyle(
                            fontSize: AppDimens.fontXl,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Manage configurations, check updates & more',
                          style: TextStyle(
                            fontSize: AppDimens.fontXs,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.textHint,
                    ),
                    splashRadius: 16,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.md),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppDimens.xl),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: LinearGradient(colors: [primary, primary]),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerHeight: 0,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textHint,
                labelStyle: const TextStyle(
                  fontSize: AppDimens.fontSm,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: AppDimens.fontSm,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.palette_rounded, size: 14),
                        SizedBox(width: 6),
                        Text('Appearance'),
                      ],
                    ),
                  ),
                  Tab(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_copy_rounded, size: 14),
                        SizedBox(width: 6),
                        Text('Profiles'),
                      ],
                    ),
                  ),
                  Tab(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.system_update_rounded, size: 14),
                        SizedBox(width: 6),
                        Text('Update'),
                      ],
                    ),
                  ),
                  Tab(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 14),
                        SizedBox(width: 6),
                        Text('About'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.md),
            const Divider(color: AppColors.border, height: 1),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _AppearanceTab(),
                  _ProfilesTab(),
                  _UpdateTab(),
                  _AboutTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppearanceTab extends StatelessWidget {
  const _AppearanceTab();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final primary = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimens.lg),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 18,
                    color: primary,
                  ),
                ),
                const SizedBox(width: AppDimens.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dynamic Color',
                        style: TextStyle(
                          fontSize: AppDimens.fontSm,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        settings.useDynamicColor
                            ? 'Using system accent colour'
                            : 'Using custom accent colour',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: settings.useDynamicColor,
                  onChanged: (v) => settings.setUseDynamicColor(v),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.xl),

          Row(
            children: [
              const Text(
                'Accent Colour',
                style: TextStyle(
                  fontSize: AppDimens.fontMd,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: AppDimens.sm),
              if (settings.useDynamicColor)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textHint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppDimens.radiusRound),
                  ),
                  child: const Text(
                    'OVERRIDE',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHint,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            settings.useDynamicColor
                ? 'Selecting a colour will disable dynamic colour'
                : 'Choose an accent colour for the app',
            style: const TextStyle(
              fontSize: AppDimens.fontXs,
              color: AppColors.textHint,
            ),
          ),

          const SizedBox(height: AppDimens.lg),

          Wrap(
            spacing: AppDimens.sm,
            runSpacing: AppDimens.sm,
            children: AppColors.accentPresets.map((preset) {
              final isSelected =
                  !settings.useDynamicColor &&
                  settings.accentColor.toARGB32() == preset.color.toARGB32();

              return Tooltip(
                message: preset.name,
                child: GestureDetector(
                  onTap: () => settings.setAccentColor(preset.color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: AppDimens.animFast),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: preset.color,
                      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.1),
                        width: isSelected ? 2.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: preset.color.withValues(alpha: 0.4),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 20,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppDimens.xl),

          const Text(
            'Note: Changes to the accent colour will take effect immediately across the app. If dynamic color is enabled, the accent will match your system theme and cannot be customized.',
            style: TextStyle(
              fontSize: AppDimens.fontXs,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilesTab extends StatelessWidget {
  const _ProfilesTab();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final profiles = settings.profiles;
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.xl,
            vertical: AppDimens.sm,
          ),
          child: Row(
            children: [
              Text(
                '${profiles.length} profile${profiles.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: AppDimens.fontXs,
                  color: AppColors.textHint,
                ),
              ),
              const Spacer(),
              _SmallButton(
                icon: Icons.add_rounded,
                label: 'New',
                onTap: () => _showNewProfileDialog(context, settings),
              ),
              const SizedBox(width: AppDimens.sm),
              _SmallButton(
                icon: Icons.file_upload_outlined,
                label: 'Import',
                onTap: () async {
                  final count = await settings.importProfiles();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          count > 0
                              ? 'Imported $count profile${count == 1 ? '' : 's'}'
                              : 'No profiles imported',
                        ),
                        backgroundColor: count > 0
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: AppDimens.sm),
              _SmallButton(
                icon: Icons.file_download_outlined,
                label: 'Export',
                onTap: () async {
                  try {
                    final path = await settings.exportProfiles();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            path != null
                                ? 'Exported to ${path.split(RegExp(r'[/\\]')).last}'
                                : 'Export cancelled',
                          ),
                          backgroundColor: path != null
                              ? AppColors.success
                              : AppColors.textHint,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Export failed: ${e.toString()}'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),

        const Divider(color: AppColors.border, height: 1),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppDimens.md),
            itemCount: profiles.length,
            itemBuilder: (ctx, i) {
              final profile = profiles[i];
              final isActive = profile.name == settings.activeProfileName;
              final entries = profile.config.getConfigEntries();

              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.sm),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: AppDimens.animFast),
                  decoration: BoxDecoration(
                    color: isActive
                        ? primary.withValues(alpha: 0.08)
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                    border: Border.all(
                      color: isActive
                          ? primary.withValues(alpha: 0.4)
                          : AppColors.border,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                      onTap: () {
                        settings.setActiveProfile(profile.name);

                        final scrcpyProvider = context.read<ScrcpyProvider>();
                        scrcpyProvider.updateConfig((_) => profile.config);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimens.md),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? primary.withValues(alpha: 0.15)
                                    : AppColors.surfaceHighlight,
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusSm,
                                ),
                              ),
                              child: Icon(
                                isActive
                                    ? Icons.check_circle_rounded
                                    : Icons.folder_rounded,
                                size: 16,
                                color: isActive ? primary : AppColors.textHint,
                              ),
                            ),
                            const SizedBox(width: AppDimens.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          profile.name,
                                          style: TextStyle(
                                            fontSize: AppDimens.fontSm,
                                            fontWeight: isActive
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: isActive
                                                ? primary
                                                : AppColors.textPrimary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isActive)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [primary, primary],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              AppDimens.radiusRound,
                                            ),
                                          ),
                                          child: const Text(
                                            'ACTIVE',
                                            style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    entries.isEmpty
                                        ? 'Default configuration'
                                        : '${entries.length} custom setting${entries.length == 1 ? '' : 's'}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            _TinyIconBtn(
                              icon: Icons.copy_rounded,
                              tooltip: 'Duplicate',
                              onTap: () {
                                _showDuplicateDialog(
                                  context,
                                  settings,
                                  profile.name,
                                );
                              },
                            ),
                            _TinyIconBtn(
                              icon: Icons.edit_rounded,
                              tooltip: 'Rename',
                              onTap: () {
                                _showRenameDialog(
                                  context,
                                  settings,
                                  profile.name,
                                );
                              },
                            ),
                            if (profiles.length > 1)
                              _TinyIconBtn(
                                icon: Icons.delete_outline_rounded,
                                tooltip: 'Delete',
                                color: AppColors.error,
                                onTap: () {
                                  _showDeleteDialog(
                                    context,
                                    settings,
                                    profile.name,
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showNewProfileDialog(BuildContext context, SettingsProvider settings) {
    final controller = TextEditingController();
    final primary = Theme.of(context).colorScheme.primary;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'New Profile',
          style: TextStyle(
            fontSize: AppDimens.fontLg,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: 300,
          child: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(
              fontSize: AppDimens.fontSm,
              color: AppColors.textPrimary,
            ),
            decoration: const InputDecoration(
              hintText: 'Profile name',
              hintStyle: TextStyle(color: AppColors.textHint),
            ),
            onSubmitted: (v) {
              if (v.trim().isNotEmpty) {
                settings.addProfile(v.trim());
                Navigator.of(ctx).pop();
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textHint),
            ),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                settings.addProfile(name);
                Navigator.of(ctx).pop();
              }
            },
            child: Text('Create', style: TextStyle(color: primary)),
          ),
        ],
      ),
    );
  }

  void _showDuplicateDialog(
    BuildContext context,
    SettingsProvider settings,
    String sourceName,
  ) {
    final controller = TextEditingController(text: '$sourceName (copy)');
    final primary = Theme.of(context).colorScheme.primary;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Duplicate Profile',
          style: TextStyle(
            fontSize: AppDimens.fontLg,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: 300,
          child: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(
              fontSize: AppDimens.fontSm,
              color: AppColors.textPrimary,
            ),
            decoration: const InputDecoration(
              hintText: 'New profile name',
              hintStyle: TextStyle(color: AppColors.textHint),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textHint),
            ),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                settings.duplicateProfile(sourceName, name);
                Navigator.of(ctx).pop();
              }
            },
            child: Text('Duplicate', style: TextStyle(color: primary)),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(
    BuildContext context,
    SettingsProvider settings,
    String oldName,
  ) {
    final controller = TextEditingController(text: oldName);
    final primary = Theme.of(context).colorScheme.primary;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Rename Profile',
          style: TextStyle(
            fontSize: AppDimens.fontLg,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: 300,
          child: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(
              fontSize: AppDimens.fontSm,
              color: AppColors.textPrimary,
            ),
            decoration: const InputDecoration(
              hintText: 'New name',
              hintStyle: TextStyle(color: AppColors.textHint),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textHint),
            ),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                settings.renameProfile(oldName, name);
                Navigator.of(ctx).pop();
              }
            },
            child: Text('Rename', style: TextStyle(color: primary)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    SettingsProvider settings,
    String name,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusLg),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Delete Profile',
          style: TextStyle(
            fontSize: AppDimens.fontLg,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "$name"?\nThis action cannot be undone.',
          style: const TextStyle(
            fontSize: AppDimens.fontSm,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textHint),
            ),
          ),
          TextButton(
            onPressed: () {
              settings.deleteProfile(name);
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateTab extends StatefulWidget {
  const _UpdateTab();

  @override
  State<_UpdateTab> createState() => _UpdateTabState();
}

class _UpdateTabState extends State<_UpdateTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().checkForUpdate();
      context.read<SettingsProvider>().fetchChangelog();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final primary = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.lg),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimens.lg),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [primary, primary]),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  ),
                  child: const Icon(
                    Icons.screen_share_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: AppDimens.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Super Scrcpy',
                        style: TextStyle(
                          fontSize: AppDimens.fontLg,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Current version: v${settings.currentVersion}',
                        style: const TextStyle(
                          fontSize: AppDimens.fontXs,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => settings.checkForUpdate(),
                  icon: const Icon(Icons.refresh_rounded, size: 14),
                  label: const Text('Check'),
                  style: TextButton.styleFrom(
                    foregroundColor: primary,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimens.lg),

          if (settings.isCheckingUpdate)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: AppDimens.md),
                  const Text(
                    'Checking for updates...',
                    style: TextStyle(
                      fontSize: AppDimens.fontSm,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          else if (settings.updateError != null)
            _StatusCard(
              icon: Icons.info_outline_rounded,
              color: AppColors.warning,
              title: 'Could not check for updates',
              subtitle: settings.updateError!,
              action: TextButton.icon(
                onPressed: () => settings.checkForUpdate(),
                icon: const Icon(Icons.refresh_rounded, size: 14),
                label: const Text('Retry'),
                style: TextButton.styleFrom(
                  foregroundColor: primary,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            )
          else if (settings.updateAvailable && settings.latestRelease != null)
            _StatusCard(
              icon: Icons.system_update_rounded,
              color: primary,
              title: 'Update available!',
              subtitle:
                  '${settings.latestRelease!.tagName} is available. You are on v${settings.currentVersion}.',
              action: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    onPressed: () =>
                        launchUrl(Uri.parse(settings.latestRelease!.htmlUrl)),
                    icon: const Icon(Icons.open_in_new_rounded, size: 14),
                    label: const Text('View Release'),
                    style: TextButton.styleFrom(
                      foregroundColor: primary,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const SizedBox(width: AppDimens.sm),
                  TextButton.icon(
                    onPressed: () => settings.checkForUpdate(),
                    icon: const Icon(Icons.refresh_rounded, size: 14),
                    label: const Text('Re-check'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textHint,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            )
          else
            _StatusCard(
              icon: Icons.check_circle_outline_rounded,
              color: AppColors.success,
              title: 'You\'re up to date!',
              subtitle:
                  'Super Scrcpy v${settings.currentVersion} is the latest version.',
              action: TextButton.icon(
                onPressed: () => settings.checkForUpdate(),
                icon: const Icon(Icons.refresh_rounded, size: 14),
                label: const Text('Check Again'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textHint,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),

          const SizedBox(height: AppDimens.md),

          InkWell(
            onTap: () => launchUrl(
              Uri.parse('https://github.com/anandssm/super_scrcpy/releases'),
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.md,
                vertical: AppDimens.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.code_rounded, size: 14, color: AppColors.textHint),
                  SizedBox(width: 6),
                  Text(
                    'View all releases on GitHub',
                    style: TextStyle(
                      fontSize: AppDimens.fontXs,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.open_in_new_rounded,
                    size: 11,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimens.lg),

          Row(
            children: [
              Icon(Icons.history_rounded, size: 16, color: primary),
              const SizedBox(width: 6),
              Text(
                'Changelog',
                style: TextStyle(
                  fontSize: AppDimens.fontMd,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.sm),
          _buildChangelogSection(settings, primary),
        ],
      ),
    );
  }

  Widget _buildChangelogSection(SettingsProvider settings, Color primary) {
    if (settings.isFetchingChangelog) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimens.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: primary,
              ),
            ),
            const SizedBox(height: AppDimens.sm),
            const Text(
              'Fetching changelog...',
              style: TextStyle(
                fontSize: AppDimens.fontXs,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      );
    }

    if (settings.changelogError != null) {
      return _StatusCard(
        icon: Icons.cloud_off_rounded,
        color: AppColors.warning,
        title: 'Could not load changelog',
        subtitle: settings.changelogError!,
        action: TextButton.icon(
          onPressed: () {
            settings.clearChangelogCache();
            settings.fetchChangelog();
          },
          icon: const Icon(Icons.refresh_rounded, size: 14),
          label: const Text('Retry'),
          style: TextButton.styleFrom(
            foregroundColor: primary,
            visualDensity: VisualDensity.compact,
          ),
        ),
      );
    }

    if (settings.releases.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimens.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        ),
        child: const Column(
          children: [
            Icon(Icons.history_rounded, size: 28, color: AppColors.textHint),
            SizedBox(height: AppDimens.sm),
            Text(
              'No releases yet',
              style: TextStyle(
                fontSize: AppDimens.fontSm,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      );
    }

    final releases = settings.releases;
    return Column(
      children: releases.asMap().entries.map((entry) {
        final i = entry.key;
        final release = entry.value;
        final isLatest = i == 0;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.sm),
          child: Container(
            decoration: BoxDecoration(
              color: isLatest
                  ? primary.withValues(alpha: 0.06)
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.md,
                  vertical: AppDimens.xs,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(
                  AppDimens.md,
                  0,
                  AppDimens.md,
                  AppDimens.md,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isLatest
                        ? primary.withValues(alpha: 0.15)
                        : AppColors.surfaceHighlight,
                    borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                  ),
                  child: Icon(
                    isLatest ? Icons.new_releases_rounded : Icons.label_rounded,
                    size: 14,
                    color: isLatest ? primary : AppColors.textHint,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        release.name.isNotEmpty
                            ? release.name
                            : release.tagName,
                        style: TextStyle(
                          fontSize: AppDimens.fontSm,
                          fontWeight: isLatest
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isLatest ? primary : AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isLatest)
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [primary, primary]),
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusRound,
                          ),
                        ),
                        child: const Text(
                          'LATEST',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    if (release.isPrerelease)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusRound,
                          ),
                        ),
                        child: const Text(
                          'PRE',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                  ],
                ),
                subtitle: Text(
                  _formatDate(release.publishedAt),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textHint,
                  ),
                ),
                iconColor: AppColors.textHint,
                collapsedIconColor: AppColors.textHint,
                initiallyExpanded: isLatest,
                children: [
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: AppDimens.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimens.md),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                    ),
                    child: SelectableText(
                      release.body.isNotEmpty
                          ? release.body
                          : 'No release notes provided.',
                      style: const TextStyle(
                        fontSize: AppDimens.fontXs,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => launchUrl(Uri.parse(release.htmlUrl)),
                      icon: const Icon(Icons.open_in_new_rounded, size: 12),
                      label: const Text('View on GitHub'),
                      style: TextButton.styleFrom(
                        foregroundColor: primary,
                        textStyle: const TextStyle(fontSize: AppDimens.fontXs),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimens.xl),
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(AppDimens.radiusLg),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [primary, primary]),
                    borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  ),
                  child: const Icon(
                    Icons.screen_share_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppDimens.md),
                const Text(
                  'Super Scrcpy',
                  style: TextStyle(
                    fontSize: AppDimens.fontXl,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Built for seamless Android screen mirroring and control.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimens.fontXs,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimens.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Developer',
                  style: TextStyle(
                    fontSize: AppDimens.fontXs,
                    color: AppColors.textHint,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Anand Kumar',
                  style: TextStyle(
                    fontSize: AppDimens.fontSm,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '@anandssm',
                  style: TextStyle(
                    fontSize: AppDimens.fontXs,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.sm),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: AppDimens.sm,
            crossAxisSpacing: AppDimens.sm,
            mainAxisExtent: AppDimens.buttonHeight,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _AboutActionTile(
                icon: Icons.public_rounded,
                label: 'Website',
                onTap: () =>
                    launchUrl(Uri.parse('https://superscrcpy.netlify.app')),
              ),
              _AboutActionTile(
                icon: Icons.code_rounded,
                label: 'GitHub',
                onTap: () => launchUrl(
                  Uri.parse('https://github.com/anandssm/super_scrcpy'),
                ),
              ),
              _AboutActionTile(
                icon: Icons.telegram,
                label: 'Telegram',
                onTap: () =>
                    launchUrl(Uri.parse('https://t.me/hanoipprojects')),
              ),
              _AboutActionTile(
                icon: Icons.favorite_rounded,
                label: 'Powered By Genymobile',
                onTap: () => launchUrl(
                  Uri.parse('https://github.com/Genymobile/scrcpy'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AboutActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimens.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: AppDimens.fontSm,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.open_in_new_rounded,
              size: 13,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget? action;

  const _StatusCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: AppDimens.md),
          Text(
            title,
            style: TextStyle(
              fontSize: AppDimens.fontMd,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppDimens.fontXs,
              color: AppColors.textSecondary,
            ),
          ),
          if (action != null) ...[
            const SizedBox(height: AppDimens.md),
            action!,
          ],
        ],
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SmallButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.sm,
          vertical: AppDimens.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TinyIconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;

  const _TinyIconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 13, color: color ?? AppColors.textHint),
        ),
      ),
    );
  }
}
