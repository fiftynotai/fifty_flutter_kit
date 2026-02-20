/// Dialogue Demo ViewModel
///
/// Business logic for the dialogue demo feature.
library;

import 'package:get/get.dart';

import '../../../shared/services/narrative_integration_service.dart';
import '../service/demo_dialogues.dart';
import '../service/dialogue_orchestrator.dart';

/// ViewModel for the dialogue demo feature.
///
/// Exposes dialogue and speech state for the view.
class DialogueDemoViewModel extends GetxController {
  DialogueDemoViewModel({
    required DialogueOrchestrator orchestrator,
  }) : _orchestrator = orchestrator;

  final DialogueOrchestrator _orchestrator;
  String _selectedDialogue = 'Introduction';

  /// Worker subscription for orchestrator changes.
  Worker? _orchestratorWorker;

  @override
  void onInit() {
    super.onInit();
    // Listen to orchestrator changes
    _orchestratorWorker = ever(_orchestrator.obs, (_) => update());
  }

  @override
  void onClose() {
    _orchestratorWorker?.dispose();
    super.onClose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────

  DialogueOrchestrator get orchestrator => _orchestrator;
  bool get ttsEnabled => _orchestrator.ttsEnabled;
  bool get autoAdvance => _orchestrator.autoAdvance;
  bool get isPlaying => _orchestrator.isPlaying;
  bool get ttsPlaying => _orchestrator.ttsPlaying;
  bool get sttListening => _orchestrator.sttListening;
  String get displayedText => _orchestrator.displayedText;
  bool get isProcessing => _orchestrator.isProcessing;
  bool get hasMoreSentences => _orchestrator.hasMoreSentences;
  int get currentIndex => _orchestrator.currentIndex;
  int get totalSentences => _orchestrator.totalSentences;
  Sentence? get currentSentence => _orchestrator.currentSentence;
  String get recognizedText => _orchestrator.recognizedText;
  String get selectedDialogue => _selectedDialogue;

  /// Available dialogue options.
  List<String> get dialogueOptions => DemoDialogues.all.keys.toList();

  /// Progress percentage (0.0 - 1.0).
  double get progress {
    if (totalSentences == 0) return 0.0;
    return (currentIndex + 1) / totalSentences;
  }

  /// Progress label.
  String get progressLabel {
    if (totalSentences == 0) return '0/0';
    return '${currentIndex + 1}/$totalSentences';
  }

  /// Current speaker name.
  String get currentSpeaker => currentSentence?.speaker ?? '';

  // ─────────────────────────────────────────────────────────────────────────
  // Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Selects and loads a dialogue.
  void selectDialogue(String name) {
    _selectedDialogue = name;
    final dialogue = DemoDialogues.all[name];
    if (dialogue != null) {
      _orchestrator.loadDialogue(dialogue);
    }
    update();
  }

}
