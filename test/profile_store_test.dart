import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siap_generus/data/dummy_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loads persisted teacher name and avatar path', () async {
    SharedPreferences.setMockInitialValues({
      'demo_teacher_name': 'Ust. Demo Tersimpan',
      'demo_avatar_path': '/data/user/0/demo/avatar.jpg',
    });

    final store = DummyDataStore.instance;
    await store.loadProfileFromStorage();

    expect(store.teacherName, 'Ust. Demo Tersimpan');
    expect(store.avatarPath, '/data/user/0/demo/avatar.jpg');
  });

  test('persists updated teacher name and avatar path', () async {
    final store = DummyDataStore.instance;

    await store.updateTeacherProfile(name: 'Ust. Baru');
    await store.updateAvatarPath('/data/user/0/demo/avatar_new.jpg');

    final prefs = await SharedPreferences.getInstance();

    expect(prefs.getString('demo_teacher_name'), 'Ust. Baru');
    expect(
      prefs.getString('demo_avatar_path'),
      '/data/user/0/demo/avatar_new.jpg',
    );
  });
}
