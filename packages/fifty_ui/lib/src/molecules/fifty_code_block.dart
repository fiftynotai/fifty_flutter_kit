import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A terminal-style code display component with FDL v2 styling.
///
/// Implements the FDL syntax highlighter specification:
/// - Background: Mode-aware surface color
/// - Border: Mode-aware border color
/// - Line numbers: Optional, slateGrey color
/// - Syntax highlighting:
///   - Primary: Keywords
///   - HunterGreen: Strings
///   - SlateGrey: Comments
/// - Copy button in top-right corner
/// - Manrope typography
///
/// Example:
/// ```dart
/// FiftyCodeBlock(
///   code: '''
/// void main() {
///   print('Hello, Fifty!');
/// }
/// ''',
///   language: 'dart',
///   showLineNumbers: true,
/// )
/// ```
class FiftyCodeBlock extends StatefulWidget {
  /// Creates a code block widget.
  const FiftyCodeBlock({
    super.key,
    required this.code,
    this.language = 'dart',
    this.showLineNumbers = true,
    this.copyButton = true,
    this.maxHeight,
    this.padding,
    this.backgroundColor,
  });

  /// The source code to display.
  final String code;

  /// The programming language for syntax highlighting.
  ///
  /// Currently supports: dart, javascript, json, plain.
  final String language;

  /// Whether to show line numbers.
  ///
  /// Defaults to true.
  final bool showLineNumbers;

  /// Whether to show a copy button in the top-right corner.
  ///
  /// Defaults to true.
  final bool copyButton;

  /// Maximum height for the code block.
  ///
  /// If null, expands to fit content.
  final double? maxHeight;

  /// Padding inside the code block.
  ///
  /// Defaults to [FiftySpacing.md].
  final EdgeInsetsGeometry? padding;

  /// Background color override.
  ///
  /// Defaults to mode-aware surface color.
  final Color? backgroundColor;

  @override
  State<FiftyCodeBlock> createState() => _FiftyCodeBlockState();
}

class _FiftyCodeBlockState extends State<FiftyCodeBlock> {
  bool _copied = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);

    // Reset after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    final lines = widget.code.split('\n');
    final lineNumberWidth = '${lines.length}'.length * 10.0 + FiftySpacing.md;

    final effectivePadding = widget.padding ??
        const EdgeInsets.all(FiftySpacing.md);
    final effectiveBackgroundColor = widget.backgroundColor ??
        colorScheme.surfaceContainerHighest;
    final borderColor = colorScheme.outline;
    final lineNumberColor = colorScheme.onSurfaceVariant;

    return Container(
      constraints: widget.maxHeight != null
          ? BoxConstraints(maxHeight: widget.maxHeight!)
          : null,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: FiftyRadii.xlRadius,
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Code content
          SingleChildScrollView(
            child: Padding(
              padding: effectivePadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showLineNumbers) ...[
                    SizedBox(
                      width: lineNumberWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(lines.length, (index) {
                          return Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontSize: FiftyTypography.bodySmall,
                              color: lineNumberColor,
                              height: FiftyTypography.lineHeightBody,
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: FiftySpacing.md),
                    Container(
                      width: 1,
                      color: borderColor.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: FiftySpacing.md),
                  ],
                  Expanded(
                    child: SelectableText.rich(
                      _buildHighlightedCode(lines, colorScheme, fifty),
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: colorScheme.onSurface,
                        height: FiftyTypography.lineHeightBody,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Copy button
          if (widget.copyButton)
            Positioned(
              top: FiftySpacing.sm,
              right: FiftySpacing.sm,
              child: _CopyButton(
                copied: _copied,
                onPressed: _copyToClipboard,
                duration: fifty.fast,
              ),
            ),
        ],
      ),
    );
  }

  TextSpan _buildHighlightedCode(
    List<String> lines,
    ColorScheme colorScheme,
    FiftyThemeExtension fifty,
  ) {
    final spans = <TextSpan>[];

    for (int i = 0; i < lines.length; i++) {
      if (i > 0) {
        spans.add(const TextSpan(text: '\n'));
      }
      spans.addAll(_highlightLine(lines[i], colorScheme, fifty));
    }

    return TextSpan(children: spans);
  }

  List<TextSpan> _highlightLine(
    String line,
    ColorScheme colorScheme,
    FiftyThemeExtension fifty,
  ) {
    if (widget.language == 'plain') {
      return [TextSpan(text: line)];
    }

    final spans = <TextSpan>[];
    final keywordColor = colorScheme.primary;
    final stringColor = fifty.success; // Green for strings
    final commentColor = colorScheme.onSurfaceVariant;
    final numberColor = fifty.warning;

    // Dart/JavaScript keywords
    const keywords = {
      'void', 'class', 'abstract', 'extends', 'implements', 'with',
      'mixin', 'enum', 'typedef', 'static', 'final', 'var',
      'late', 'required', 'if', 'else', 'for', 'while', 'do', 'switch',
      'case', 'break', 'continue', 'return', 'try', 'catch', 'finally',
      'throw', 'async', 'await', 'yield', 'import', 'export', 'library',
      'part', 'show', 'hide', 'as', 'is', 'new', 'this', 'super', 'true',
      'false', 'null', 'get', 'set', 'operator', 'Function', 'String',
      'int', 'double', 'num', 'bool', 'List', 'Map', 'Set', 'dynamic',
      'Object', 'Future', 'Stream', 'Iterable', 'Widget', 'BuildContext',
      'State', 'StatelessWidget', 'StatefulWidget', 'override', 'function',
      'let', 'const', 'interface', 'type', 'public', 'private', 'protected',
    };

    // Check for single-line comment
    final commentIndex = line.indexOf('//');
    String codePart = line;
    String commentPart = '';

    if (commentIndex != -1) {
      codePart = line.substring(0, commentIndex);
      commentPart = line.substring(commentIndex);
    }

    // Process code part with regex for tokens
    final tokenRegex = RegExp(
      r'''("[^"]*"|'[^']*'|\b\d+\.?\d*\b|\b\w+\b|[^\s\w]+|\s+)''',
    );
    final matches = tokenRegex.allMatches(codePart);

    for (final match in matches) {
      final token = match.group(0)!;

      if (token.startsWith('"') || token.startsWith("'")) {
        // String literal
        spans.add(TextSpan(
          text: token,
          style: TextStyle(color: stringColor),
        ));
      } else if (RegExp(r'^\d+\.?\d*$').hasMatch(token)) {
        // Number
        spans.add(TextSpan(
          text: token,
          style: TextStyle(color: numberColor),
        ));
      } else if (keywords.contains(token)) {
        // Keyword
        spans.add(TextSpan(
          text: token,
          style: TextStyle(
            color: keywordColor,
            fontWeight: FontWeight.w600,
          ),
        ));
      } else {
        // Default text
        spans.add(TextSpan(text: token));
      }
    }

    // Add comment part if present
    if (commentPart.isNotEmpty) {
      spans.add(TextSpan(
        text: commentPart,
        style: TextStyle(
          color: commentColor,
          fontStyle: FontStyle.italic,
        ),
      ));
    }

    return spans;
  }
}

class _CopyButton extends StatefulWidget {
  const _CopyButton({
    required this.copied,
    required this.onPressed,
    required this.duration,
  });

  final bool copied;
  final VoidCallback onPressed;
  final Duration duration;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fiftyTheme = theme.extension<FiftyThemeExtension>();

    final iconColor = colorScheme.onSurfaceVariant;
    final hoverBackgroundColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.2);
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: widget.duration,
          padding: const EdgeInsets.all(FiftySpacing.xs),
          decoration: BoxDecoration(
            color: _isHovered ? hoverBackgroundColor : Colors.transparent,
            borderRadius: FiftyRadii.smRadius,
          ),
          child: Icon(
            widget.copied ? Icons.check : Icons.copy,
            size: 16,
            color: widget.copied ? successColor : iconColor,
          ),
        ),
      ),
    );
  }
}
