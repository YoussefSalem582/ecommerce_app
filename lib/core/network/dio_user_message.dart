/// Strips Dio's generic connection-error boilerplate for display in UI.
///
/// Leaves API error bodies (e.g. JSON `message`) unchanged when no
/// boilerplate is present.
String sanitizeDioUserFacingMessage(String raw) {
  var s = raw.trim();

  final hostLookup = RegExp(r"Failed host lookup:\s*'([^']*)'");
  final hostMatch = hostLookup.firstMatch(s);
  if (hostMatch != null) {
    final host = hostMatch.group(1) ?? 'host';
    return "Can't reach $host (DNS / offline)";
  }

  if (s.contains('The request connection took longer than') &&
      s.contains('and it was aborted')) {
    return 'Connection timed out';
  }

  const verboseTail =
      ' This indicates an error which most likely cannot be '
      'solved by the library.';
  if (s.contains(verboseTail)) {
    s = s.replaceFirst(verboseTail, '').trim();
  }
  const verboseHead = 'The connection errored: ';
  if (s.startsWith(verboseHead)) {
    s = s.substring(verboseHead.length).trim();
  }
  return s.isEmpty ? 'Network error' : s;
}
