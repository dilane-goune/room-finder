import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_finder/classes/api_service.dart';
import 'package:room_finder/components/get_more_button.dart';
import 'package:room_finder/components/label.dart';
import 'package:room_finder/controllers/loadinding_controller.dart';
import 'package:room_finder/data/enums.dart';
import 'package:room_finder/functions/dialogs_bottom_sheets.dart';
import 'package:room_finder/functions/snackbar_toast.dart';
import 'package:room_finder/functions/utility.dart';
import 'package:room_finder/models/property_booking.dart';
import 'package:room_finder/models/deal.dart';
import 'package:room_finder/screens/deals/view_deal.dart';

class _MyDealssController extends LoadingController {
  final RxList<Deal> bookings = <Deal>[].obs;
  @override
  void onInit() {
    _fetchData();
    super.onInit();
  }

  int _skip = 0;

  Future<void> _fetchData({bool isReFresh = true}) async {
    try {
      isLoading(true);
      hasFetchError(false);
      final query = <String, dynamic>{"skip": _skip};

      final res = await ApiService.getDio.get("/deals", queryParameters: query);

      final data = (res.data as List).map((e) => Deal.fromMap(e));

      if (isReFresh) {
        bookings.clear();
        _skip = 0;
      }
      bookings.addAll(data);
    } catch (e, trace) {
      Get.log("$e");
      Get.log("$trace");
      hasFetchError(true);
    } finally {
      isLoading(false);
    }
  }

  Future<void> acceptBooking(PropertyBooking booking) async {
    try {
      isLoading(true);
      final res = await ApiService.getDio.post("/bookings/${booking.id}/offer");
      if (res.statusCode == 200) {
        showConfirmDialog(
          "Booking offered successfully."
          " The client will get your informations"
          " an can now chat with you ",
          isAlert: true,
        );
      } else {
        Get.log(res.statusCode.toString());
        showConfirmDialog(
          "Something when wrong. Please try again later",
          isAlert: true,
        );
      }
    } catch (e) {
      Get.log('$e');
      showGetSnackbar("someThingWentWrong".tr, severity: Severity.error);
    } finally {
      isLoading(false);
    }
  }

  Future<void> declinneBooking(PropertyBooking booking) async {
    try {
      isLoading(true);
      final res =
          await ApiService.getDio.post("/bookings/${booking.id}/decline");
      if (res.statusCode == 200) {
        showConfirmDialog(
          "Booking offered successfully."
          " The client will get your informations"
          " an can now chat with you ",
          isAlert: true,
        );
      } else {
        Get.log(res.statusCode.toString());
        showConfirmDialog(
          "Something when wrong. Please try again later",
          isAlert: true,
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

class MyDealsScreen extends StatelessWidget {
  const MyDealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_MyDealssController());
    return RefreshIndicator(
      onRefresh: controller._fetchData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Deals"),
        ),
        body: Obx(() {
          if (controller.isLoading.isTrue) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (controller.hasFetchError.isTrue) {
            return Center(
              child: Column(
                children: [
                  const Text("Failed to fetch data"),
                  OutlinedButton(
                    onPressed: controller._fetchData,
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          }
          if (controller.bookings.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const Text("No data."),
                  OutlinedButton(
                    onPressed: controller._fetchData,
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              if (index == controller.bookings.length) {
                if (controller.bookings.length.remainder(100) == 0) {
                  return GetMoreButton(
                    getMore: () {
                      controller._skip += 100;
                      controller._fetchData();
                    },
                  );
                } else {
                  return const SizedBox();
                }
              }
              final deal = controller.bookings[index];
              return MydealItemWidget(
                deal: deal,
                onTap: () {
                  Get.to(() => ViewDealScreen(deal: deal));
                },
              );
            },
            itemCount: controller.bookings.length + 1,
          );
        }),
      ),
    );
  }
}

class MydealItemWidget extends StatelessWidget {
  final Deal deal;
  final void Function()? onTap;
  const MydealItemWidget({super.key, required this.deal, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Label(label: "Type", value: deal.adType),
            Label(label: "Object", value: "${deal.ad.type}"),
            Label(label: "Rent type", value: "${deal.ad.rentType}"),
            if (deal.adType == "ROOMMATE")
              Label(label: "Premium", value: deal.ad?.isPremium ? "Yes" : "No"),
            if (deal.adType == "ROOMMATE")
              Label(label: "Budget", value: "${deal.ad.budget} AED")
            else
              Label(label: "Price", value: "${deal.ad.price} AED"),
            Label(
              label: deal.adType == "ROOMMATE" ? "Room owner" : "Landlord",
              value: deal.poster.fullName,
            ),
            const Divider(),
            Label(label: "Paided", value: deal.isPayed ? 'Yes' : "No"),
            Label(label: "Renew on", value: relativeTimeText(deal.createdAt)),
            Label(label: "Ends on", value: relativeTimeText(deal.endDate)),
          ],
        ),
      )),
    );
  }
}
