import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:v4/screens/common/style/text_styles.dart';

class CropPredChart extends StatelessWidget {
  final List<dynamic> latestPred;
  final List<dynamic> latestActual;
  final List<String> date;
  final String actualName;
  final String predictedName;
  final String unit;

  const CropPredChart({
    super.key,
    required this.latestPred,
    required this.latestActual,
    required this.date,
    required this.actualName,
    required this.predictedName,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    // 실제 데이터와 예측 데이터 각각의 x, y 값을 매핑
    List<ChartData> actualData = List.generate(
      latestActual.length,
      (index) => ChartData(date[index], latestActual[index]),
    );

    List<ChartData> predData = List.generate(
      date.length,
      (index) => ChartData(date[index], latestPred[index]),
    );

    final TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
    final TrackballBehavior trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      lineType: TrackballLineType.vertical,
      tooltipSettings: const InteractiveTooltip(
        enable: true,
        color: Colors.black54,
        textStyle: TextStyle(color: Colors.white),
      ),
    );

    return Stack(
      children: [
        // 차트 본체
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          primaryYAxis: const NumericAxis(
            rangePadding: ChartRangePadding.auto, // y축을 자동으로 설정
          ),
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.top,
            alignment: ChartAlignment.center,
          ),
          tooltipBehavior: tooltipBehavior,
          trackballBehavior: trackballBehavior,
          series: <CartesianSeries<ChartData, String>>[
            LineSeries<ChartData, String>(
              dataSource: actualData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: actualName,
              color: const Color(0xFF67CEB8),
              animationDuration: 0,
              markerSettings: MarkerSettings(
                isVisible: actualData.length <= 12,
                height: 4,
                width: 4,
              ),
            ),
            LineSeries<ChartData, String>(
              dataSource: predData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: predictedName,
              color: const Color(0xFF4F8A97),
              dashArray: const <double>[1, 5],
              animationDuration: 0,
              markerSettings: MarkerSettings(
                isVisible: actualData.length <= 12,
                height: 4,
                width: 4,
              ),
            ),
          ],
        ),
        // 차트 상단에 텍스트 추가
        Positioned(
          top: 15,
          left: 10,
          child: Text(
            unit,
            style: AppTextStyle.light12,
          ),
        ),
      ],
    );
  }
}

// 차트 데이터 클래스를 정의
class ChartData {
  final String x;
  final dynamic y;

  ChartData(this.x, this.y);
}
