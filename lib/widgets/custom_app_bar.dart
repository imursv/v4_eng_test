import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final Function(String) onLanguageChanged;
  final VoidCallback onProfilePressed;
  final Color color1;
  final Color color2;

  const CustomAppBar({
    super.key,
    required this.onMenuPressed,
    required this.onLanguageChanged,
    required this.onProfilePressed,
    this.color1 = const Color(0xFF43A470),
    this.color2 = const Color(0xFF43A470),
  });

  @override
  Widget build(BuildContext context) {
    // 상태표시줄 색상 설정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color1, // 앱바 색상과 동일하게 설정
      statusBarIconBrightness: Brightness.light, // 아이콘 밝기 설정
    ));

    return Stack(
      children: [
        // 상태 표시줄 영역 포함 앱바 배경색 적용
        Container(
          height: kToolbarHeight + MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        SafeArea(
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                height: kToolbarHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: onMenuPressed,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(), // 왼쪽 여백
                    ),
                    Image.asset(
                      'assets/png/bgood_bi_w.png',
                      height: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(), // 오른쪽 여백
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.language, color: Colors.white),
                      onSelected: onLanguageChanged,
                      itemBuilder: (BuildContext context) {
                        return ['한국어', 'English'].map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.person, color: Colors.white),
                      onPressed: onProfilePressed,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
