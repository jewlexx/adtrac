import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Copy of the internal flutter class
class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight(
            (toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

class AdTracAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final User user;
  final List<Widget>? actions;

  // Copied from AppBar class
  /// {@template flutter.material.appbar.toolbarHeight}
  /// Defines the height of the toolbar component of an [AppBar].
  ///
  /// By default, the value of [toolbarHeight] is [kToolbarHeight].
  /// {@endtemplate}
  final double? toolbarHeight;

  /// {@template flutter.material.appbar.bottom}
  /// This widget appears across the bottom of the app bar.
  ///
  /// Typically a [TabBar]. Only widgets that implement [PreferredSizeWidget] can
  /// be used at the bottom of an app bar.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [PreferredSize], which can be used to give an arbitrary widget a preferred size.
  final PreferredSizeWidget? bottom;

  const AdTracAppBar({
    super.key,
    required this.title,
    required this.user,
    this.toolbarHeight,
    this.bottom,
    this.actions,
  });

  @override
  Size get preferredSize =>
      _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    final photoUrl = user.photoURL ??
        'https://api.dicebear.com/8.x/pixel-art/svg?seed=${user.uid}';

    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),
      actions: [
        if (actions != null) ...actions!,
        CircleAvatar(
          foregroundImage: CachedNetworkImageProvider(photoUrl),
        ),
      ],
    );
  }
}
