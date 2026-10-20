import 'package:flutter/material.dart';
import 'store.dart';
import 'theme.dart';
import 'charts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.store});
  final DemoStore store;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool month = false;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 24,
        runSpacing: 16,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SENIN, 19 OKTOBER 2026',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.6,
                  color: muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.store.role == 'Siswa'
                    ? 'Setiap langkah berarti.'
                    : 'Selamat pagi, ${widget.store.role}.',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              const Text(
                'Lihat kemajuan, temukan peluang, dan rencanakan langkah berikutnya.',
                style: TextStyle(fontSize: 12, color: muted),
              ),
            ],
          ),
          OutlinedButton.icon(
            onPressed: () =>
                widget.store.navigate(widget.store.proctor ? 3 : 2),
            icon: const Icon(Icons.arrow_outward, size: 16),
            label: Text(
              widget.store.proctor ? 'Buka ruang ujian' : 'Lihat agenda ujian',
            ),
          ),
        ],
      ),
      const SizedBox(height: 28),
      LayoutBuilder(
        builder: (context, c) {
          final cols = c.maxWidth > 850
              ? 4
              : c.maxWidth > 330
              ? 2
              : 1;
          final w = (c.maxWidth - (cols - 1) * 16) / cols;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children:
                [
                      _metric(
                        'Siswa aktif',
                        '1.248',
                        'di 36 rombongan belajar',
                        Icons.people_outline,
                        sage,
                        '+24 bulan ini',
                      ),
                      _metric(
                        'Progres pembelajaran',
                        '82%',
                        'rata-rata materi terselesaikan',
                        Icons.auto_graph_outlined,
                        blue,
                        '+8,2%',
                      ),
                      _metric(
                        'Asesmen aktif',
                        '12',
                        '3 ujian berlangsung hari ini',
                        Icons.fact_check_outlined,
                        lavender,
                        'Lihat asesmen',
                      ),
                      _metric(
                        'Perlu ditinjau',
                        '05',
                        'esai menunggu penilaian',
                        Icons.rate_review_outlined,
                        peach,
                        'Tinjau hasil',
                      ),
                    ]
                    .map(
                      (x) => SizedBox(
                        width: w,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 244),
                          child: x,
                        ),
                      ),
                    )
                    .toList(),
          );
        },
      ),
      const SizedBox(height: 24),
      LayoutBuilder(
        builder: (context, c) {
          final first = Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                  'Pertumbuhan belajar',
                  subtitle: 'Rata-rata ketuntasan materi · data ilustrasi',
                  action: PopupMenuButton<bool>(
                    tooltip: 'Periode grafik',
                    onSelected: (v) => setState(() => month = v),
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: false, child: Text('7 hari')),
                      const PopupMenuItem(value: true, child: Text('4 minggu')),
                    ],
                    child: StatusPill(
                      month ? '4 minggu' : '7 hari',
                      color: const Color(0xFFF5F7F5),
                      textColor: muted,
                    ),
                  ),
                ),
                const Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  runSpacing: 8,
                  children: [
                    Text(
                      '82',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                        color: ink,
                        letterSpacing: -1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 7),
                      child: Text(
                        '%',
                        style: TextStyle(fontSize: 16, color: muted),
                      ),
                    ),
                    SizedBox(width: 14),
                    Padding(
                      padding: EdgeInsets.only(bottom: 9),
                      child: StatusPill('+8,2% dari periode lalu'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                LearningChart(month: month),
              ],
            ),
          );
          final second = Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  'Ritme pembelajaran',
                  subtitle: 'Sebaran progres siswa · ilustrasi',
                ),
                const Center(child: RingChart()),
                const SizedBox(height: 24),
                ...[
                  (const Color(0xFF8EB39B), 'Tuntas', '68%'),
                  (const Color(0xFFB9C9E4), 'Sedang berjalan', '24%'),
                  (const Color(0xFFE4DDEE), 'Belum mulai', '8%'),
                ].map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: r.$1,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            r.$2,
                            style: const TextStyle(fontSize: 11, color: muted),
                          ),
                        ),
                        Text(
                          r.$3,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
          if (c.maxWidth < 750)
            return Column(
              children: [first, const SizedBox(height: 20), second],
            );
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: first),
              const SizedBox(width: 24),
              Expanded(flex: 4, child: second),
            ],
          );
        },
      ),
      const SizedBox(height: 24),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              'Agenda terdekat',
              subtitle: 'Kegiatan akademik yang perlu Anda perhatikan',
              action: TextButton(
                onPressed: () => widget.store.navigate(2),
                child: const Text(
                  'Lihat semua',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ),
            ...List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 44 * MediaQuery.textScalerOf(context).scale(1),
                      height: 48 * MediaQuery.textScalerOf(context).scale(1),
                      decoration: BoxDecoration(
                        color: [sage, blue, lavender][i],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ['19', '20', '22'][i],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            'OKT',
                            style: TextStyle(fontSize: 8, color: muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            [
                              'Asesmen Tengah Semester',
                              'Evaluasi dasar jaringan',
                              'Tinjauan materi semester',
                            ][i],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            [
                              'Matematika · Kelas X · 08.00–09.30',
                              'Informatika · X TJKT 1 · 10.00–11.00',
                              'Guru & koordinator · 13.00–14.00',
                            ][i],
                            style: const TextStyle(fontSize: 10, color: muted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Buka agenda',
                      onPressed: () => widget.store.navigate(i == 2 ? 1 : 2),
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: muted,
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
  Widget _metric(
    String title,
    String value,
    String caption,
    IconData icon,
    Color bg,
    String foot,
  ) => Panel(
    padding: 19,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: ink),
            ),
            const Spacer(),
            const Icon(Icons.north_east, size: 13, color: muted),
          ],
        ),
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(fontSize: 11, color: muted)),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            letterSpacing: -1,
            color: ink,
          ),
        ),
        const SizedBox(height: 4),
        Text(caption, style: const TextStyle(fontSize: 10, color: muted)),
        const SizedBox(height: 16),
        Text(foot, style: const TextStyle(fontSize: 10, color: green)),
      ],
    ),
  );
}
