import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SeasonalBarWidget extends StatelessWidget {
  final List<double> seasonalIndex;
  final List<String> selectedYears;

  const SeasonalBarWidget({
    super.key,
    required this.seasonalIndex,
    required this.selectedYears,
  });

  @override
  Widget build(BuildContext context) {
    // 최대값 설정 (Y축 범위에 맞춰서 설정)
    double maxBarValue = 1.5;

    // xLabels 생성: 선택된 연도와 월을 포함한 타임라인 생성
    List<String> xLabels = [];
    List<String> years = List.from(selectedYears.where((year) => year != '평년'))
      ..sort();

    for (var year in years) {
      for (int month = 1; month <= 12; month++) {
        xLabels.add(
            '${year.substring(2)}.${month.toString().padLeft(2, '0')}'); // 'YY.MM'
      }
    }

    // x축 레이블에 중복 제거
    xLabels = xLabels.toSet().toList();

    return SizedBox(
      height: 150,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          labelRotation: 0,
          interval: 1,
          labelStyle: TextStyle(
            color: Color(0xFF666C77),
            fontSize: 12,
          ),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: maxBarValue,
          interval: 1,
          majorGridLines: const MajorGridLines(
            width: 0.5,
            color: Color(0xFFEEEEEE),
          ),
          labelStyle: const TextStyle(
            color: Color(0xFF666C77),
            fontSize: 12,
          ),
        ),
        series: <CartesianSeries>[
          // 실제 데이터 막대 시리즈
          StackedColumnSeries<double, String>(
            dataSource: seasonalIndex,
            xValueMapper: (data, index) => xLabels[index],
            yValueMapper: (data, _) => data,
            pointColorMapper: (data, _) =>
                data < 1 ? const Color(0xFF2478C7) : const Color(0xFFEB5C5C),
            animationDuration: 500,
          ),
          // 회색 고정 막대 시리즈
          StackedColumnSeries<double, String>(
            dataSource: List.filled(seasonalIndex.length, maxBarValue),
            xValueMapper: (data, index) => xLabels[index],
            yValueMapper: (data, _) => data,
            color: Colors.grey.withOpacity(0.3),
            animationDuration: 500,
          ),
        ],
      ),
    );
  }
}
