import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_dimens.dart';

class SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;
  final bool collapsible;
  final bool initiallyExpanded;

  const SettingsCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
    this.collapsible = false,
    this.initiallyExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    if (collapsible) {
      return _CollapsibleCard(
        title: title,
        icon: icon,
        trailing: trailing,
        initiallyExpanded: initiallyExpanded,
        child: child,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.lg,
              AppDimens.lg,
              AppDimens.lg,
              AppDimens.sm,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimens.sm),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [primary, primary]),
                    borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    size: AppDimens.iconMd,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: AppDimens.md),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: AppDimens.fontLg,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          Padding(padding: const EdgeInsets.all(AppDimens.lg), child: child),
        ],
      ),
    );
  }
}

class _CollapsibleCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final bool initiallyExpanded;
  final Widget child;

  const _CollapsibleCard({
    required this.title,
    required this.icon,
    this.trailing,
    required this.initiallyExpanded,
    required this.child,
  });

  @override
  State<_CollapsibleCard> createState() => _CollapsibleCardState();
}

class _CollapsibleCardState extends State<_CollapsibleCard>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDimens.animMedium),
    );
    _heightFactor = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    if (_expanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.lg),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimens.sm),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [primary, primary]),
                      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                    ),
                    child: Icon(
                      widget.icon,
                      size: AppDimens.iconMd,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: AppDimens.md),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: AppDimens.fontLg,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (widget.trailing != null) ...[
                    widget.trailing!,
                    const SizedBox(width: AppDimens.sm),
                  ],
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(
                      milliseconds: AppDimens.animMedium,
                    ),
                    child: const Icon(
                      Icons.expand_more,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: SizeTransition(
              sizeFactor: _heightFactor,
              child: Column(
                children: [
                  const Divider(color: AppColors.border, height: 1),
                  Padding(
                    padding: const EdgeInsets.all(AppDimens.lg),
                    child: widget.child,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
