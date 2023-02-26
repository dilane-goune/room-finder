import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:room_finder/classes/api_service.dart';
import 'package:room_finder/components/ads.dart';
import 'package:room_finder/components/get_more_button.dart';
import 'package:room_finder/controllers/loadinding_controller.dart';
import 'package:room_finder/models/property_ad.dart';
import 'package:room_finder/screens/ads/property_ad/view_ad.dart';

class _FindPropertiesController extends LoadingController {
  final String? location;
  final String? city;

  _FindPropertiesController({this.location, this.city});

  final RxList<PropertyAd> ads = <PropertyAd>[].obs;
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

      if (location != null) query["location"] = location;
      if (city != null) query["city"] = city;

      final res = await ApiService.getDio.get(
        "/ads/property-ad/available",
        queryParameters: query,
      );

      final data = (res.data as List).map((e) => PropertyAd.fromMap(e));

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

class FindPropertiesAdsScreen extends StatelessWidget {
  const FindPropertiesAdsScreen({super.key, this.location, this.city});
  final String? location;
  final String? city;

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(_FindPropertiesController(location: location, city: city));
    return RefreshIndicator(
      onRefresh: controller._fetchData,
      child: Scaffold(
        appBar: AppBar(
          title: Text("properpyAds".tr),
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
              return PropertyAdWidget(
                ad: ad,
                onTap: () => Get.to(() => ViewPropertyAd(ad: ad)),
              );
            },
            itemCount: controller.ads.length + 1,
          );
        }),
      ),
    );
  }
}