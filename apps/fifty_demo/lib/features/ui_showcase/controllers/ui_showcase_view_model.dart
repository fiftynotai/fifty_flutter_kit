/// UI Showcase ViewModel
///
/// Business logic for the UI showcase feature.
library;

import 'package:get/get.dart';

/// ViewModel for the UI showcase feature.
///
/// Provides state for showcasing FDL components.
class UiShowcaseViewModel extends GetxController {
  UiShowcaseViewModel();

  // ─────────────────────────────────────────────────────────────────────────
  // Section State
  // ─────────────────────────────────────────────────────────────────────────

  String _activeSection = 'buttons';
  String get activeSection => _activeSection;

  /// Available sections.
  static const List<SectionInfo> sections = [
    SectionInfo(id: 'buttons', label: 'BUTTONS', icon: 0xe1e8),
    SectionInfo(id: 'inputs', label: 'INPUTS', icon: 0xe22f),
    SectionInfo(id: 'display', label: 'DISPLAY', icon: 0xe6e1),
    SectionInfo(id: 'feedback', label: 'FEEDBACK', icon: 0xe7f4),
  ];

  /// Changes the active section.
  void setActiveSection(String sectionId) {
    _activeSection = sectionId;
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Demo State
  // ─────────────────────────────────────────────────────────────────────────

  // Button state
  bool _buttonLoading = false;
  bool get buttonLoading => _buttonLoading;

  void toggleButtonLoading() {
    _buttonLoading = !_buttonLoading;
    update();
  }

  // Input state
  String _inputValue = '';
  String get inputValue => _inputValue;

  void setInputValue(String value) {
    _inputValue = value;
    update();
  }

  bool _switchValue = false;
  bool get switchValue => _switchValue;

  void toggleSwitch() {
    _switchValue = !_switchValue;
    update();
  }

  double _sliderValue = 0.5;
  double get sliderValue => _sliderValue;

  void setSliderValue(double value) {
    _sliderValue = value;
    update();
  }

  // Display mode state (for radio card demo)
  int _displayMode = 1; // 0 = light, 1 = dark
  int get displayMode => _displayMode;

  void setDisplayMode(int? mode) {
    if (mode != null) {
      _displayMode = mode;
      update();
    }
  }

  // Display state
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  void setTabIndex(int index) {
    _tabIndex = index;
    update();
  }

  // Feedback state
  bool _showSnackbar = false;
  bool get showSnackbar => _showSnackbar;

  void triggerSnackbar() {
    _showSnackbar = true;
    update();
    Future.delayed(const Duration(seconds: 3), () {
      _showSnackbar = false;
      update();
    });
  }
}

/// Section information.
class SectionInfo {
  const SectionInfo({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final int icon;
}
