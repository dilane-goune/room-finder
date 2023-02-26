import 'package:get/get_utils/get_utils.dart';
import 'package:room_finder/functions/snackbar_toast.dart';
import 'package:share_plus/share_plus.dart';

import '../data/constants.dart';

Future<void> shareApp() async {
  try {
    final text = "$SHARE_APP_LINK\n\n${'aRealWorldToExerciseYourChances'.tr}";

    Share.share(text);
  } catch (_) {
    showToast("failedToOpenLink".tr);
  }
}
