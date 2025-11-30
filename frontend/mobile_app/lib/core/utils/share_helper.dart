import 'package:share_plus/share_plus.dart';

class ShareHelper {
  ShareHelper._();

  static Future<void> shareText(String text) {
    return Share.share(text);
  }
}
