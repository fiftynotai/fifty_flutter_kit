/// **Storage Interface for BGM Playlist**
///
/// Abstracts where the BGM playlist and index are stored — could be memory,
/// shared preferences, file, etc.
abstract class BgmStorage {
  List<String>? getPlaylist();
  int? getIndex();
  void save(List<String> playlist, int index);
  void clear(); // Optional, for reset logic
}
