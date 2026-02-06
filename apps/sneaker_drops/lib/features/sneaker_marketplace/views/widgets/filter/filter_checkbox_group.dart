import 'package:flutter/material.dart';

import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';

/// **FilterCheckboxGroup**
///
/// Multi-select checkbox group for brands/rarities.
///
/// **Features:**
/// - Expandable/collapsible header
/// - Search within group (for groups with 5+ items)
/// - Select all / clear option
/// - Glassmorphism styling
///
/// **Example Usage:**
/// ```dart
/// FilterCheckboxGroup(
///   title: 'Brands',
///   options: ['Nike', 'Adidas', 'New Balance', 'Puma'],
///   selected: selectedBrands,
///   onChanged: (brands) => setState(() => selectedBrands = brands),
/// )
/// ```
class FilterCheckboxGroup extends StatefulWidget {
  /// Title displayed in the header.
  final String title;

  /// List of available options.
  final List<String> options;

  /// Set of currently selected options.
  final Set<String> selected;

  /// Callback when selection changes.
  final ValueChanged<Set<String>> onChanged;

  /// Whether the group starts expanded.
  final bool isExpanded;

  /// Minimum options count to show search field.
  final int searchThreshold;

  /// Creates a [FilterCheckboxGroup] with the specified parameters.
  const FilterCheckboxGroup({
    required this.title,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.isExpanded = true,
    this.searchThreshold = 5,
    super.key,
  });

  @override
  State<FilterCheckboxGroup> createState() => _FilterCheckboxGroupState();
}

class _FilterCheckboxGroupState extends State<FilterCheckboxGroup>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animationController;
  late Animation<double> _heightFactor;
  late Animation<double> _iconRotation;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _heightFactor = _animationController.drive(CurveTween(curve: Curves.easeInOut));
    _iconRotation = _animationController.drive(
      Tween<double>(begin: 0.0, end: 0.5),
    );

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _toggleOption(String option) {
    final newSelected = Set<String>.from(widget.selected);
    if (newSelected.contains(option)) {
      newSelected.remove(option);
    } else {
      newSelected.add(option);
    }
    widget.onChanged(newSelected);
  }

  void _selectAll() {
    widget.onChanged(Set<String>.from(widget.options));
  }

  void _clearAll() {
    widget.onChanged(<String>{});
  }

  List<String> get _filteredOptions {
    if (_searchQuery.isEmpty) return widget.options;
    return widget.options
        .where((o) => o.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  bool get _showSearch => widget.options.length >= widget.searchThreshold;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        ClipRect(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Align(
                heightFactor: _heightFactor.value,
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: _heightFactor.value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final selectedCount = widget.selected.length;
    final hasSelection = selectedCount > 0;

    return GestureDetector(
      onTap: _toggleExpanded,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SneakerSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: SneakerColors.cream,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (hasSelection) ...[
                    const SizedBox(width: SneakerSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SneakerSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: SneakerColors.burgundy,
                        borderRadius: SneakerRadii.badge,
                      ),
                      child: Text(
                        selectedCount.toString(),
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: SneakerColors.cream,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            RotationTransition(
              turns: _iconRotation,
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: SneakerColors.slateGrey,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search field
        if (_showSearch) ...[
          _buildSearchField(),
          const SizedBox(height: SneakerSpacing.sm),
        ],

        // Select all / Clear row
        _buildSelectAllRow(),
        const SizedBox(height: SneakerSpacing.sm),

        // Options list
        ..._filteredOptions.map(_buildCheckboxOption),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: SneakerColors.surfaceDark,
        borderRadius: SneakerRadii.radiusSm,
        border: Border.all(color: SneakerColors.border),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 13,
          color: SneakerColors.cream,
        ),
        decoration: InputDecoration(
          hintText: 'Search ${widget.title.toLowerCase()}...',
          hintStyle: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            color: SneakerColors.slateGrey.withValues(alpha: 0.7),
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 18,
            color: SneakerColors.slateGrey,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: SneakerSpacing.sm,
            vertical: SneakerSpacing.sm,
          ),
          isDense: true,
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildSelectAllRow() {
    final allSelected = widget.selected.length == widget.options.length;
    final hasSelection = widget.selected.isNotEmpty;

    return Row(
      children: [
        GestureDetector(
          onTap: allSelected ? null : _selectAll,
          child: Text(
            'Select All',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: allSelected
                  ? SneakerColors.slateGrey.withValues(alpha: 0.5)
                  : SneakerColors.powderBlush,
            ),
          ),
        ),
        const SizedBox(width: SneakerSpacing.md),
        GestureDetector(
          onTap: hasSelection ? _clearAll : null,
          child: Text(
            'Clear',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: hasSelection
                  ? SneakerColors.powderBlush
                  : SneakerColors.slateGrey.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxOption(String option) {
    final isSelected = widget.selected.contains(option);

    return GestureDetector(
      onTap: () => _toggleOption(option),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SneakerSpacing.xs),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected
                    ? SneakerColors.burgundy
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? SneakerColors.burgundy
                      : SneakerColors.slateGrey,
                  width: 1.5,
                ),
                borderRadius: SneakerRadii.radiusSm,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: SneakerColors.cream,
                    )
                  : null,
            ),
            const SizedBox(width: SneakerSpacing.md),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? SneakerColors.cream
                      : SneakerColors.cream.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
