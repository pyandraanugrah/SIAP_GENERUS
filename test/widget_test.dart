import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siap_generus/app.dart';
import 'package:siap_generus/shared/widgets/app_logo.dart';
import 'package:siap_generus/shared/widgets/default_avatar.dart';

void main() {
  testWidgets(
    'SIAP-GENERUS login, dashboard, avatar, and logout confirmation test',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SiapGenerusApp());

      // Verify Login Screen elements & AppLogo
      expect(find.text('SIAP-GENERUS'), findsOneWidget);
      expect(find.byType(AppLogo), findsOneWidget);
      expect(find.text('demo@siapgenerus.app'), findsOneWidget);
      expect(find.text('Generus123!'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);

      // Tap Login
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Verify Dashboard Screen elements & DefaultAvatar
      expect(find.text('Muhammad Heisal Alfarizi'), findsOneWidget);
      expect(find.byType(DefaultAvatar), findsWidgets);
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
      expect(find.byType(DefaultAvatar), findsWidgets);

      // Open settings modal on Profil
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Pengaturan Akun Demo'), findsOneWidget);
      expect(find.text('Logout Demo'), findsOneWidget);

      // Tap Logout Demo -> confirmation dialog must appear
      await tester.tap(find.text('Logout Demo'));
      await tester.pumpAndSettle();
      expect(find.text('Konfirmasi Logout'), findsOneWidget);
      expect(
        find.text(
          'Apakah Anda yakin ingin keluar dari akun demo SIAP-GENERUS?',
        ),
        findsOneWidget,
      );
      expect(find.text('Batal'), findsOneWidget);
      expect(find.text('Keluar'), findsOneWidget);

      // Test cancel: tap Batal -> dialog closes, still on Profil
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();
      expect(find.text('Konfirmasi Logout'), findsNothing);
      expect(find.text('Muhammad Dimaz Albintani'), findsOneWidget);

      // Open settings modal again
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Logout Demo'));
      await tester.pumpAndSettle();

      // Test confirm: tap Keluar -> redirects to LoginScreen
      await tester.tap(find.text('Keluar'));
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(AppLogo), findsOneWidget);

      // Test re-login works
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();
      expect(find.text('Muhammad Heisal Alfarizi'), findsOneWidget);
    },
  );
}
