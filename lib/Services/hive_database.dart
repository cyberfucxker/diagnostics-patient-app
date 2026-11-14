import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';



class HiveDatabase{

  String boxName = 'Database';

  static Box? _box;

  static Future openBox() async{
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    _box = await Hive.openBox('boxName');
    return;
  }


  static Future putData({required key,required value}) async{
    await _box?.put(key, value);
    return;
  }

  static Future getDataKey({required key}) async{
    await _box?.get(key);
    return;
  }

}