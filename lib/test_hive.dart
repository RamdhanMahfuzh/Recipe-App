import 'package:hive_ce/hive.dart';

void testHive() {
  final box = Hive.box('bookmarks');

  box.put('test', 'HALO');

  print(box.get('test'));
}
