import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // intl 패키지 임포트

class MainCardWidget extends StatelessWidget {
  final String prod;
  final String optimalPurchaseTime;

  const MainCardWidget({
    super.key,
    required this.prod,
    required this.optimalPurchaseTime,
  });

  @override
  Widget build(BuildContext context) {
    String currentDate =
        DateFormat('yyyy.MM.dd').format(DateTime.now()); // 오늘 날짜 형식 설정

    final screenWidth = MediaQuery.of(context).size.width;
    final imageAsset = screenWidth >= 600
        ? 'assets/png/banner_web.png'
        : 'assets/png/home_banner.png';

    return Container(
      color: const Color(0xFFF8F8F8), // 배경색 추가
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 배경 이미지
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageAsset),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // 배너 카드
              Positioned(
                top: 150, // 배경 이미지 안쪽에 겹치도록 위치 조정
                left: 16,
                right: 16,
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      center: Alignment.topLeft,
                      radius: 1.5,
                      colors: [
                        Color.fromRGBO(255, 255, 255, 0.08),
                        Color.fromRGBO(255, 255, 255, 0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.6),
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentDate,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Optimal Purchase Timing for \'Perilla\'',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 2.0,
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Dec.2024',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 2.0,
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
