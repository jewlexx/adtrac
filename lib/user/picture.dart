import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

late final String uuid;

Future<void> init() async {
  final prefs = SharedPreferencesAsync();
  final localUuid = await prefs.getString("uuid");

  if (localUuid != null) {
    uuid = localUuid;
  } else {
    uuid = Uuid().v4();
    await prefs.setString("uuid", uuid);
  }
}

String getDefaultPictureUrl({String? uid}) {
  final seed = uid ?? uuid;

  return "https://api.dicebear.com/9.x/thumbs/png?seed=$seed";
}
