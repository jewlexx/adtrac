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
        CircleAvatar(
          foregroundImage: CachedNetworkImageProvider(photoUrl),
        ),
        const Padding(padding: EdgeInsets.all(5.0)),
      ],
    );
  }
}
