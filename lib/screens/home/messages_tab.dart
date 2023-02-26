import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'package:room_finder/classes/chat_conversation.dart';
import 'package:room_finder/classes/home_screen_supportable.dart';
import 'package:room_finder/controllers/app_controller.dart';
import 'package:room_finder/screens/messages/chat.dart';
import 'package:room_finder/screens/messages/view_notifications.dart';
// import 'package:room_finder/controllers/loadinding_controller.dart';

class _MessagesTabController extends GetxController {
  final feature = ChatConversation.getAllSavedChats;
}

class MessagesTab extends StatelessWidget implements HomeScreenSupportable {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_MessagesTabController());
    return FutureBuilder(
      builder: (ctx, sp) {
        if (sp.connectionState == ConnectionState.done) {
          if (sp.data!.isEmpty) {
            return const Center(child: Text("No Chat for now"));
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              final conv = sp.data![index];

              return ListTile(
                onTap: () => Get.to(() => ChatScreen(conversation: conv)),
                leading: conv.friend.ppWidget(size: 20, borderColor: false),
                title: Text(conv.friend.fullName),
                subtitle: conv.messages.isEmpty
                    ? null
                    : Text(conv.messages.last.content),
              );
            },
            itemCount: sp.data?.length,
          );
        }

        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
      future: controller.feature(),
    );
  }

  @override
  AppBar get appBar {
    final controller = Get.put(_MessagesTabController());
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Messages'),
      centerTitle: false,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: controller.feature,
          icon: const Icon(Icons.refresh),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 30),
        child: ListTile(
          dense: true,
          title: const Text(
            "Notification",
            style: TextStyle(fontSize: 16),
          ),
          leading: const CircleAvatar(child: Icon(Icons.notifications)),
          trailing: Badge(
            position: BadgePosition.topEnd(top: 2, end: 2),
            showBadge: AppController.instance.haveNewMessage.isTrue ||
                AppController.instance.haveNewNotification.isTrue,
            badgeColor: Colors.blue,
            child: IconButton(
              onPressed: () {
                Get.to(() => const NotificationsScreen());
                AppController.instance.haveNewNotification(false);
              },
              icon: const Icon(Icons.chevron_right),
            ),
          ),
        ),
      ),
    );
  }

  @override
  BottomNavigationBarItem get navigationBarItem {
    return BottomNavigationBarItem(
      icon: Obx(() {
        return Badge(
          showBadge: AppController.instance.haveNewMessage.isTrue ||
              AppController.instance.haveNewNotification.isTrue,
          child: const Icon(CupertinoIcons.chat_bubble_2_fill),
        );
      }),
      label: 'messages'.tr,
    );
  }

  @override
  FloatingActionButton? get floatingActionButton => null;
}
