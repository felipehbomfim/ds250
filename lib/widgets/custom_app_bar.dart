import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../theme/theme_helper.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // You can adjust the height as necessary
}

class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, 0.1),
    end: const Offset(1.0, 0.0),
  ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      )
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    repeatOnce();
  }

  void repeatOnce() async {
    await _controller.forward();
    await _controller.reverse();
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: theme.primaryColor,
      centerTitle: true,
      title: SlideTransition(
          position: _offsetAnimation,
          child: Center(
            child: CustomImageView(
              imagePath: ImageConstant.imgLogoWhite,
              width: 80.h,
            ),
          )
      ),
    );
  }
}
