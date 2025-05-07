import 'package:flutter/material.dart';
import 'dart:math';
import 'package:v4/screens/common/style/text_styles.dart';

class StageBarWidget extends StatelessWidget {
  final List<dynamic> growthStages;

  const StageBarWidget({
    super.key,
    required this.growthStages,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final totalWidth = min(screenWidth - 48, 1148.0);
    final lastEndMonth = growthStages.last['endMonth'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Stack(
              children: [
                for (int i = 0; i <= growthStages.length; i++) ...[
                  Positioned(
                    left: totalWidth / lastEndMonth * i,
                    child: CustomPaint(
                      size: const Size(1, 40),
                      painter: DashedLinePainter(),
                    ),
                  ),
                  if (i > 0)
                    Positioned(
                      left: totalWidth / lastEndMonth * i - 55,
                      top: 10,
                      child: Text(
                        i == 1 ? '${i}month' : '${i}months',
                        style: AppTextStyle.light12,
                      ),
                    ),
                ],
                Row(
                  children: growthStages.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stage = entry.value;
                    final stageWidthFactor =
                        (stage['endMonth'] - stage['startMonth']) /
                            lastEndMonth;

                    return Expanded(
                      flex: (stageWidthFactor * 1000).toInt(),
                      child: Container(
                        margin: const EdgeInsets.only(top: 40, bottom: 5),
                        height: 16.0,
                        decoration: BoxDecoration(
                          color: index < 2
                              ? const Color(0xFFD3E9F5)
                              : const Color(0xFF78BDA5),
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(8.0),
                            right: Radius.circular(8.0),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Row(
            children: growthStages.asMap().entries.map((entry) {
              final stage = entry.value;
              final stageWidthFactor =
                  (stage['endMonth'] - stage['startMonth']) / lastEndMonth;

              String getEnglishLabel(String koreanLabel) {
                switch (koreanLabel) {
                  case '파종 및 유묘기':
                    return 'Seeding';
                  case '이식기':
                    return 'Transplanting';
                  case '신장기':
                    return 'Vegetative';
                  case '개화기':
                    return 'Flowering';
                  case '성숙기':
                    return 'Maturation';
                  case '수확':
                    return 'Harvest';
                  default:
                    return koreanLabel;
                }
              }

              return Expanded(
                flex: (stageWidthFactor * 1000).toInt(),
                child: Center(
                  child: Text(
                    getEnglishLabel(stage['label']),
                    style: AppTextStyle.light12,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    const dashHeight = 4;
    const dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
