import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_finder/classes/api_service.dart';
import 'package:room_finder/components/label.dart';
import 'package:room_finder/controllers/loadinding_controller.dart';
import 'package:room_finder/data/enums.dart';
import 'package:room_finder/functions/dialogs_bottom_sheets.dart';
import 'package:room_finder/functions/snackbar_toast.dart';
import 'package:room_finder/functions/utility.dart';
import 'package:room_finder/models/property_booking.dart';
import 'package:room_finder/models/roommate_booking.dart';
import 'package:room_finder/screens/booking/view_property_booking.dart';
import 'package:room_finder/screens/booking/view_roommate_booking.dart';

class _MyBookingsController extends LoadingController {
  final RxList<PropertyBooking> propertyBookings = <PropertyBooking>[].obs;
  final RxList<RoommateBooking> roommateBookings = <RoommateBooking>[].obs;

  late PageController _pageController;

  final _pageIndex = 0.obs;
  @override
  void onInit() {
    _pageController = PageController();
    _fetchData();
    super.onInit();
  }

  Future<void> _fetchData({bool isReFresh = true}) async {
    try {
      isLoading(true);
      hasFetchError(false);
      final query = <String, dynamic>{};

      final res = await ApiService.getDio
          .get("/bookings/my-bookings", queryParameters: query);

      final pData = (res.data['propertyBookings'] as List)
          .map((e) => PropertyBooking.fromMap(e));

      final rData = (res.data['roommateBookings'] as List)
          .map((e) => RoommateBooking.fromMap(e));

      if (isReFresh) {
        propertyBookings.clear();
        roommateBookings.clear();
      }
      propertyBookings.addAll(pData);
      roommateBookings.addAll(rData);
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

class MyBookingsCreen extends StatelessWidget {
  const MyBookingsCreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_MyBookingsController());
    return RefreshIndicator(
      onRefresh: controller._fetchData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Bookings"),
          actions: [
            Obx(() {
              return IconButton(
                onPressed:
                    controller.isLoading.isTrue ? null : controller._fetchData,
                icon: const Icon(Icons.refresh),
              );
            })
          ],
          bottom: PreferredSize(
            preferredSize: const Size(
              double.infinity,
              kBottomNavigationBarHeight - 10,
            ),
            child: Obx(() {
              return BottomNavigationBar(
                onTap: (index) {
                  controller._pageIndex(index);
                  controller._pageController.jumpToPage(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Text(
                      "Property Ads (${controller.propertyBookings.length})",
                      style: TextStyle(
                        fontWeight: controller._pageIndex.value == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    label: 'Property Ad',
                  ),
                  BottomNavigationBarItem(
                    icon: Text(
                      "Roommate Ads (${controller.roommateBookings.length})",
                      style: TextStyle(
                        fontWeight: controller._pageIndex.value == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    label: 'Property Ad',
                  ),
                ],
              );
            }),
          ),
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

          return PageView(
            controller: controller._pageController,
            onPageChanged: controller._pageIndex,
            children: [
              Builder(builder: (context) {
                if (controller.propertyBookings.isEmpty) {
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
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final booking = controller.propertyBookings[index];
                    final title =
                        "${booking.ad.type} in ${booking.ad.address["city"]},"
                        " ${booking.ad.address["location"]}";
                    final subTitle =
                        "${booking.status}, Since ${relativeTimeText(booking.createdAt)}"
                        "\nBy ${booking.poster.fullName}";

                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(booking.ad.images[0]),
                      ),
                      title: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(subTitle),
                      onTap: () {
                        Get.to(
                            () => ViewPropertyBookingScreen(booking: booking));
                      },
                    );
                  },
                  itemCount: controller.propertyBookings.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                );
              }),
              Builder(builder: (context) {
                if (controller.roommateBookings.isEmpty) {
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
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final booking = controller.roommateBookings[index];

                    final title =
                        "${booking.ad.type} in ${booking.ad.address["country"]},"
                        " ${booking.ad.address["location"]}";
                    final subTitle =
                        "Status ${booking.status}, Since ${relativeTimeText(booking.createdAt)}, "
                        " ${booking.ad.budget} AED";

                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(booking.ad.images[0]),
                      ),
                      title: Text(title),
                      subtitle: Text(subTitle),
                      onTap: () {
                        Get.to(
                            () => ViewRoommateBookingScreen(booking: booking));
                      },
                    );
                  },
                  itemCount: controller.roommateBookings.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}

class BookingItemWidget extends StatelessWidget {
  final PropertyBooking booking;
  final void Function()? onTap;
  const BookingItemWidget({super.key, required this.booking, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Card(
          child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "About ad",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Label(label: "Object", value: booking.ad.type),
            Label(label: "Rent type", value: booking.rentType),
            Label(label: "Budget", value: "${booking.budget} AED"),

            const Text(
              "About client",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Label(label: "Name", value: booking.poster.fullName),
            // Label(label: "Email", value: booking.poster.email),
            const Divider(),
            Label(label: "Status", value: booking.status),
            Row(
              children: [
                Text("Booked on", style: textTheme.bodySmall),
                const Spacer(),
                Text(relativeTimeText(booking.createdAt)),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class RoommateBookingWidget extends StatelessWidget {
  final RoommateBooking booking;
  final void Function()? onTap;
  const RoommateBookingWidget({super.key, required this.booking, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Card(
          child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "About ad",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Label(label: "Type", value: "Property"),
            Label(label: "Object", value: booking.ad.type),

            Text(
              "About client${!booking.isMine ? " (me)" : ""}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Label(label: "Name", value: booking.poster.fullName),
            // Label(label: "Email", value: booking.poster.email),
            // Label(label: "Phone", value: booking.poster.phone),
            const Divider(),
            Label(label: "Status", value: booking.status),
            Row(
              children: [
                Text("Booked on", style: textTheme.bodySmall),
                const Spacer(),
                Text(relativeTimeText(booking.createdAt)),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class PropertyBookingWidget extends StatelessWidget {
  final PropertyBooking booking;
  final void Function()? onTap;
  const PropertyBookingWidget({super.key, required this.booking, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Card(
          child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "About ad",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Label(label: "Type", value: "Property"),
            Label(label: "Object", value: booking.ad.type),
            Label(label: "Rent type", value: booking.rentType),
            Label(label: "Status", value: booking.status),
            Text(
              "About client${!booking.isMine ? " (me)" : ""}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Label(label: "Name", value: booking.poster.fullName),
            // Label(label: "Email", value: booking.poster.email),
            // Label(label: "Phone", value: booking.poster.phone),
            const Divider(),
            Label(label: "Status", value: booking.status),
            Row(
              children: [
                Text("Booked on", style: textTheme.bodySmall),
                const Spacer(),
                Text(relativeTimeText(booking.createdAt)),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
