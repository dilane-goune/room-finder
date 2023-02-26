import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:room_finder/data/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<Uri> createShareAdLink(dynamic ad) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
    uriPrefix: DYNAMIC_LINK_URL,
    link: Uri.parse('$DYNAMIC_LINK_URL/share-ads?id=${ad.id}'),
    androidParameters: AndroidParameters(packageName: packageInfo.packageName),
    iosParameters: IOSParameters(bundleId: packageInfo.packageName),
    socialMetaTagParameters: SocialMetaTagParameters(
      imageUrl: Uri.parse(FIRE_STORE_LOGO_URL),
      title: "shareAdTitle".tr,
      description: "shareAdDescription".trParams({}),
    ),
  );

  final dynamicLink =
      await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  return dynamicLink.shortUrl;
}
