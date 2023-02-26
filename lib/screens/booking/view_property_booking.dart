import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_finder/classes/api_service.dart';
import 'package:room_finder/classes/chat_conversation.dart';
import 'package:room_finder/controllers/app_controller.dart';
import 'package:room_finder/controllers/loadinding_controller.dart';
import 'package:room_finder/data/enums.dart';
import 'package:room_finder/functions/dialogs_bottom_sheets.dart';
import 'package:room_finder/functions/snackbar_toast.dart';
import 'package:room_finder/models/property_booking.dart';
import 'package:room_finder/screens/booking/my_bookings.dart';
import 'package:room_finder/screens/booking/pay_rent.dart';
import 'package:room_finder/screens/messages/chat.dart';

class _ViewPropertyBookingScreenController extends LoadingController {
  Future<void> acceptBooking(PropertyBooking booking) async {
    final shouldContinue = await showConfirmDialog(
      "Do you really want to accept this ad",
    );
    if (shouldContinue != true) return;
    try {
      isLoading(true);
      final res = await ApiService.getDio
          .post("/bookings/property-ad/${booking.id}/offer");

      if (res.statusCode == 200) {
        showConfirmDialog(
          "Booking accepted successfully.",
          isAlert: true,
        );
      } else if (res.statusCode == 404) {
        showConfirmDialog(
          "Booking not found",
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

  Future<void> cancelBooking(PropertyBooking booking) async {
    final shouldContinue = await showConfirmDialog(
      "Do you really want to decline this booking",
    );
    if (shouldContinue != true) return;
    try {
      isLoading(true);
      final res = await ApiService.getDio
          .post("/bookings/property-ad/${booking.id}/cancel");

      if (res.statusCode == 200) {
        showConfirmDialog(
          "Booking offered successfully."
          " The client will get your informations"
          " an can now chat with you ",
          isAlert: true,
        );
      } else if (res.statusCode == 404) {
        showConfirmDialog(
          "Booking not found",
          isAlert: true,
        );
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

  void payRent(PropertyBooking booking) {
    Get.to(() => PayrentScreen(type: "PROPERTY", ad: booking));
  }
}

class ViewPropertyBookingScreen extends StatelessWidget {
  const ViewPropertyBookingScreen({super.key, required this.booking});
  final PropertyBooking booking;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_ViewPropertyBookingScreenController());
    return Scaffold(
      appBar: AppBar(title: const Text('View booking')),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  PropertyBookingWidget(booking: booking),
                  const SizedBox(height: 20),
                  if (booking.isMine && !booking.isOffered)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (booking.isMine)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: controller.isLoading.isTrue
                                    ? null
                                    : () => controller.cancelBooking(booking),
                                child: const Text("Decline"),
                              ),
                            ),
                          if (booking.isMine) const SizedBox(width: 20),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: controller.isLoading.isTrue
                                  ? null
                                  : () => controller.acceptBooking(booking),
                              child: const Text("Accept"),
                            ),
                          ),
                          // if (!booking.isMine) const SizedBox(width: 20),
                          if (!booking.isMine)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: controller.isLoading.isTrue
                                    ? null
                                    : () => controller.cancelBooking(booking),
                                child: const Text("Cancel Booking"),
                              ),
                            ),
                        ],
                      ),
                    ),
                  if (booking.isOffered)
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.isTrue
                              ? null
                              : () async {
                                  final conv =
                                      (await ChatConversation.getSavedChat(
                                              ChatConversation
                                                  .createConvsertionKey(
                                                      AppController.me.id,
                                                      booking.ad.poster.id))) ??
                                          ChatConversation.newConversation(
                                              friend: booking.ad.poster);
                                  Get.to(() => ChatScreen(conversation: conv));
                                },
                          child: booking.isMine
                              ? const Text("Chat Client")
                              : const Text("Chat Owner"),
                        ),
                      ),
                    ),
                  if (!booking.isMine && booking.isOffered && !booking.isPayed)
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.isTrue
                              ? null
                              : () => controller.payRent(booking),
                          child: const Text("Pay rent"),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ...booking.ad.images
                      .map(
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
                      )
                      .toList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            if (controller.isLoading.isTrue) const LinearProgressIndicator(),
          ],
        );
      }),
    );
  }
}
