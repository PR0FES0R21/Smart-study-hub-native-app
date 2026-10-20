import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_study_hub/main.dart';
import 'package:smart_study_hub/store.dart';

void main() {
  setUpAll(() async {
    final root = Platform.environment['FLUTTER_ROOT'];
    if (root != null) {
      for (final entry in {
        'Roboto': 'Roboto-Regular.ttf',
        'MaterialIcons': 'MaterialIcons-Regular.otf',
      }.entries) {
        final loader = FontLoader(entry.key);
        loader.addFont(
          Future.value(
            ByteData.sublistView(
              File(
                '$root/bin/cache/artifacts/material_fonts/${entry.value}',
              ).readAsBytesSync(),
            ),
          ),
        );
        await loader.load();
      }
    }
  });
  for (final item in [
    ('desktop', const Size(1440, 1060), 0),
    ('mobile', const Size(390, 1300), 0),
    ('pengawas', const Size(1440, 1060), 3),
  ]) {
    testWidgets('Preview ${item.$1}', (t) async {
      t.view.physicalSize = item.$2;
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.resetPhysicalSize);
      addTearDown(t.view.resetDevicePixelRatio);
      final store = DemoStore();
      if (item.$3 == 3) store.role = 'Pengawas';
      store.page = item.$3;
      await t.pumpWidget(HubApp(store: store));
      await t.pumpAndSettle();
      await expectLater(
        find.byType(HubShell),
        matchesGoldenFile('previews/${item.$1}.png'),
      );
    });
  }
}
