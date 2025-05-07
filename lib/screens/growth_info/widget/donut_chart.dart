import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:v4/screens/common/style/text_styles.dart';

class DoughnutChart extends StatelessWidget {
  final double value;
  final String title;
  final Color color;

  const DoughnutChart(
      {Key? key, required this.value, required this.title, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppTextStyle.regular14,
        ),
        Container(
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SfCircularChart(
                series: <DoughnutSeries>[
                  // 배경용 시리즈 (전체)
                  DoughnutSeries<ChartData, String>(
                    dataSource: [ChartData(100)], // 배경을 위한 전체 원
                    xValueMapper: (ChartData data, _) => '',
                    yValueMapper: (ChartData data, _) => data.value,
                    innerRadius: '50%',
                    radius: '100%',
                    startAngle: 0,
                    endAngle: 360,
                    pointColorMapper: (ChartData data, _) => Color(0xFFE1E1E1),
                    dataLabelSettings: DataLabelSettings(isVisible: false),
                    animationDuration: 0,
                  ),
                  // 실제 값 시리즈
                  DoughnutSeries<ChartData, String>(
                    dataSource: [
                      // value 값이 0보다 작으면 0, 100보다 크면 100으로 제한
                      ChartData(value.clamp(0, 100))
                    ],
                    xValueMapper: (ChartData data, _) => '',
                    yValueMapper: (ChartData data, _) => data.value,
                    innerRadius: '50%',
                    radius: '100%',
                    startAngle: 0,
                    endAngle: ((value.clamp(0, 100) / 100) * 360).toInt() - 360,
                    pointColorMapper: (ChartData data, _) => color,
                    dataLabelSettings: DataLabelSettings(isVisible: false),
                  ),
                ],
              ),
              // 도넛 차트 안에 값을 표시하기 위한 Text 위젯
              Text(
                '${value.toInt()}%',
                style: AppTextStyle.medium16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChartData {
  final double value;

  ChartData(this.value);
}
