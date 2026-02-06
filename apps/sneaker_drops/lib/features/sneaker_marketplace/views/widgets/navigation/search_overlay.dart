import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';

/// **SearchOverlay**
///
/// Full-screen search overlay with glassmorphism.
///
/// Features:
/// - Search input field
/// - Recent searches list
/// - Popular searches
/// - Close on escape/tap outside
class SearchOverlay extends StatefulWidget {
  /// Creates a full-screen search overlay.
  const SearchOverlay({
    super.key,
    required this.onClose,
    required this.onSearch,
    this.recentSearches = const [],
    this.popularSearches = const [
      'Jordan 1',
      'Yeezy',
      'Nike Dunk',
      'New Balance 550',
      'Air Force 1',
    ],
  });

  /// Callback when overlay is closed.
  final VoidCallback onClose;

  /// Callback when a search is submitted.
  final void Function(String query) onSearch;

  /// List of recent search queries.
  final List<String> recentSearches;

  /// List of popular search queries.
  final List<String> popularSearches;

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: SneakerAnimations.medium,
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: SneakerAnimations.standard,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: SneakerAnimations.enter,
    ));

    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleClose() async {
    await _animationController.reverse();
    widget.onClose();
  }

  void _handleSearch(String query) {
    if (query.trim().isNotEmpty) {
      widget.onSearch(query.trim());
      _handleClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          _handleClose();
        }
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: _handleClose,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: SneakerColors.darkBurgundy.withValues(alpha: 0.95),
                child: SafeArea(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: GestureDetector(
                      onTap: () {},
                      child: _buildContent(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SneakerSpacing.xxl,
        vertical: SneakerSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: SneakerSpacing.xxl),
          _buildSearchField(),
          const SizedBox(height: SneakerSpacing.xxxl),
          if (widget.recentSearches.isNotEmpty) ...[
            _buildSection(
              title: 'RECENT SEARCHES',
              items: widget.recentSearches,
              showClear: true,
            ),
            const SizedBox(height: SneakerSpacing.xxxl),
          ],
          _buildSection(
            title: 'POPULAR SEARCHES',
            items: widget.popularSearches,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'SEARCH',
          style: SneakerTypography.sectionTitle,
        ),
        _CloseButton(onTap: _handleClose),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: SneakerColors.surfaceDark,
        borderRadius: SneakerRadii.input,
        border: Border.all(
          color: SneakerColors.glassBorder,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        style: SneakerTypography.body.copyWith(color: SneakerColors.cream),
        decoration: InputDecoration(
          hintText: 'Search sneakers, brands, styles...',
          hintStyle: SneakerTypography.body.copyWith(
            color: SneakerColors.slateGrey,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: SneakerColors.slateGrey,
            size: 24,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  color: SneakerColors.slateGrey,
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: SneakerSpacing.lg,
            vertical: SneakerSpacing.lg,
          ),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: _handleSearch,
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> items,
    bool showClear = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: SneakerTypography.label.copyWith(
                color: SneakerColors.slateGrey,
              ),
            ),
            if (showClear)
              GestureDetector(
                onTap: () {
                  // Would trigger clear recent searches callback
                },
                child: Text(
                  'CLEAR',
                  style: SneakerTypography.badge.copyWith(
                    color: SneakerColors.burgundy,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: SneakerSpacing.lg),
        Wrap(
          spacing: SneakerSpacing.sm,
          runSpacing: SneakerSpacing.sm,
          children: items.map((item) => _SearchChip(
            label: item,
            onTap: () => _handleSearch(item),
          )).toList(),
        ),
      ],
    );
  }
}

/// Search suggestion chip.
class _SearchChip extends StatefulWidget {
  const _SearchChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  State<_SearchChip> createState() => _SearchChipState();
}

class _SearchChipState extends State<_SearchChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Search for ${widget.label}',
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Focus(
            child: AnimatedContainer(
              duration: SneakerAnimations.fast,
              padding: const EdgeInsets.symmetric(
                horizontal: SneakerSpacing.md,
                vertical: SneakerSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: _isHovered
                    ? SneakerColors.burgundy.withValues(alpha: 0.3)
                    : SneakerColors.surfaceDark,
                borderRadius: SneakerRadii.chip,
                border: Border.all(
                  color: _isHovered
                      ? SneakerColors.burgundy
                      : SneakerColors.border,
                  width: 1,
                ),
              ),
              child: Text(
                widget.label,
                style: SneakerTypography.description.copyWith(
                  color: _isHovered
                      ? SneakerColors.cream
                      : SneakerColors.slateGrey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Close button for the search overlay.
class _CloseButton extends StatefulWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Close search',
      button: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Focus(
            child: AnimatedContainer(
              duration: SneakerAnimations.fast,
              padding: SneakerSpacing.allSm,
              decoration: BoxDecoration(
                color: _isHovered
                    ? SneakerColors.burgundy.withValues(alpha: 0.3)
                    : Colors.transparent,
                borderRadius: SneakerRadii.radiusMd,
              ),
              child: Icon(
                Icons.close,
                color:
                    _isHovered ? SneakerColors.cream : SneakerColors.slateGrey,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
