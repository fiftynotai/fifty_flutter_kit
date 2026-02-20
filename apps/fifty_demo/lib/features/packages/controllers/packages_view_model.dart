/// Packages ViewModel
///
/// Business logic for the packages hub feature.
/// Provides package categories and demo navigation.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Information about a package demo.
class PackageDemo {
  /// Creates a package demo entry.
  const PackageDemo({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    this.isAvailable = true,
  });

  /// Unique identifier for the package.
  final String id;

  /// Display name of the package.
  final String name;

  /// Brief description of what the package does.
  final String description;

  /// Icon to display for this package.
  final IconData icon;

  /// Category grouping for the package.
  final PackageCategory category;

  /// Whether the demo is available (implemented).
  final bool isAvailable;
}

/// Categories for organizing packages.
enum PackageCategory {
  /// Core design system packages.
  design('Design System'),

  /// Engine packages (audio, speech, map, etc).
  engines('Engines'),

  /// Utility and infrastructure packages.
  utilities('Utilities'),

  /// Feature packages (achievements, skills, etc).
  features('Features');

  const PackageCategory(this.label);

  /// Display label for the category.
  final String label;
}

/// ViewModel for the packages hub feature.
///
/// Provides package listings organized by category.
///
/// **Note:** No `onClose()` override needed. This ViewModel holds only static
/// const data with no subscriptions, timers, or mutable state to clean up.
class PackagesViewModel extends GetxController {
  /// All available package demos.
  static const List<PackageDemo> allPackages = [
    // Design System
    PackageDemo(
      id: 'fifty_tokens',
      name: 'Fifty Tokens',
      description: 'Design tokens (colors, typography, spacing)',
      icon: Icons.palette_outlined,
      category: PackageCategory.design,
    ),
    PackageDemo(
      id: 'fifty_theme',
      name: 'Fifty Theme',
      description: 'Theme system with dark/light modes',
      icon: Icons.dark_mode_outlined,
      category: PackageCategory.design,
    ),
    PackageDemo(
      id: 'fifty_ui',
      name: 'Fifty UI',
      description: 'Component library (buttons, cards, inputs)',
      icon: Icons.widgets_outlined,
      category: PackageCategory.design,
    ),

    // Engines
    PackageDemo(
      id: 'fifty_audio_engine',
      name: 'Audio Engine',
      description: 'BGM, SFX, and voice audio channels',
      icon: Icons.audiotrack_outlined,
      category: PackageCategory.engines,
    ),
    PackageDemo(
      id: 'fifty_speech_engine',
      name: 'Speech Engine',
      description: 'Text-to-speech and speech recognition',
      icon: Icons.record_voice_over_outlined,
      category: PackageCategory.engines,
    ),
    PackageDemo(
      id: 'fifty_narrative_engine',
      name: 'Narrative Engine',
      description: 'Dialogue queue and sentence processing',
      icon: Icons.chat_outlined,
      category: PackageCategory.engines,
    ),
    PackageDemo(
      id: 'fifty_world_engine',
      name: 'World Engine',
      description: 'Interactive grid-based world rendering',
      icon: Icons.map_outlined,
      category: PackageCategory.engines,
    ),
    PackageDemo(
      id: 'fifty_printing_engine',
      name: 'Printing Engine',
      description: 'PDF generation and printing',
      icon: Icons.print_outlined,
      category: PackageCategory.engines,
    ),

    // Utilities
    PackageDemo(
      id: 'fifty_forms',
      name: 'Fifty Forms',
      description: 'Form validation and field builders',
      icon: Icons.edit_note_outlined,
      category: PackageCategory.utilities,
    ),
    PackageDemo(
      id: 'fifty_connectivity',
      name: 'Fifty Connectivity',
      description: 'Network status monitoring',
      icon: Icons.wifi_outlined,
      category: PackageCategory.utilities,
      isAvailable: false,
    ),
    PackageDemo(
      id: 'fifty_cache',
      name: 'Fifty Cache',
      description: 'Caching and data persistence',
      icon: Icons.cached_outlined,
      category: PackageCategory.utilities,
      isAvailable: false,
    ),
    PackageDemo(
      id: 'fifty_storage',
      name: 'Fifty Storage',
      description: 'Local storage abstraction',
      icon: Icons.storage_outlined,
      category: PackageCategory.utilities,
      isAvailable: false,
    ),
    PackageDemo(
      id: 'fifty_utils',
      name: 'Fifty Utils',
      description: 'Common utilities and extensions',
      icon: Icons.build_outlined,
      category: PackageCategory.utilities,
      isAvailable: false,
    ),

    // Features
    PackageDemo(
      id: 'fifty_achievement_engine',
      name: 'Achievement Engine',
      description: 'Achievements and progression tracking',
      icon: Icons.emoji_events_outlined,
      category: PackageCategory.features,
    ),
    PackageDemo(
      id: 'fifty_skill_tree',
      name: 'Skill Tree',
      description: 'Skill trees and progression systems',
      icon: Icons.account_tree_outlined,
      category: PackageCategory.features,
    ),
  ];

  /// Gets packages filtered by category.
  List<PackageDemo> getPackagesByCategory(PackageCategory category) {
    return allPackages.where((p) => p.category == category).toList();
  }

  /// Gets all available (implemented) packages.
  List<PackageDemo> get availablePackages {
    return allPackages.where((p) => p.isAvailable).toList();
  }

  /// Gets count of available demos.
  int get availableCount => availablePackages.length;

  /// Gets total package count.
  int get totalCount => allPackages.length;
}
