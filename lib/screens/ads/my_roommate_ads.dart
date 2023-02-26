import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:room_finder/classes/api_service.dart';
import 'package:room_finder/components/ads.dart';
import 'package:room_finder/components/get_more_button.dart';
import 'package:room_finder/controllers/loadinding_controller.dart';
import 'package:room_finder/models/roommate_ad.dart';
import 'package:room_finder/screens/ads/roomate_ad/view_ad.dart';

class _MyRoommateAdsController extends LoadingController {
  final RxList<RoommateAd> ads = <RoommateAd>[].obs;
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
      final query = {"ship": _skip};

      final res = await ApiService.getDio.get(
        "/ads/roommate-ad/my-ads",
        queryParameters: query,
      );

      final data = (res.data as List).map((e) => RoommateAd.fromMap(e));

      if (isReFresh) {
        ads.clear();
        _skip = 0;
      }
      ads.addAll(data);
    } catch (e, trace) {
      Get.log("$e");
      Get.log("$trace");
      hasFetchError(true);
    } finally {
      isLoading(false);
    }
  }
}

class MyRoommateAdsScreen extends StatelessWidget {
  const MyRoommateAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_MyRoommateAdsController());
    return RefreshIndicator(
      onRefresh: controller._fetchData,
      child: Scaffold(
        appBar: AppBar(title: Text("My Ads".tr)),
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
          if (controller.ads.isEmpty) {
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
              if (index == controller.ads.length) {
                if (controller.ads.length.remainder(100) == 0) {
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
              final ad = controller.ads[index];
              return RoommateAdWidget(
                ad: ad,
                onTap: () => Get.to(() => ViewRoommateAdScreen(ad: ad)),
              );
            },
            itemCount: controller.ads.length + 1,
          );
        }),
      ),
    );
  }
}