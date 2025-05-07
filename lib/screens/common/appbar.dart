import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color color1;
  final Color color2;
  final VoidCallback onMenuPressed;

  const CustomAppBar({
    super.key,
    required this.color1,
    required this.color2,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: onMenuPressed,
      ),
      centerTitle: true,
      title: GestureDetector(
        onTap: () {
          context.go('/');
        },
        child: Image.asset(
          'assets/png/bgood_bi_w.png',
          height: 40,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
