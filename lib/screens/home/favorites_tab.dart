import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_finder/classes/home_screen_supportable.dart';
import 'package:room_finder/controllers/loadinding_controller.dart';

// ignore: unused_element
class _FavoriteTabController extends LoadingController {}

class FavoriteTab extends StatelessWidget implements HomeScreenSupportable {
  const FavoriteTab({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(_FavoriteTabController());
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: const [
            Text('Empty list'),
          ],
        ),
      ),
    );
  }

  @override
  AppBar get appBar {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Favorites'),
      centerTitle: false,
      elevation: 0,
    );
  }

  @override
  BottomNavigationBarItem get navigationBarItem {
    return BottomNavigationBarItem(
      icon: const Icon(CupertinoIcons.star_fill),
      label: 'favorites'.tr,
    );
  }

  @override
  FloatingActionButton? get floatingActionButton => null;
}
