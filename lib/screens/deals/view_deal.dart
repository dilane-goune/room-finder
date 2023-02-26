import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:room_finder/classes/api_service.dart';
import 'package:room_finder/controllers/loadinding_controller.dart';
import 'package:room_finder/data/enums.dart';
import 'package:room_finder/functions/dialogs_bottom_sheets.dart';
import 'package:room_finder/functions/snackbar_toast.dart';
import 'package:room_finder/functions/utility.dart';
import 'package:room_finder/models/deal.dart';
import 'package:room_finder/screens/ads/property_ad/view_ad.dart';
import 'package:room_finder/screens/ads/roomate_ad/view_ad.dart';
import 'package:room_finder/screens/deals/my_deals.dart';
import 'package:room_finder/screens/user/view_user.dart';

import 'package:room_finder/components/label.dart';

class _ViewDealScreenController extends LoadingController {
  Future<void> payDeal(Deal deal) async {
    try {
      isLoading(true);
    } catch (e) {
      Get.log('$e');
      showGetSnackbar("someThingWentWrong".tr, severity: Severity.error);
    } finally {
      isLoading(false);
    }
  }

  Future<void> endDeal(Deal deal) async {
    final isSure = await showConfirmDialog(
      "You're about to end your deal for this ad."
      " Make sure you are conscient of what you wanna do",
    );

    if (isSure != true) {
      return;
    }

    try {
      isLoading(true);
      final res = await ApiService.getDio.post("/desls/${deal.id}/end");
      if (res.statusCode == 200) {
        showConfirmDialog("Deal ended successfully", isAlert: true);
      } else {
        Get.log(res.statusCode.toString());
        showGetSnackbar(
          "Something when wrong. Please try again later",
          severity: Severity.error,
        );
      }
    } catch (e) {
      Get.log('$e');
      showGetSnackbar("someThingWentWrong".tr, severity: Severity.error);
    } finally {
      isLoading(false);
    }
  }
}

class ViewDealScreen extends StatelessWidget {
  const ViewDealScreen({super.key, required this.deal});
  final Deal deal;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_ViewDealScreenController());
    return Scaffold(
      appBar: AppBar(title: const Text('View deal')),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "About AD",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              MydealItemWidget(deal: deal),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading.isTrue
                          ? null
                          : () {
                              if (deal.adType == "PROPERTY") {
                                Get.to(() => ViewPropertyAd(ad: deal.ad));
                              } else {
                                Get.to(() => ViewRoommateAdScreen(ad: deal.ad));
                              }
                            },
                      child: Text("View ${deal.adType}" == "ROOMMATE"
                          ? "View room"
                          : "View property"),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading.isTrue
                          ? null
                          : () => Get.to(() => ViewUser(user: deal.poster)),
                      child: Text("View ${deal.adType}" == "ROOMMATE"
                          ? "Room owner"
                          : "Landlord"),
                    ),
                  ),
                ],
              ),
              const Divider(),
              const Text(
                "About the deal",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Label(
                label: "Status",
                value: deal.isPayed ? "Paied" : "Paiement required",
              ),
              if (!deal.isPayed)
                Label(
                  label: "Payment date limit",
                  value: Jiffy(deal.endDate).yMMMEdjm,
                ),
              Label(label: "Renew on", value: relativeTimeText(deal.createdAt)),
              Label(label: "Ends on", value: relativeTimeText(deal.endDate)),
              const Text(
                "Actions",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: controller.isLoading.isTrue
                          ? null
                          : () => controller.endDeal(deal),
                      child: const Text("End deal"),
                    ),
                  ),
                  if (!deal.isPayed) const SizedBox(width: 20),
                  if (!deal.isPayed)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: controller.isLoading.isTrue
                            ? null
                            : () => controller.payDeal(deal),
                        child: const Text("Make payment now"),
                      ),
                    ),
                ],
              ),
              const Divider(height: 20),
              const Text(
                "Images",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              ...(deal.ad.images as List<String>).map(
                (e) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      e,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, e, trace) {
                        return const SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
