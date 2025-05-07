import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF383A3A),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/png/bgood_bi.png', height: 40),
            const SizedBox(height: 8),
            const Text(
              '(주)에스앤이컴퍼니',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const Text(
              '통신판매업 신고: xxxxxxxxxxxxx',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const Text(
              '개인정보관리 책임자: 장세훈(shjang@bgood.co.kr)',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              'Copyright © B･good. All rights reserved.',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
