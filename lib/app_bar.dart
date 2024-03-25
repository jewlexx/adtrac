import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdTracAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final User user;
  final List<Widget>? actions;

  const AdTracAppBar({
    super.key,
    required this.title,
    required this.user,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final photoUrl = user.photoURL ??
        "https://api.dicebear.com/8.x/pixel-art/svg?seed=${user.uid}";

    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),
      actions: [
        if (actions != null) ...actions!,
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return UserDialog(user: user);
              },
            );
          },
          icon: CircleAvatar(
            foregroundImage: CachedNetworkImageProvider(photoUrl),
          ),
        ),
      ],
    );
  }
}

class UserDialog extends StatelessWidget {
  final User user;

  const UserDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text("User Info")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Signed in as ${user.displayName ?? user.uid}"),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Email: ${user.email} ",
                ),
                if (user.emailVerified)
                  const WidgetSpan(
                    child: Icon(Icons.verified, size: 14),
                  ),
              ],
            ),
          ),
          // Text("Email: ${user.email}"),

          if (user.emailVerified)
            TextButton.icon(
              onPressed: () => user.sendEmailVerification(),
              label: const Text("Verify Email"),
              icon: const Icon(Icons.verified),
            ),
        ],
      ),
      alignment: Alignment.topCenter,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          label: const Text("Close"),
        ),
        ElevatedButton.icon(
          onPressed: () {
            FirebaseAuth.instance
                .signOut()
                .then((value) => Navigator.of(context).pop());
          },
          icon: const Icon(Icons.logout),
          label: const Text("Sign Out"),
        ),
      ],
    );
  }
}
