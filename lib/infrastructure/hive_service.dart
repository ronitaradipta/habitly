import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService._();

  static final HiveService _instance = HiveService._();

  static HiveService get instance => _instance;

  final Map<String, Box> _boxes = {};

  Future<Box> getBox(String boxName) async {
    if (_boxes.containsKey(boxName)) {
      return _boxes[boxName]!;
    }

    final box = await Hive.openBox(boxName);
    _boxes[boxName] = box;
    return box;
  }

  Future<void> closeAll() async {
    await Future.wait(_boxes.values.map((box) => box.close()));
    _boxes.clear();
  }
}
