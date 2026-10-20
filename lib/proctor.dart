import 'package:flutter/material.dart';
import 'store.dart';
import 'domain.dart';
import 'theme.dart';

class ProctorPage extends StatelessWidget {
  const ProctorPage({super.key, required this.store});
  final DemoStore store;
  String time(int seconds) =>
      '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  String status(Candidate c) => switch (store.room.state(c)) {
    AttemptState.ready => 'Menunggu dibuka',
    AttemptState.running => 'Mengerjakan',
    AttemptState.paused => 'Dijeda',
    AttemptState.exhausted => 'Waktu habis',
    AttemptState.submitted => 'Dikumpulkan',
    AttemptState.terminated => 'Dihentikan',
  };
  @override
  Widget build(BuildContext context) {
    final room = store.room;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Panel(
          color: sage,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  StatusPill(
                    room.running ? 'RUANG DIBUKA' : 'RUANG DIJEDA',
                    color: Colors.white,
                  ),
                  const Text(
                    'SIMULASI PENGAWAS',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.5,
                      color: green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Ruang 01 · Matematika',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Tingkat X, lintas jurusan · 5 peserta contoh · Pengawas Nadia Putri',
                style: TextStyle(fontSize: 12, color: muted),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    onPressed: store.proctor
                        ? () {
                            room.running
                                ? room.pause()
                                : room.open(DateTime.now());
                            store.changed(
                              room.running
                                  ? 'Ruang dilanjutkan'
                                  : 'Ruang dijeda',
                            );
                          }
                        : null,
                    icon: Icon(
                      room.running ? Icons.pause : Icons.play_arrow,
                      size: 18,
                    ),
                    label: Text(
                      room.running ? 'Jeda seluruh ruang' : 'Lanjutkan ruang',
                    ),
                  ),
                  OutlinedButton(
                    onPressed: store.proctor ? () => _extraAll(context) : null,
                    child: const Text('+ Waktu seluruh ruang'),
                  ),
                  OutlinedButton(
                    onPressed: store.proctor ? () => _endAll(context) : null,
                    child: const Text('Akhiri ruang'),
                  ),
                ],
              ),
              if (!store.proctor) ...[
                const SizedBox(height: 12),
                const Text(
                  'Pilih peran Pengawas untuk mencoba kendali ruang ini.',
                  style: TextStyle(fontSize: 11, color: green),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        Panel(
          padding: 16,
          child: Wrap(
            spacing: 18,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(Icons.science_outlined, size: 18, color: muted),
              const Text(
                'Jam demo bergerak melalui tombol ini.',
                style: TextStyle(fontSize: 11, color: muted),
              ),
              OutlinedButton(
                onPressed: store.proctor ? () => store.advance(900) : null,
                child: const Text('Majukan 15 menit'),
              ),
              Text(
                'Durasi normal ${room.normalSeconds ~/ 60} menit',
                style: const TextStyle(fontSize: 11, color: muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle(
          'Peserta ruang',
          subtitle:
              'Jeda ruang dan individu terpisah. Waktu habis belum berarti dikumpulkan.',
        ),
        ...room.candidates.map(
          (c) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Panel(
              padding: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: c.held ? peach : blue,
                        child: Text(
                          c.name.split(' ').map((n) => n[0]).take(2).join(),
                          style: const TextStyle(fontSize: 12, color: ink),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${c.className} · ${c.device} · ${c.connection}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            time(room.remaining(c)),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                          const Text(
                            'sisa waktu',
                            style: TextStyle(fontSize: 9, color: muted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 9,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      StatusPill(
                        status(c),
                        color: c.isFinal
                            ? lavender
                            : room.state(c) == AttemptState.running
                            ? sage
                            : peach,
                        textColor: ink,
                      ),
                      if (c.held)
                        const StatusPill(
                          'Jeda individu',
                          color: peach,
                          textColor: ink,
                        ),
                      if (c.extraSeconds > 0)
                        StatusPill(
                          '+${c.extraSeconds ~/ 60} menit · terpakai ${room.extraConsumed(c) ~/ 60}',
                          color: blue,
                          textColor: ink,
                        ),
                      if (store.proctor && !c.isFinal) ...[
                        TextButton(
                          onPressed: () {
                            room.hold(c, !c.held);
                            store.changed(
                              '${c.name}: ${c.held ? "jeda" : "lanjut"} individu',
                            );
                          },
                          child: Text(
                            c.held ? 'Lanjutkan siswa' : 'Jeda siswa',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            room.grant(
                              c,
                              600,
                              'grant-${DateTime.now().microsecondsSinceEpoch}',
                            );
                            store.changed('${c.name}: tambahan 10 menit');
                          },
                          child: const Text('+10 menit'),
                        ),
                        PopupMenuButton<String>(
                          tooltip: 'Tindakan peserta',
                          onSelected: (v) {
                            if (v == 'device')
                              _transfer(context, c);
                            else if (v == 'finish')
                              _finish(context, c, false);
                            else if (v == 'terminate')
                              _finish(context, c, true);
                            else
                              _history(context, c);
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: 'device',
                              child: Text('Pindah perangkat'),
                            ),
                            const PopupMenuItem(
                              value: 'history',
                              child: Text('Riwayat tindakan'),
                            ),
                            const PopupMenuItem(
                              value: 'finish',
                              child: Text('Akhiri permanen'),
                            ),
                            const PopupMenuItem(
                              value: 'terminate',
                              child: Text('Hentikan karena pelanggaran'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                'Aktivitas ruang',
                subtitle:
                    'Contoh aktivitas untuk ditinjau. Indikasi bukan vonis pelanggaran.',
              ),
              ...store.activity
                  .take(8)
                  .map(
                    (a) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(Icons.circle, size: 6, color: green),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              a,
                              style: const TextStyle(
                                fontSize: 11,
                                color: muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  void _extraAll(BuildContext context) {
    final command = 'all-${DateTime.now().microsecondsSinceEpoch}';
    for (final c in store.room.candidates.where((c) => !c.isFinal)) {
      store.room.grant(c, 600, command);
    }
    store.changed('Tambahan 10 menit untuk peserta yang belum final');
    toast(context, 'Tambahan diberikan. Jeda individu tetap berlaku.');
  }

  void _endAll(BuildContext context) => showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Akhiri seluruh ruang?'),
      content: const Text(
        'Seluruh peserta dikumpulkan permanen, termasuk jawaban kosong. Tombol lanjut tidak dapat membuka kembali sesi final.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            for (final c in store.room.candidates) {
              store.room.finish(c);
            }
            store.changed('Seluruh peserta diakhiri permanen');
            Navigator.pop(ctx);
          },
          child: const Text('Akhiri permanen'),
        ),
      ],
    ),
  );
  void _finish(BuildContext context, Candidate c, bool violation) {
    var reason = '';
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: Text(violation ? 'Hentikan peserta?' : 'Akhiri pengerjaan?'),
          content: SizedBox(
            width: 430,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${c.name}\n\nTindakan ini permanen. Jawaban yang sudah ada dipertahankan. ${violation ? "Penghentian tidak otomatis memberi nilai nol." : "Soal kosong tetap diperbolehkan."}',
                ),
                if (violation) ...[
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Alasan berdasarkan tinjauan',
                    ),
                    onChanged: (v) => set(() => reason = v),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: violation && reason.trim().isEmpty
                  ? null
                  : () {
                      store.room.finish(
                        c,
                        violation: violation,
                        reason: reason,
                      );
                      store.changed(
                        '${c.name}: ${violation ? "dihentikan berdasarkan tinjauan" : "dikumpulkan"}',
                      );
                      Navigator.pop(ctx);
                    },
              child: const Text('Konfirmasi'),
            ),
          ],
        ),
      ),
    );
  }

  void _history(BuildContext context, Candidate c) => showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Riwayat ${c.name}'),
      content: Text(
        c.history.isEmpty
            ? 'Belum ada tindakan pada sesi demo ini.'
            : c.history.join('\n\n'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Tutup'),
        ),
      ],
    ),
  );
  void _transfer(BuildContext context, Candidate c) {
    var consent = false;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: const Text('Perpindahan perangkat'),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${c.name}\n${c.device} → Perangkat pengganti'),
                  const SizedBox(height: 16),
                  const Panel(
                    color: peach,
                    padding: 16,
                    child: Text(
                      'Simulasi: perangkat lama tidak dapat disinkronkan. Jumlah jawaban lokal yang belum tersimpan belum dapat dipastikan. Jawaban yang sudah diterima server tetap dipertahankan.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: consent,
                    onChanged: (v) => set(() => consent = v!),
                    title: const Text(
                      'Saya telah menjelaskan risiko dan siswa menyetujui perpindahan.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const Text(
                    'Perangkat lama dicabut hak menulisnya. Jawaban lama tidak otomatis menimpa jawaban baru.',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batalkan'),
            ),
            FilledButton(
              onPressed: consent
                  ? () {
                      store.room.transfer(
                        c,
                        destination: 'Perangkat pengganti',
                        syncCertain: false,
                        consent: true,
                      );
                      store.changed(
                        '${c.name}: pindah perangkat dengan persetujuan',
                      );
                      Navigator.pop(ctx);
                    }
                  : null,
              child: const Text('Setujui perpindahan'),
            ),
          ],
        ),
      ),
    );
  }
}
