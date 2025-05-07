import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:v4/screens/common/style/text_styles.dart';

class CurrentChart extends StatefulWidget {
  final List<String> selectedGrades;
  final List<String> selectedYears;
  final Map<String, List<double>> currentProductionData;
  final ValueChanged<bool> onToggleView;
  final Map<String, Color> gradeColorMap;
  final String unit;
  final String hoverText;

  const CurrentChart({
    super.key,
    required this.selectedGrades,
    required this.selectedYears,
    required this.currentProductionData,
    required this.onToggleView,
    required this.gradeColorMap,
    required this.unit,
    required this.hoverText,
  });

  @override
  _CurrentChartState createState() => _CurrentChartState();
}

class _CurrentChartState extends State<CurrentChart> {
  @override
  Widget build(BuildContext context) {
    return _buildChart();
  }

  // 그래프 그리기
  Widget _buildChart() {
    final TooltipBehavior tooltipBehavior = TooltipBehavior(
      enable: true,
      format: widget.hoverText,
    );

    final TrackballBehavior trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap, // 터치할 때 트랙볼 활성화
      tooltipSettings: InteractiveTooltip(
        enable: true,
        format: widget.hoverText,
      ),
      lineType: TrackballLineType.vertical, // 수평으로 호버 이펙트 표시
      markerSettings: const TrackballMarkerSettings(
        markerVisibility: TrackballVisibilityMode.visible,
      ),
    );

    // xLabels 생성: 선택된 연도와 평년을 포함한 통합 타임라인 생성
    List<String> xLabels = [];
    List<String> years =
        List.from(widget.selectedYears.where((year) => year != '평년'))..sort();

    for (var year in years) {
      for (int month = 1; month <= 12; month++) {
        xLabels.add(
            '${year.substring(2)}.${month.toString().padLeft(2, '0')}'); // 'YY.MM'
      }
    }

    // 평년 데이터가 존재하면 12개의 월 데이터를 추가
    List<double>? avgData = widget.currentProductionData['평년'];
    if (avgData != null && avgData.isNotEmpty) {
      for (int month = 1; month <= 12; month++) {
        xLabels.add('평년.${month.toString().padLeft(2, '0')}'); // '평년.MM'
      }
    }

    // x축 레이블에 중복 제거
    xLabels = xLabels.toSet().toList();

    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        labelRotation: 0,
        interval: 1,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      tooltipBehavior: tooltipBehavior,
      trackballBehavior: trackballBehavior,
      series: [
// 선택된 등급 데이터 추가
        ...widget.selectedGrades.map((grade) {
          List<double> filteredData = widget.currentProductionData[grade] ?? [];
          return LineSeries<_ChartData, String>(
            name: grade,
            dataSource: List.generate(
              filteredData.length,
              (index) => _ChartData(xLabels[index], filteredData[index]),
            ),
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            color: widget.gradeColorMap[grade],
            animationDuration: 0,
          );
        }),
        // 평년 데이터 추가
        if (avgData != null && avgData.isNotEmpty)
          LineSeries<_ChartData, String>(
            name: '평년',
            dataSource: List.generate(
              avgData.length,
              (index) => _ChartData(xLabels[years.length * 12 + index],
                  avgData[index]), // 동일 x축 사용
            ),
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            color: const Color(0xFFB8D9AA), // 평년 데이터 색상
            animationDuration: 0,
            dashArray: const [5, 2], // 대시 라인
          ),
      ],
    );
  }
}

// ChartData 클래스 정의
class _ChartData {
  final String x;
  final double y;

  _ChartData(this.x, this.y);
}
