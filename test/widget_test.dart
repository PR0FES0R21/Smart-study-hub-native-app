import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_study_hub/main.dart';
import 'package:smart_study_hub/store.dart';
import 'package:smart_study_hub/theme.dart';

void main() {
  for (final size in [const Size(1440, 1000), const Size(390, 844)]) {
    testWidgets('All pages at $size', (t) async {
      t.view.physicalSize = size;
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      final store = DemoStore();
      await t.pumpWidget(HubApp(store: store));
      for (var i = 0; i < 6; i++) {
        store.navigate(i);
        await t.pumpAndSettle();
        expect(t.takeException(), isNull, reason: 'Page $i at $size');
      }
    });
  }
  testWidgets('Mobile text scale 1.5', (t) async {
    t.view.physicalSize = const Size(390, 844);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    final store = DemoStore();
    await t.pumpWidget(
      MaterialApp(
        theme: hubTheme(),
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(390, 844),
            textScaler: TextScaler.linear(1.5),
          ),
          child: HubShell(store: store),
        ),
      ),
    );
    for (var i = 0; i < 6; i++) {
      store.navigate(i);
      await t.pumpAndSettle();
      expect(t.takeException(), isNull, reason: 'Large text page $i');
    }
  });
  testWidgets('Role selector works', (t) async {
    final store = DemoStore();
    await t.pumpWidget(HubApp(store: store));
    await t.tap(find.byKey(const Key('role-selector')));
    await t.pumpAndSettle();
    await t.tap(find.text('Pengawas').last);
    await t.pumpAndSettle();
    expect(store.role, 'Pengawas');
  });
}
