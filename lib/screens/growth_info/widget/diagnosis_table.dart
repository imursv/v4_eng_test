import 'package:flutter/material.dart';
import 'package:v4/screens/common/style/text_styles.dart';
import 'package:v4/screens/utils/format/number_format.dart';

class DiagnosisTableWidget extends StatelessWidget {
  final Map<String, dynamic> diagnosisData;

  const DiagnosisTableWidget({Key? key, required this.diagnosisData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          _buildThreeColumnTable(),  // 3열 표 (등급, 예측 생산량, 생장지수)
          _buildTwoColumnTable(),  // 2열 표 (해야할 일, 주의사항)
        ],
      ),
    );
  }

  // 3열 표 생성 함수 (등급, 예측 생산량, 생장지수)
  Widget _buildThreeColumnTable() {
    return Table(
      border: const TableBorder(
        top: BorderSide(color: Color(0xFFDDE1E6), width: 1),
        verticalInside: BorderSide(color: Color(0xFFDDE1E6), width: 1),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            // _buildTitleValueCell('Grade', diagnosisData['grade']),
            _buildTitleValueCell('Grade', 'High'),
            _buildTitleValueCell('Forecast Yield', diagnosisData['yield']),
            _buildTitleValueCell('Growth Index', diagnosisData['GrowthIndex']),
          ],
        ),
      ],
    );
  }

  // 2열 표 생성 함수 (해야할 일, 주의사항)
  Widget _buildTwoColumnTable() {
    return Table(
      border: const TableBorder(
        bottom: BorderSide(color: Color(0xFFDDE1E6), width: 1),
        verticalInside: BorderSide(color: Color(0xFFDDE1E6), width: 1),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            _buildTitleValueCell('To-Do', _formatTaskList(diagnosisData['tasks'])),
            _buildTitleValueCell('Warnings', _formatCautionList(diagnosisData['caution'])),
          ],
        ),
      ],
    );
  }

  // 타이틀과 값을 위아래로 나열하는 셀 디자인 (타이틀에 배경색 추가)
  Widget _buildTitleValueCell(String title, dynamic value) {
    return Column(
      children: [
        Container(
          height: 40,
          width: double.infinity,
          color: Color(0xFFF8F8F8),
          alignment: Alignment.center,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.regular14,
          ),
        ),
        Container(
          height: 40,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFDDE1E6), width: 1),
            ),
          ),
          child: Text(
            formatCurrency(value),
            textAlign: TextAlign.center,
            style: AppTextStyle.light14,
          ),
        ),
      ],
    );
  }

  // tasks 리스트를 문자열로 변환하는 헬퍼 함수
  String _formatTaskList(List<dynamic> tasks) {
    return tasks.map((task) => task['label']).join(', ');
  }

  // caution 리스트를 문자열로 변환하는 헬퍼 함수
  String _formatCautionList(List<dynamic> cautions) {
    return cautions.join(', ');
  }
}
