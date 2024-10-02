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
  if (uid == null) {
    return "https://api.dicebear.com/8.x/pixel-art/png?seed=$uuid";
  } else {
    return "https://api.dicebear.com/8.x/pixel-art/png?seed=$uid";
  }
}
