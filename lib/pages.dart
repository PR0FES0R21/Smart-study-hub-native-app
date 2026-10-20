import 'package:flutter/material.dart';
import 'store.dart';
import 'domain.dart';
import 'theme.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key, required this.store});
  final DemoStore store;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Panel(
        color: sage,
        child: Wrap(
          spacing: 24,
          runSpacing: 20,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(Icons.hub_outlined, size: 44, color: green),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatusPill('ASET KELAS', color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  'Dasar jaringan komputer',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 7),
                const Text(
                  'Informatika · X TJKT 1 · Nadia Putri',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
                const SizedBox(height: 18),
                Text(
                  '${store.lessons.where((l) => l.complete).length} dari 4 materi selesai',
                  style: const TextStyle(fontSize: 11, color: green),
                ),
              ],
            ),
            SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${store.lessons.where((l) => l.complete).length * 25}%',
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w500,
                      color: green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: store.lessons.where((l) => l.complete).length / 4,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(5),
                    backgroundColor: Colors.white,
                    color: green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      const SectionTitle(
        'Jalur pembelajaran',
        subtitle:
            'Tanpa tenggat. Akses dan syarat selesai ditentukan oleh guru.',
      ),
      ...store.lessons.asMap().entries.map((e) {
        final l = e.value, can = l.accessible(store.lessons);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Panel(
            padding: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: l.complete
                            ? sage
                            : can
                            ? blue
                            : const Color(0xFFF3F4F2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        l.complete
                            ? Icons.check_rounded
                            : can
                            ? Icons.article_outlined
                            : Icons.lock_outline,
                        color: l.complete ? green : muted,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LESSON 0${e.key + 1} / V${l.version}',
                            style: const TextStyle(
                              fontSize: 8,
                              letterSpacing: 1.5,
                              color: muted,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            l.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            l.summary,
                            style: const TextStyle(fontSize: 11, color: muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    StatusPill(
                      l.complete
                          ? 'Selesai'
                          : l.access == AccessMode.open
                          ? 'Terbuka'
                          : l.access == AccessMode.locked
                          ? 'Dikunci guru'
                          : can
                          ? 'Prasyarat terpenuhi'
                          : 'Menunggu prasyarat',
                      color: can ? sage : peach,
                      textColor: ink,
                    ),
                    if (l.access == AccessMode.conditional)
                      Text(
                        'Selesaikan lesson ${e.key}',
                        style: const TextStyle(fontSize: 10, color: muted),
                      ),
                    OutlinedButton(
                      onPressed: can || store.teaching
                          ? () => _detail(context, l)
                          : null,
                      child: const Text(
                        'Buka materi',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                    if (store.teaching)
                      TextButton(
                        onPressed: () => _access(context, l),
                        child: const Text('Atur akses'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
      const SizedBox(height: 14),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              'Jejak materi',
              subtitle: 'Kepemilikan sumber dan aset kelas dipisahkan',
            ),
            const Text(
              'Dibuat oleh Nadia Putri · Diserahkan ke X TJKT 1',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              'Guru pengganti dapat memperbarui aset kelas melalui versi baru. Materi privat sumber dan kelas lain tetap mempunyai versinya masing-masing.',
              style: TextStyle(fontSize: 11, color: muted),
            ),
            if (store.teaching) ...[
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () {
                  store.lessons[0].revise('Guru pengganti');
                  store.changed();
                  toast(
                    context,
                    'Versi baru lesson 1 dibuat untuk X TJKT 1. Riwayat pembuat dipertahankan.',
                  );
                },
                icon: const Icon(Icons.history, size: 16),
                label: const Text('Coba pembaruan aset kelas'),
              ),
            ],
          ],
        ),
      ),
    ],
  );
  void _access(BuildContext context, Lesson l) => showDialog<void>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: const Text('Akses materi'),
      children: AccessMode.values
          .map(
            (m) => SimpleDialogOption(
              onPressed: m == AccessMode.conditional && l.prerequisite == null
                  ? null
                  : () {
                      l.access = m;
                      store.changed();
                      Navigator.pop(ctx);
                    },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(
                      m == l.access
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: green,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        m == AccessMode.open
                            ? 'Terbuka'
                            : m == AccessMode.locked
                            ? 'Terkunci'
                            : l.prerequisite == null
                            ? 'Bersyarat (belum ada prasyarat)'
                            : 'Bersyarat: lesson sebelumnya selesai',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
  void _detail(BuildContext context, Lesson l) => showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.title),
      content: SizedBox(
        width: 530,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusPill('Versi ${l.version} · Aset X TJKT 1'),
              const SizedBox(height: 20),
              Text(l.summary),
              const SizedBox(height: 18),
              const Text(
                'Jaringan menghubungkan beberapa perangkat agar dapat bertukar informasi. Desain yang baik dimulai dari kebutuhan: siapa penggunanya, apa yang perlu diakses, dan seberapa luas area yang dilayani.',
              ),
              const SizedBox(height: 18),
              const Panel(
                color: blue,
                padding: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coba pikirkan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Bagaimana Anda menghubungkan 20 komputer di laboratorium agar mudah dipelihara?',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Syarat selesai: tandai selesai membaca. Tidak ada tenggat.',
                style: TextStyle(fontSize: 11, color: muted),
              ),
              Text(
                'Pembuat: ${l.originalAuthor} · Editor: ${l.lastEditor}',
                style: const TextStyle(fontSize: 10, color: muted),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Tutup'),
        ),
        if (store.role == 'Siswa' && l.accessible(store.lessons))
          FilledButton(
            onPressed: l.complete
                ? null
                : () {
                    l.complete = true;
                    store.changed();
                    Navigator.pop(ctx);
                    toast(
                      context,
                      'Materi selesai. Prasyarat berikutnya diperbarui.',
                    );
                  },
            child: Text(l.complete ? 'Sudah selesai' : 'Tandai selesai'),
          ),
      ],
    ),
  );
}

class ExamsPage extends StatelessWidget {
  const ExamsPage({super.key, required this.store});
  final DemoStore store;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Panel(
        color: blue,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.verified_outlined, color: green, size: 23),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.role == 'Koordinator'
                        ? 'Ruang kerja koordinator'
                        : 'Satu paket untuk satu tingkat',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Paket ujian resmi disusun koordinator dan disahkan admin. Pengawas membuka akses ruang sesuai penugasannya.',
                    style: TextStyle(fontSize: 12, color: muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      ...store.exams.map((exam) {
        final control = exam.official
            ? store.role == 'Admin'
            : store.role == 'Guru';
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    StatusPill(
                      exam.official ? 'UJIAN RESMI' : 'KUIS GURU',
                      color: exam.official ? lavender : blue,
                      textColor: ink,
                    ),
                    StatusPill(
                      exam.approved
                          ? 'Siap dilaksanakan'
                          : 'Menunggu persetujuan',
                      color: exam.approved ? sage : peach,
                      textColor: ink,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(exam.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(
                  exam.subject,
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 24,
                  runSpacing: 10,
                  children: [
                    _info(
                      Icons.quiz_outlined,
                      '25 pilihan ganda${exam.essayCount > 0 ? " + ${exam.essayCount} esai" : ""}',
                    ),
                    _info(Icons.schedule, '90 menit'),
                    _info(
                      Icons.calendar_today_outlined,
                      '19 Okt · 08.00–09.30',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    if (control)
                      OutlinedButton.icon(
                        onPressed: () => _settings(context, exam),
                        icon: const Icon(Icons.tune, size: 16),
                        label: const Text('Pengaturan'),
                      ),
                    if (exam.official &&
                        store.role == 'Admin' &&
                        !exam.approved)
                      FilledButton(
                        onPressed: () {
                          exam.approved = true;
                          store.changed();
                          toast(
                            context,
                            'Paket disahkan. Pembukaan ruang tetap dilakukan pengawas.',
                          );
                        },
                        child: const Text('Sahkan paket'),
                      ),
                    if (store.role == 'Koordinator' && exam.official)
                      OutlinedButton(
                        onPressed: () => _package(context, exam),
                        child: const Text('Tinjau paket'),
                      ),
                    if (store.proctor && exam.approved)
                      OutlinedButton(
                        onPressed: () => store.navigate(3),
                        child: const Text('Buka panel pengawas'),
                      ),
                    if (store.role == 'Siswa')
                      OutlinedButton(
                        onPressed: () => toast(
                          context,
                          'Editor ujian siswa belum tersedia. Materi dan simulasi pengawas dapat dicoba.',
                        ),
                        child: const Text('Lihat status sesi'),
                      ),
                    StatusPill(
                      exam.essayCount > 0
                          ? 'Nilai menunggu penilaian & penerbitan'
                          : exam.immediate
                          ? 'Nilai langsung aktif'
                          : 'Nilai diterbitkan manual',
                      color: const Color(0xFFF4F6F3),
                      textColor: muted,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    ],
  );
  Widget _info(IconData icon, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: muted),
      const SizedBox(width: 7),
      Flexible(
        child: Text(label, style: const TextStyle(fontSize: 11, color: muted)),
      ),
    ],
  );
  void _package(BuildContext context, Assessment exam) => showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Paket koordinator'),
      content: const SizedBox(
        width: 440,
        child: Text(
          'Matematika · Tingkat X · Ganjil 2026/2027\n\nSeluruh jurusan menggunakan isi paket yang sama. Penyuntingan dan kolaborasi bank soal belum terhubung pada prototipe ini.',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Tutup'),
        ),
      ],
    ),
  );
  void _settings(BuildContext context, Assessment exam) {
    var questions = exam.shuffleQuestions,
        options = exam.shuffleOptions,
        immediate = exam.immediate,
        essays = exam.essayCount;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: const Text('Pengaturan asesmen'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.title,
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Acak urutan soal'),
                    value: questions,
                    onChanged: (v) => set(() => questions = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Acak pilihan jawaban'),
                    value: options,
                    onChanged: (v) => set(() => options = v),
                  ),
                  const Divider(),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Sertakan 5 soal esai'),
                    subtitle: const Text('Simulasi perubahan komposisi paket'),
                    value: essays > 0,
                    onChanged: (v) => set(() {
                      essays = v ? 5 : 0;
                      if (v) immediate = false;
                    }),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Tampilkan nilai langsung'),
                    subtitle: Text(
                      essays > 0
                          ? 'Nonaktif otomatis karena ada soal esai.'
                          : 'Hanya setelah jawaban dikumpulkan.',
                    ),
                    value: immediate,
                    onChanged: essays > 0
                        ? null
                        : (v) => set(() => immediate = v),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Jadwal contoh: 19 Oktober, 08.00–09.30\nPengawas: Nadia Putri · Ruang 01\nPenyuntingan roster dan jadwal tersedia pada tahap integrasi.',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                exam.shuffleQuestions = questions;
                exam.shuffleOptions = options;
                if (exam.essayCount != essays) exam.setEssays(essays);
                exam.setImmediate(immediate);
                store.changed();
                Navigator.pop(ctx);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key, required this.store});
  final DemoStore store;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SectionTitle(
        'Penilaian & penerbitan',
        subtitle: 'Selesai dinilai belum berarti sudah terlihat oleh siswa.',
      ),
      ...store.exams.map(
        (e) => Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  e.subject,
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    StatusPill(
                      e.graded
                          ? 'Penilaian lengkap'
                          : e.essayCount > 0
                          ? 'Menunggu tinjauan esai'
                          : 'Menunggu simulasi penilaian',
                      color: e.graded ? sage : peach,
                      textColor: ink,
                    ),
                    StatusPill(
                      e.published ? 'Sudah diterbitkan' : 'Belum diterbitkan',
                      color: e.published ? sage : lavender,
                      textColor: ink,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (store.role == 'Siswa')
                  Text(
                    e.published
                        ? 'Nilai contoh: 86 / 100'
                        : 'Nilai belum diterbitkan.',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                else
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (store.role == 'Guru' && !e.graded)
                        OutlinedButton(
                          onPressed: () {
                            e.graded = true;
                            if (e.essayCount == 0 && e.immediate)
                              e.published = true;
                            store.changed();
                            toast(
                              context,
                              'Simulasi penilaian selesai. ${e.published ? "Hasil diterbitkan otomatis." : "Hasil menunggu penerbitan."}',
                            );
                          },
                          child: const Text('Simulasikan penilaian selesai'),
                        ),
                      if (store.role == (e.official ? 'Admin' : 'Guru'))
                        FilledButton(
                          onPressed: e.graded && !e.published
                              ? () {
                                  e.publish(store.role);
                                  store.changed();
                                  toast(context, 'Hasil diterbitkan.');
                                }
                              : null,
                          child: const Text('Terbitkan hasil'),
                        ),
                    ],
                  ),
                const SizedBox(height: 12),
                Text(
                  'Penerbit hasil: ${e.official ? "admin sekolah" : "guru pengendali"}. ${e.essayCount > 0 ? "Esai selalu menunggu penerbitan manual." : "Pilihan ganda mengikuti pengaturan nilai langsung."}',
                  style: const TextStyle(fontSize: 11, color: muted),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key, required this.store});
  final DemoStore store;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Panel(
        color: blue,
        child: Text(
          'Semester baru memulai materi dan progres dari nol. Riwayat lama tetap tersedia dengan konteks kelas, guru, dan versi materi saat itu.',
        ),
      ),
      const SizedBox(height: 24),
      ...['Genap 2025/2026', 'Ganjil 2025/2026'].map(
        (semester) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatusPill(
                  'ARSIP · HANYA BACA',
                  color: lavender,
                  textColor: ink,
                ),
                const SizedBox(height: 14),
                Text(semester, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                const Text(
                  'Kelas IX A · 12 mata pelajaran · Riwayat contoh',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Riwayat $semester'),
                      content: const Text(
                        'Matematika: 84\nBahasa Indonesia: 88\nInformatika: 91\n\nPenilai: Nadia Putri\nStatus: diterbitkan\n\nRiwayat ini tidak memengaruhi progres semester aktif.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  ),
                  child: const Text('Lihat riwayat'),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
