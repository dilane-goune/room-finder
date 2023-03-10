import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:room_finder/classes/chat_conversation.dart';
import 'package:room_finder/components/label.dart';
import 'package:room_finder/controllers/app_controller.dart';
import 'package:room_finder/functions/utility.dart';
import 'package:room_finder/models/user.dart';
import 'package:room_finder/screens/messages/chat.dart';

class ViewUser extends StatelessWidget {
  const ViewUser({super.key, required this.user});
  final User user;

  void _viewImage(String source) {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.network(source),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.isMe ? "My Account" : user.fullName),
        actions: [
          if (user.isMe)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _viewImage(user.profilePicture),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    user.profilePicture,
                    height: MediaQuery.of(context).size.width * 0.5,
                    errorBuilder: (ctx, e, trace) {
                      Get.log('$trace');
                      return const Card(
                        child: SizedBox(
                          height: 200,
                          child: Icon(Icons.person, size: 100),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (user.isMe)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Label(label: "Full name", value: user.firstName),
                      Label(label: "Email", value: user.email),
                      Label(label: "Phone", value: user.phone),
                      Label(label: "gender", value: user.gender),
                      Label(label: "Country", value: user.country),
                      Label(label: "Who i am", value: user.type),
                      Label(
                        label: "Premium",
                        value: user.isPremium ? "Yes" : "No",
                      ),
                      Label(
                        label: "Member since",
                        value: relativeTimeText(user.createdAt),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              if (!user.isMe)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final conv = (await ChatConversation.getSavedChat(
                              ChatConversation.createConvsertionKey(
                                  AppController.me.id, user.id))) ??
                          ChatConversation.newConversation(friend: user);
                      Get.to(() => ChatScreen(conversation: conv));
                    },
                    child: Text("Chat with ${user.fullName}"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
