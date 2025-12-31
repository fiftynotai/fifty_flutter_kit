import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A dropdown menu item for FiftyDropdown.
class FiftyDropdownItem<T> {
  /// Creates a dropdown item.
  const FiftyDropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });

  /// The value associated with this item.
  final T value;

  /// The display label for this item.
  final String label;

  /// Optional icon displayed before the label.
  final IconData? icon;
}

/// A terminal-styled dropdown selector following FDL design principles.
///
/// Features:
/// - Looks like FiftyTextField with chevron indicator
/// - Gunmetal menu background with HyperChrome border
/// - Crimson highlight on hover
/// - Fast slide-down animation
/// - Monospace typography
///
/// Example:
/// ```dart
/// FiftyDropdown<String>(
///   value: _selectedLanguage,
///   onChanged: (value) => setState(() => _selectedLanguage = value),
///   items: [
///     FiftyDropdownItem(value: 'dart', label: 'Dart'),
///     FiftyDropdownItem(value: 'kotlin', label: 'Kotlin'),
///     FiftyDropdownItem(value: 'swift', label: 'Swift'),
///   ],
///   label: 'Language',
///   hint: 'Select a language',
/// )
/// ```
class FiftyDropdown<T> extends StatefulWidget {
  /// Creates a Fifty-styled dropdown.
  const FiftyDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.label,
    this.hint,
    this.enabled = true,
  });

  /// List of selectable items.
  final List<FiftyDropdownItem<T>> items;

  /// Currently selected value.
  final T? value;

  /// Callback when selection changes.
  final ValueChanged<T?>? onChanged;

  /// Label displayed above the dropdown.
  final String? label;

  /// Hint text when no value is selected.
  final String? hint;

  /// Whether the dropdown is enabled.
  final bool enabled;

  @override
  State<FiftyDropdown<T>> createState() => _FiftyDropdownState<T>();
}

class _FiftyDropdownState<T> extends State<FiftyDropdown<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  FiftyDropdownItem<T>? get _selectedItem {
    if (widget.value == null) return null;
    try {
      return widget.items.firstWhere((item) => item.value == widget.value);
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (!widget.enabled || widget.onChanged == null) return;

    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _animationController.reverse().then((_) {
      _removeOverlay();
    });
    setState(() => _isOpen = false);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectItem(FiftyDropdownItem<T> item) {
    widget.onChanged?.call(item.value);
    _closeDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            color: Colors.transparent,
            child: AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scaleY: _expandAnimation.value,
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: _expandAnimation.value,
                    child: child,
                  ),
                );
              },
              child: _DropdownMenu<T>(
                items: widget.items,
                selectedValue: widget.value,
                onSelect: _selectItem,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    final isEnabled = widget.enabled && widget.onChanged != null;
    final opacity = isEnabled ? 1.0 : 0.5;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Opacity(
        opacity: opacity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.label != null) ...[
              Text(
                widget.label!.toUpperCase(),
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  fontSize: FiftyTypography.mono,
                  fontWeight: FiftyTypography.medium,
                  color: _isOpen
                      ? colorScheme.primary
                      : FiftyColors.hyperChrome,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: FiftySpacing.sm),
            ],
            MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              cursor: isEnabled
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              child: GestureDetector(
                onTap: _toggleDropdown,
                child: AnimatedContainer(
                  duration: fifty.fast,
                  padding: const EdgeInsets.symmetric(
                    horizontal: FiftySpacing.lg,
                    vertical: FiftySpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: FiftyColors.gunmetal,
                    borderRadius: FiftyRadii.standardRadius,
                    border: Border.all(
                      color: _isOpen
                          ? colorScheme.primary
                          : (_isHovered
                              ? colorScheme.primary.withValues(alpha: 0.5)
                              : FiftyColors.border),
                      width: _isOpen ? 2 : 1,
                    ),
                    boxShadow: _isOpen ? fifty.focusGlow : null,
                  ),
                  child: Row(
                    children: [
                      // Selected value or hint
                      Expanded(
                        child: Text(
                          _selectedItem?.label ?? widget.hint ?? '',
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamilyMono,
                            fontSize: FiftyTypography.body,
                            fontWeight: FiftyTypography.regular,
                            color: _selectedItem != null
                                ? colorScheme.onSurface
                                : FiftyColors.hyperChrome,
                          ),
                        ),
                      ),

                      // Chevron indicator
                      AnimatedRotation(
                        duration: fifty.fast,
                        turns: _isOpen ? 0.5 : 0,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: _isOpen
                              ? colorScheme.primary
                              : FiftyColors.hyperChrome,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal dropdown menu widget.
class _DropdownMenu<T> extends StatelessWidget {
  const _DropdownMenu({
    required this.items,
    required this.selectedValue,
    required this.onSelect,
  });

  final List<FiftyDropdownItem<T>> items;
  final T? selectedValue;
  final ValueChanged<FiftyDropdownItem<T>> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 240),
      decoration: BoxDecoration(
        color: FiftyColors.gunmetal,
        borderRadius: FiftyRadii.standardRadius,
        border: Border.all(
          color: FiftyColors.hyperChrome.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: FiftyColors.voidBlack.withValues(alpha: 0.5),
            blurRadius: 12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: FiftyRadii.standardRadius,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: FiftySpacing.xs),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = item.value == selectedValue;

            return _DropdownMenuItem<T>(
              item: item,
              isSelected: isSelected,
              onTap: () => onSelect(item),
            );
          },
        ),
      ),
    );
  }
}

/// Internal dropdown menu item widget.
class _DropdownMenuItem<T> extends StatefulWidget {
  const _DropdownMenuItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final FiftyDropdownItem<T> item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_DropdownMenuItem<T>> createState() => _DropdownMenuItemState<T>();
}

class _DropdownMenuItemState<T> extends State<_DropdownMenuItem<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(
            horizontal: FiftySpacing.lg,
            vertical: FiftySpacing.md,
          ),
          color: _isHovered
              ? colorScheme.primary.withValues(alpha: 0.2)
              : (widget.isSelected
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent),
          child: Row(
            children: [
              if (widget.item.icon != null) ...[
                Icon(
                  widget.item.icon,
                  size: 16,
                  color: widget.isSelected || _isHovered
                      ? colorScheme.primary
                      : FiftyColors.hyperChrome,
                ),
                const SizedBox(width: FiftySpacing.sm),
              ],
              Expanded(
                child: Text(
                  widget.item.label,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamilyMono,
                    fontSize: FiftyTypography.body,
                    fontWeight: widget.isSelected
                        ? FiftyTypography.medium
                        : FiftyTypography.regular,
                    color: widget.isSelected || _isHovered
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
              ),
              if (widget.isSelected)
                Icon(
                  Icons.check,
                  size: 16,
                  color: colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
