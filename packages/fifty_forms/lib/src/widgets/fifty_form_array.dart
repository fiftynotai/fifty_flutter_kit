import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';

/// Dynamic form array for repeating field groups.
///
/// Allows users to add and remove items dynamically. Each item
/// is built using the [itemBuilder] and can contain multiple fields.
///
/// Field names in arrays follow the pattern: `{name}[{index}].{fieldName}`
/// For example: `addresses[0].street`, `addresses[0].city`
///
/// **Example:**
/// ```dart
/// FiftyFormArray(
///   controller: formController,
///   name: 'addresses',
///   minItems: 1,
///   maxItems: 5,
///   itemBuilder: (context, index, remove) => AddressFields(
///     index: index,
///     onRemove: remove,
///   ),
///   addButtonBuilder: (add) => FiftyButton(
///     label: 'Add Address',
///     onPressed: add,
///     variant: FiftyButtonVariant.ghost,
///   ),
/// )
/// ```
///
/// **Accessing array values:**
/// ```dart
/// // Get single field
/// final street = controller.getArrayValue<String>('addresses', 0, 'street');
///
/// // Get all items as list of maps
/// final addresses = controller.getArrayValues('addresses');
/// // Returns: [{street: '123 Main', city: 'NYC'}, ...]
/// ```
class FiftyFormArray extends StatefulWidget {
  /// Form controller.
  final FiftyFormController controller;

  /// Base name for array fields.
  ///
  /// Fields will be named: `{name}[{index}].{fieldName}`
  /// For example: `addresses[0].street`, `addresses[0].city`
  final String name;

  /// Minimum number of items required.
  ///
  /// Remove button will be disabled when at minimum. Defaults to 0.
  final int minItems;

  /// Maximum number of items allowed.
  ///
  /// Add button will be hidden when at maximum. Defaults to 10.
  final int maxItems;

  /// Builder for each array item.
  ///
  /// [context] is the build context.
  /// [index] is the item index (0-indexed).
  /// [remove] is a callback to remove this item (respects [minItems]).
  final Widget Function(BuildContext context, int index, VoidCallback remove)
      itemBuilder;

  /// Builder for the add button.
  ///
  /// [add] is a callback to add a new item (respects [maxItems]).
  /// If not provided, a default ghost button is shown.
  final Widget Function(VoidCallback add)? addButtonBuilder;

  /// Initial number of items when the array is created.
  ///
  /// Defaults to 1.
  final int initialCount;

  /// Whether to animate add/remove operations.
  ///
  /// When true, uses [AnimatedList] for smooth transitions.
  /// Defaults to true.
  final bool animate;

  /// Duration for animations.
  ///
  /// Only used when [animate] is true. Defaults to 300 milliseconds.
  final Duration animationDuration;

  /// Spacing between items.
  ///
  /// Defaults to 16 (FiftySpacing.lg).
  final double itemSpacing;

  /// Label shown above the add button.
  ///
  /// If not provided, no label is shown.
  final String? addLabel;

  /// Creates a dynamic form array.
  const FiftyFormArray({
    super.key,
    required this.controller,
    required this.name,
    required this.itemBuilder,
    this.minItems = 0,
    this.maxItems = 10,
    this.addButtonBuilder,
    this.initialCount = 1,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.itemSpacing = FiftySpacing.lg,
    this.addLabel,
  });

  @override
  State<FiftyFormArray> createState() => _FiftyFormArrayState();
}

class _FiftyFormArrayState extends State<FiftyFormArray> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  /// Track item IDs (not indices) for stable keys during animations.
  late List<int> _items;

  /// Counter for generating unique item IDs.
  int _nextId = 0;

  @override
  void initState() {
    super.initState();
    _items = List.generate(widget.initialCount, (_) => _nextId++);
    _registerArrayValue();
  }

  /// Registers the array field with the controller.
  void _registerArrayValue() {
    widget.controller.registerField(widget.name, initialValue: _items.length);
  }

  /// Whether more items can be added.
  bool get canAdd => _items.length < widget.maxItems;

  /// Whether items can be removed.
  bool get canRemove => _items.length > widget.minItems;

  /// Adds a new item to the array.
  void _addItem() {
    if (!canAdd) return;

    final newId = _nextId++;
    _items.add(newId);

    if (widget.animate) {
      _listKey.currentState?.insertItem(
        _items.length - 1,
        duration: widget.animationDuration,
      );
    }

    widget.controller.setValue(widget.name, _items.length, validate: false);
    setState(() {});
  }

  /// Removes an item from the array at [index].
  void _removeItem(int index) {
    if (!canRemove) return;
    if (index < 0 || index >= _items.length) return;

    final removedId = _items[index];
    _items.removeAt(index);

    if (widget.animate) {
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildRemovedItem(removedId, index, animation),
        duration: widget.animationDuration,
      );
    }

    // Remove array item fields from controller and shift subsequent indices
    widget.controller.removeArrayItem(widget.name, index);

    widget.controller.setValue(widget.name, _items.length, validate: false);
    setState(() {});
  }

  /// Builds the widget shown during item removal animation.
  Widget _buildRemovedItem(
      int id, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.itemSpacing),
          child: widget.itemBuilder(context, index, () {}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Items list
        if (widget.animate)
          AnimatedList(
            key: _listKey,
            initialItemCount: _items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index, animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: widget.itemSpacing),
                    child: _ArrayItemWrapper(
                      index: index,
                      canRemove: canRemove,
                      onRemove: () => _removeItem(index),
                      child: widget.itemBuilder(
                        context,
                        index,
                        canRemove ? () => _removeItem(index) : () {},
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        else
          Column(
            children: [
              for (int i = 0; i < _items.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: widget.itemSpacing),
                  child: _ArrayItemWrapper(
                    index: i,
                    canRemove: canRemove,
                    onRemove: () => _removeItem(i),
                    child: widget.itemBuilder(
                      context,
                      i,
                      canRemove ? () => _removeItem(i) : () {},
                    ),
                  ),
                ),
            ],
          ),

        // Add button
        if (canAdd) ...[
          if (widget.addLabel != null) ...[
            Text(
              widget.addLabel!.toUpperCase(),
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelSmall,
                fontWeight: FiftyTypography.medium,
                letterSpacing: FiftyTypography.letterSpacingLabel,
                color: Theme.of(context).colorScheme.onSurface.withValues(
                      alpha: 0.7,
                    ),
              ),
            ),
            const SizedBox(height: FiftySpacing.sm),
          ],
          widget.addButtonBuilder?.call(_addItem) ??
              FiftyButton(
                onPressed: _addItem,
                variant: FiftyButtonVariant.ghost,
                label: 'ADD ITEM',
                icon: Icons.add,
              ),
        ],
      ],
    );
  }
}

/// Wrapper widget for array items that provides visual structure.
class _ArrayItemWrapper extends StatelessWidget {
  final int index;
  final bool canRemove;
  final VoidCallback onRemove;
  final Widget child;

  const _ArrayItemWrapper({
    required this.index,
    required this.canRemove,
    required this.onRemove,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: FiftyRadii.lgRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with index and remove button
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FiftySpacing.md,
              vertical: FiftySpacing.sm,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(FiftyRadii.lg - 1),
                topRight: Radius.circular(FiftyRadii.lg - 1),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'ITEM ${index + 1}',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.labelSmall,
                    fontWeight: FiftyTypography.bold,
                    letterSpacing: FiftyTypography.letterSpacingLabel,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const Spacer(),
                if (canRemove)
                  FiftyIconButton(
                    icon: Icons.close,
                    tooltip: 'Remove item',
                    onPressed: onRemove,
                    size: FiftyIconButtonSize.small,
                    variant: FiftyIconButtonVariant.ghost,
                  ),
              ],
            ),
          ),
          // Item content
          Padding(
            padding: const EdgeInsets.all(FiftySpacing.md),
            child: child,
          ),
        ],
      ),
    );
  }
}
