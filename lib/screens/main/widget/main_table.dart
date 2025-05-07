import 'package:flutter/material.dart';
import 'package:v4/screens/common/style/text_styles.dart';

class MainTableWidget extends StatelessWidget {
  final List<List<String>> dataRows; // Dynamic data rows

  const MainTableWidget({super.key, required this.dataRows});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDataGrid(context, startIndex: 0), // 1행 3열의 데이터 그리드
        if (dataRows.length > 5) // 데이터 행이 5개 초과일 경우 두 번째 데이터 그리드 추가
          _buildDataGrid(context, startIndex: 3),
      ],
    );
  }

  // 데이터를 1행 3열로 보여주는 함수
  Widget _buildDataGrid(BuildContext context, {int startIndex = 2}) {
    List<Widget> dataCells = [];

    // 데이터 행의 수에 따라 인덱스 설정
    for (int i = startIndex; i < startIndex + 3 && i < dataRows.length; i++) {
      dataCells.add(_buildDataCell(context, dataRows[i][0], dataRows[i][1]));
    }

    // 부족한 셀을 빈 Container로 채워서 3개로 맞추기
    while (dataCells.length < 3) {
      dataCells.add(Expanded(
        child: Container(),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: dataCells,
    );
  }

  // 데이터를 포함하는 셀을 구성하는 함수
  Widget _buildDataCell(BuildContext context, String title, String value) {
    // 기본 색상
    Color valueColor = Colors.black;

    if (value.isNotEmpty) {
      if (value.startsWith('▼')) {
        valueColor = const Color(0xFF2478C7);
      } else if (value.startsWith('▲')) {
        valueColor = const Color(0xFFEB5C5C);
      }
    }

    return Expanded(
      child: Container(
        height: 70,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFDDE1E6), width: 1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: title.length > 8
                  ? AppTextStyle.light12
                  : AppTextStyle.light14,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: value.length > 10
                  ? AppTextStyle.medium12.copyWith(color: valueColor)
                  : AppTextStyle.medium16.copyWith(color: valueColor),
            ),
          ],
        ),
      ),
    );
  }
}
