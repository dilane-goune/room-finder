import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_finder/data/constants.dart';
import 'package:room_finder/functions/snackbar_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class _AboutController extends GetxController {
  Future<void> _handleLinkPress(String link, {LaunchMode? mode}) async {
    try {
      final url = Uri.parse(link);
      if (await canLaunchUrl(url)) {
        launchUrl(url, mode: mode ?? LaunchMode.externalApplication);
      } else {
        showToast("failedToOpenLink".tr);
      }
    } catch (_) {
      showToast("failedToOpenLink".tr);
    }
  }
}

class AboutScreeen extends StatelessWidget {
  const AboutScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_AboutController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'about'.tr,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Roomy Finder',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Get.to(() => PDFView(

                        // ));
                      },
                      // icon: const Icon(Icons.privacy_tip_outlined),
                      child: Text("privacyPolicy".tr),
                    ),
                    TextButton(
                      onPressed: () => controller._handleLinkPress(
                        TERMS_AND_CONDITIONS_LINK,
                        mode: LaunchMode.inAppWebView,
                      ),
                      // icon: const Icon(Icons.article_outlined),
                      child: Text("termsAndConditions".tr),
                    ),
                    TextButton(
                      onPressed: () => controller._handleLinkPress(
                        FEED_BACK_LINK,
                        mode: LaunchMode.inAppWebView,
                      ),
                      // icon: const Icon(Icons.feedback_outlined),
                      child: Text("feedBack".tr),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
