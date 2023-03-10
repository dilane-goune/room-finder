import 'dart:io';

import 'package:room_finder/classes/api_service.dart';
import 'package:room_finder/controllers/app_controller.dart';
import 'package:room_finder/data/constants.dart';
import 'package:room_finder/models/app_version.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> checkForAppUpdate() async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final platform = Platform.isAndroid ? "ANDROID" : "IOS";

    final res = await ApiService.getDio.get(
      "$API_URL/utils/app-update",
      queryParameters: {"currentVersion": currentVersion, "platform": platform},
    );

    if (res.statusCode != 200) return false;

    final appVersion = AppVersion.fromMap(res.data);

    if (appVersion.version.compareTo(currentVersion) == 1) {
      AppController.updateVersion = appVersion;
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<void> downloadAppUpdate() async {
  try {
    final appVersion = AppController.updateVersion;
    if (appVersion == null) return;

    final url = Uri.parse(appVersion.url);

    if (await canLaunchUrl(url)) {
      launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
    }
  } catch (_) {}
}
