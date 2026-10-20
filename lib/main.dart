import 'package:flutter/material.dart';
import 'store.dart';
import 'theme.dart';
import 'dashboard.dart';
import 'pages.dart';
import 'proctor.dart';

void main() => runApp(HubApp());

class HubApp extends StatelessWidget {
  HubApp({super.key, DemoStore? store}) : store = store ?? DemoStore();
  final DemoStore store;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Smart Study Hub',
    debugShowCheckedModeBanner: false,
    theme: hubTheme(),
    home: HubShell(store: store),
  );
}

const destinations = [
  'Ringkasan',
  'Pembelajaran',
  'Ujian & asesmen',
  'Ruang pengawas',
  'Hasil belajar',
  'Arsip semester',
];
const navIcons = [
  Icons.grid_view_rounded,
  Icons.auto_stories_outlined,
  Icons.assignment_outlined,
  Icons.monitor_heart_outlined,
  Icons.insights_outlined,
  Icons.inventory_2_outlined,
];

class HubShell extends StatelessWidget {
  const HubShell({super.key, required this.store});
  final DemoStore store;
  Widget navigation(BuildContext context) => Container(
    width: 240,
    color: Colors.white,
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(26, 32, 20, 34),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Smart Study',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -.5,
                        ),
                      ),
                      Text(
                        'H U B',
                        style: TextStyle(
                          fontSize: 9,
                          color: muted,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 28, bottom: 16),
            child: Text(
              'WORKSPACE',
              style: TextStyle(
                fontSize: 9,
                color: muted,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...List.generate(
            destinations.length,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
              child: ListTile(
                dense: true,
                selected: store.page == i,
                selectedTileColor: sage,
                selectedColor: green,
                textColor: muted,
                iconColor: muted,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                leading: Icon(navIcons[i], size: 19),
                title: Text(
                  destinations[i],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  store.navigate(i);
                  if (Scaffold.of(context).isDrawerOpen)
                    Navigator.of(context).pop();
                },
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7F3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.spa_outlined, color: green, size: 23),
                  SizedBox(height: 10),
                  Text(
                    'Ruang untuk bertumbuh.',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Pembelajaran yang terarah, kemajuan yang bermakna.',
                    style: TextStyle(fontSize: 10, height: 1.6, color: muted),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 6, 20, 24),
            child: Text(
              'NATIVE PREVIEW / 0.1',
              style: TextStyle(fontSize: 8, color: muted, letterSpacing: 1.5),
            ),
          ),
        ],
      ),
    ),
  );
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) => LayoutBuilder(
      builder: (context, box) {
        final wide = box.maxWidth >= 1050;
        return Scaffold(
          drawer: wide ? null : Drawer(child: Builder(builder: navigation)),
          body: Row(
            children: [
              if (wide) Builder(builder: navigation),
              Expanded(
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(bottom: BorderSide(color: line)),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: wide ? 34 : 16,
                          vertical: 15,
                        ),
                        child: Row(
                          children: [
                            if (!wide)
                              Builder(
                                builder: (c) => IconButton(
                                  tooltip: 'Buka menu',
                                  onPressed: () => Scaffold.of(c).openDrawer(),
                                  icon: const Icon(
                                    Icons.menu_rounded,
                                    size: 21,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wide
                                        ? 'SMK NUSANTARA / TAHUN AJARAN 2026–2027'
                                        : 'Smart Study Hub',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: .6,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    'Semester ganjil',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (wide) ...[
                              const Icon(Icons.circle, size: 6, color: green),
                              const SizedBox(width: 6),
                              const Text(
                                'Data contoh',
                                style: TextStyle(fontSize: 10, color: muted),
                              ),
                              const SizedBox(width: 24),
                            ],
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: line),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  key: const Key('role-selector'),
                                  value: store.role,
                                  isDense: true,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    color: ink,
                                  ),
                                  icon: const Icon(Icons.expand_more, size: 16),
                                  items:
                                      [
                                            'Admin',
                                            'Guru',
                                            'Koordinator',
                                            'Pengawas',
                                            'Siswa',
                                          ]
                                          .map(
                                            (r) => DropdownMenuItem(
                                              value: r,
                                              child: Text(r),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (v) => store.changeRole(v!),
                                ),
                              ),
                            ),
                            if (wide) ...[
                              const SizedBox(width: 14),
                              const CircleAvatar(
                                radius: 17,
                                backgroundColor: lavender,
                                child: Text(
                                  'NP',
                                  style: TextStyle(fontSize: 10, color: ink),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          key: ValueKey('page-${store.page}'),
                          padding: EdgeInsets.all(wide ? 34 : 18),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1280),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (store.page != 0) ...[
                                    Text(
                                      destinations[store.page],
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Semester ganjil 2026/2027 · SMK Nusantara',
                                      style: TextStyle(
                                        color: muted,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                  [
                                    Dashboard(store: store),
                                    LearningPage(store: store),
                                    ExamsPage(store: store),
                                    ProctorPage(store: store),
                                    ResultsPage(store: store),
                                    ArchivePage(store: store),
                                  ][store.page],
                                  const SizedBox(height: 28),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Prototipe interaktif · Data contoh · Perubahan direset saat aplikasi ditutup. Belum terhubung ke server sekolah.',
                                    style: TextStyle(
                                      color: muted,
                                      fontSize: 10,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
