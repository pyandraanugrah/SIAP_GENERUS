import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siap_generus/app.dart';
import 'package:siap_generus/shared/widgets/app_logo.dart';
import 'package:siap_generus/shared/widgets/default_avatar.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Official Pigeon-based Firebase Core mock for the current firebase_core.
    // Firestore streams stay in loading state (no data emitted), which is fine
    // for these UI tests.
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

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
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Verify Dashboard Screen elements & DefaultAvatar
      expect(find.text('Muhammad Heisal Alfarizi'), findsOneWidget);
      expect(find.byType(DefaultAvatar), findsWidgets);
      expect(find.text('Total Generus'), findsOneWidget);
      expect(find.text('Kelas Aktif'), findsOneWidget);
      expect(find.text('Fitur Utama'), findsOneWidget);

      // Verify 5 bottom navigation tabs
      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Materi'), findsOneWidget);
      expect(find.text('Pertemuan'), findsOneWidget);
      expect(find.text('Laporan'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);

      Future<void> tapTab(String label) async {
        await tester.tap(
          find.descendant(
            of: find.byType(BottomNavigationBar),
            matching: find.text(label),
          ),
        );
        await tester.pump(const Duration(milliseconds: 400));
      }

      int currentTab() {
        return tester
            .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
            .currentIndex;
      }

      // Tab navigation is Firebase-driven, so verify the selected tab index.
      await tapTab('Materi');
      expect(currentTab(), 1);

      await tapTab('Pertemuan');
      expect(currentTab(), 2);

      await tapTab('Laporan');
      expect(currentTab(), 3);

      await tapTab('Profil');
      expect(currentTab(), 4);
      expect(find.text('Muhammad Heisal Alfarizi'), findsWidgets);
      expect(find.text('Progres Belajar'), findsOneWidget);
      expect(find.byType(DefaultAvatar), findsWidgets);

      // Open settings modal on Profil
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Pengaturan Akun'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'Keluar'), findsOneWidget);

      // Tap Keluar -> confirmation dialog must appear
      final logoutTile = find.widgetWithText(ListTile, 'Keluar');
      await tester.ensureVisible(logoutTile);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(logoutTile);
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Konfirmasi Logout'), findsOneWidget);
      expect(
        find.text('Apakah Anda yakin ingin keluar dari akun SIAP-GENERUS?'),
        findsOneWidget,
      );
      expect(find.text('Batal'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Keluar'), findsOneWidget);

      // Test cancel: tap Batal -> dialog closes, still on Profil
      await tester.tap(find.text('Batal'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Konfirmasi Logout'), findsNothing);
      expect(find.text('Muhammad Heisal Alfarizi'), findsWidgets);

      // Open settings modal again
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.ensureVisible(logoutTile);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(logoutTile);
      await tester.pump(const Duration(milliseconds: 400));

      // Test confirm: tap Keluar -> redirects to LoginScreen
      await tester.tap(find.widgetWithText(ElevatedButton, 'Keluar'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(AppLogo), findsOneWidget);

      // Test re-login works
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Muhammad Heisal Alfarizi'), findsOneWidget);
    },
  );
}
