enum AttemptState { ready, running, paused, exhausted, submitted, terminated }

enum AccessMode { open, locked, conditional }

class Candidate {
  Candidate(
    this.id,
    this.name,
    this.className, {
    this.usedSeconds = 0,
    this.held = false,
  });
  final String id, name, className;
  int usedSeconds, extraSeconds = 0, deviceEpoch = 1;
  bool held;
  String device = 'Android', connection = 'Online';
  AttemptState? finalState;
  final Map<String, String> acknowledgedAnswers = {};
  final List<String> history = [];
  bool get isFinal => finalState != null;
}

/// Deterministic demo only. Production timing and permissions belong on server.
class ExamRoom {
  ExamRoom({
    required this.id,
    required this.candidates,
    this.normalSeconds = 5400,
  });
  final String id;
  final List<Candidate> candidates;
  final int normalSeconds;
  bool running = false;
  DateTime? firstOpenedAt;
  final Set<String> _commands = {};
  void open(DateTime now) {
    firstOpenedAt ??= now;
    running = true;
  }

  void pause() {
    running = false;
  }

  int remaining(Candidate c) =>
      (normalSeconds + c.extraSeconds - c.usedSeconds).clamp(0, 1 << 30);
  int extraConsumed(Candidate c) =>
      (c.usedSeconds - normalSeconds).clamp(0, c.extraSeconds);
  AttemptState state(Candidate c) {
    if (c.finalState != null) return c.finalState!;
    if (firstOpenedAt == null) return AttemptState.ready;
    if (remaining(c) == 0) return AttemptState.exhausted;
    if (!running || c.held) return AttemptState.paused;
    return AttemptState.running;
  }

  void advance(int seconds) {
    if (seconds < 0) throw ArgumentError('Waktu harus positif');
    for (final c in candidates) {
      if (state(c) == AttemptState.running)
        c.usedSeconds += seconds.clamp(0, remaining(c));
    }
  }

  void hold(Candidate c, bool value) {
    if (c.isFinal) throw StateError('Sesi sudah final');
    c.held = value;
    c.history.add(value ? 'Dijeda oleh pengawas' : 'Jeda individu dicabut');
  }

  void grant(Candidate c, int seconds, String commandId) {
    if (c.isFinal) throw StateError('Sesi sudah final');
    if (seconds <= 0) throw ArgumentError('Tambahan waktu harus positif');
    if (!_commands.add('${c.id}:$commandId')) return;
    c.extraSeconds += seconds;
    c.history.add('Tambahan waktu ${seconds ~/ 60} menit');
  }

  void finish(Candidate c, {bool violation = false, String reason = ''}) {
    if (c.isFinal) return;
    if (violation && reason.trim().isEmpty)
      throw ArgumentError('Alasan wajib diisi');
    c.finalState = violation ? AttemptState.terminated : AttemptState.submitted;
    c.history.add(violation ? 'Dihentikan: $reason' : 'Dikumpulkan permanen');
  }

  void transfer(
    Candidate c, {
    required String destination,
    required bool syncCertain,
    bool consent = false,
  }) {
    if (c.isFinal) throw StateError('Sesi sudah final');
    if (!syncCertain && !consent)
      throw StateError('Persetujuan siswa diperlukan');
    c.deviceEpoch++;
    c.device = destination;
    c.history.add(
      'Pindah ke $destination; ${syncCertain ? "sinkron" : "risiko disetujui siswa"}',
    );
  }

  bool acceptAnswer(Candidate c, int epoch, String question, String answer) {
    if (epoch != c.deviceEpoch || state(c) != AttemptState.running)
      return false;
    c.acknowledgedAnswers[question] = answer;
    return true;
  }
}

class Assessment {
  Assessment({
    required this.title,
    required this.subject,
    required this.essayCount,
    this.official = true,
    this.approved = false,
  });
  String title, subject;
  int essayCount;
  final bool official;
  bool approved, shuffleQuestions = true, shuffleOptions = false;
  bool _immediate = false;
  bool get immediate => essayCount == 0 && _immediate;
  void setImmediate(bool value) {
    _immediate = essayCount == 0 && value;
  }

  void setEssays(int count) {
    essayCount = count;
    if (count > 0) _immediate = false;
    approved = false;
  }

  bool graded = false, published = false;
  void publish(String role) {
    if (!graded) throw StateError('Penilaian belum lengkap');
    if (role != (official ? 'Admin' : 'Guru'))
      throw StateError('Peran tidak berwenang');
    published = true;
  }
}

class Lesson {
  Lesson({
    required this.id,
    required this.title,
    required this.summary,
    this.access = AccessMode.open,
    this.prerequisite,
    this.complete = false,
  });
  final String id, title, summary;
  AccessMode access;
  final String? prerequisite;
  bool complete;
  int version = 1;
  final String originalAuthor = 'Nadia Putri';
  String lastEditor = 'Nadia Putri';
  bool accessible(List<Lesson> all) =>
      access == AccessMode.open ||
      (access == AccessMode.conditional &&
          all.any((l) => l.id == prerequisite && l.complete));
  void revise(String editor) {
    version++;
    lastEditor = editor;
  }
}
