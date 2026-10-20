import 'package:flutter/foundation.dart';
import 'domain.dart';

class DemoStore extends ChangeNotifier {
  String role = 'Admin';
  int page = 0;
  final lessons = [
    Lesson(
      id: 'l1',
      title: 'Mengenal jaringan komputer',
      summary:
          'Memahami bagaimana perangkat saling terhubung dan berbagi informasi.',
      complete: true,
    ),
    Lesson(
      id: 'l2',
      title: 'Topologi dan arsitektur jaringan',
      summary:
          'Membandingkan topologi star, mesh, dan bus dalam kehidupan sehari-hari.',
      access: AccessMode.conditional,
      prerequisite: 'l1',
    ),
    Lesson(
      id: 'l3',
      title: 'Merancang jaringan sederhana',
      summary:
          'Menghubungkan kebutuhan pengguna dengan desain jaringan yang tepat.',
      access: AccessMode.conditional,
      prerequisite: 'l2',
    ),
    Lesson(
      id: 'l4',
      title: 'Evaluasi dan refleksi',
      summary: 'Meninjau desain dan alasan pemilihan topologi.',
      access: AccessMode.locked,
    ),
  ];
  final exams = [
    Assessment(
      title: 'Asesmen Tengah Semester',
      subject: 'Matematika · Kelas X',
      essayCount: 5,
    ),
    Assessment(
      title: 'Evaluasi dasar jaringan',
      subject: 'Informatika · X TJKT 1',
      essayCount: 0,
      official: false,
      approved: true,
    ),
    Assessment(
      title: 'Asesmen Bahasa Indonesia',
      subject: 'Bahasa Indonesia · Kelas X',
      essayCount: 0,
      approved: true,
    ),
  ];
  late final room = ExamRoom(
    id: 'Ruang 01',
    candidates: [
      Candidate('01', 'Alya Maharani', 'X TJKT 1', usedSeconds: 2700),
      Candidate('02', 'Bima Prasetya', 'X TKR 1', usedSeconds: 2700),
      Candidate('03', 'Citra Amalia', 'X TJKT 2', usedSeconds: 2400),
      Candidate(
        '04',
        'Daffa Ramadhan',
        'X TSM 1',
        usedSeconds: 1800,
        held: true,
      ),
      Candidate('05', 'Elena Putri', 'X TJKT 1', usedSeconds: 2700),
    ],
  )..open(DateTime(2026, 10, 19, 8));
  final List<String> activity = [
    '08.45 · Daffa dijeda untuk verifikasi kehadiran',
    '08.32 · Citra terhubung kembali (contoh)',
    '08.00 · Pengawas membuka Ruang 01',
  ];
  void changed([String? event]) {
    if (event != null) activity.insert(0, event);
    notifyListeners();
  }

  void navigate(int value) {
    page = value;
    changed();
  }

  void changeRole(String value) {
    role = value;
    page = 0;
    changed();
  }

  bool get teaching => role == 'Guru' || role == 'Koordinator';
  bool get proctor => role == 'Pengawas';
  void advance(int seconds) {
    room.advance(seconds);
    changed('Simulasi waktu maju ${seconds ~/ 60} menit');
  }
}
