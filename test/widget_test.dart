import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siap_generus/app.dart';

void main() {
  testWidgets('SIAP-GENERUS login and dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SiapGenerusApp());

    // Verify Login Screen elements
    expect(find.text('SIAP-GENERUS'), findsOneWidget);
    expect(find.text('demo@siapgenerus.app'), findsOneWidget);
    expect(find.text('Generus123!'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    // Tap Login
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Verify Dashboard Screen elements
    expect(find.text('Muhammad Heisal Alfarizi'), findsOneWidget);
    expect(find.text('Total Generus'), findsOneWidget);
    expect(find.text('250'), findsOneWidget);
    expect(find.text('Kelas Aktif'), findsOneWidget);
    expect(find.text('Fitur Utama'), findsOneWidget);

    // Verify 5 bottom navigation tabs
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Materi'), findsOneWidget);
    expect(find.text('Pertemuan'), findsOneWidget);
    expect(find.text('Laporan'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    // Test tab navigation to Materi
    await tester.tap(find.text('Materi'));
    await tester.pumpAndSettle();
    expect(find.text('Dasar Membaca Al-Qur\'an'), findsOneWidget);

    // Test tab navigation to Pertemuan
    await tester.tap(find.text('Pertemuan'));
    await tester.pumpAndSettle();
    expect(find.text('Pembinaan Generus Mingguan'), findsOneWidget);

    // Test tab navigation to Laporan
    await tester.tap(find.text('Laporan'));
    await tester.pumpAndSettle();
    expect(find.text('Pusat Laporan'), findsOneWidget);

    // Test tab navigation to Profil
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Muhammad Dimaz Albintani'), findsOneWidget);
    expect(find.text('Progres Belajar'), findsOneWidget);
  });
}
