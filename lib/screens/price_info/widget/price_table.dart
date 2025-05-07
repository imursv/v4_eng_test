import 'package:flutter/material.dart';
import 'package:v4/screens/common/style/text_styles.dart';
import 'package:v4/screens/price_info/widget/tooltip.dart';

class PriceTableWidget extends StatelessWidget {
  final List<List<String>> dataRows;

  const PriceTableWidget({
    super.key,
    required this.dataRows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleRow(dataRows[0]),
        const SizedBox(height: 16),
        _buildDataGrid(context, startIndex: 1),
        if (dataRows.length > 4) _buildDataGrid(context, startIndex: 4),
      ],
    );
  }

  Widget _buildTitleRow(List<String> titleData) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F8F8),
        border: Border(
          top: BorderSide(color: Color(0xFFDDE1E6), width: 1),
          bottom: BorderSide(color: Color(0xFFDDE1E6), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(titleData[0], style: AppTextStyle.light14),
              const Spacer(),
              Text(titleData[1], style: AppTextStyle.semibold25),
              Text(titleData[2], style: AppTextStyle.medium16),
            ],
          ),
          Row(
            children: [
              Text(titleData[3], style: AppTextStyle.light14),
              const SizedBox(width: 4),
              Text(
                titleData[4],
                style: AppTextStyle.regular14.copyWith(
                  color: titleData[4].startsWith('+')
                      ? const Color(0xFFEB5C5C)
                      : titleData[4].startsWith('-')
                          ? const Color(0xFF2478C7)
                          : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataGrid(BuildContext context, {required int startIndex}) {
    List<Widget> dataCells = [];

    for (int i = startIndex; i < startIndex + 3 && i < dataRows.length; i++) {
      dataCells.add(
        Expanded(
          child: _buildDataCell(
            context,
            dataRows[i][0],
            dataRows[i][1],
            dataRows[i].length > 2 ? dataRows[i][2] : '',
          ),
        ),
      );
    }

    while (dataCells.length < 3) {
      dataCells.add(Expanded(child: Container()));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: dataCells,
      ),
    );
  }

  Widget _buildDataCell(BuildContext context, String title, String value,
      String? additionalValue) {
    return Container(
      height: 85,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFDDE1E6), width: 1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: title.length > 8
                      ? AppTextStyle.light12
                      : AppTextStyle.light14,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                ),
              ),
              _buildTooltipIfNeeded(title),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: value.length > 10
                ? AppTextStyle.medium16
                : AppTextStyle.medium18,
            textAlign: TextAlign.center,
          ),
          if (additionalValue != null && additionalValue.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(
              additionalValue,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: additionalValue.startsWith('▲')
                    ? const Color(0xFFEB5C5C)
                    : additionalValue.startsWith('▼')
                        ? const Color(0xFF2478C7)
                        : Colors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTooltipIfNeeded(String title) {
    Map<String, String> tooltips = {
      '계절 지수': '1보다 크면 현재 가격이 연평균보다 높음.\n1보다 작으면 현재 가격이 연평균보다 낮음',
      '공급 안정성 지수': '10 이상: 매우 안정\n5 ~ 10: 보통\n5 미만: 불안정',
      '일관성 지수': '0.9 이상: 일관된 예측\n0.75 ~ 0.90: 약간의 변동성\n0.75 미만: 변동폭이 클 수 있음',
      '계절 보정가': '계절 지수를 반영한 보정가',
      '신호 지수': '1.5 이상: 강한 상승 신호\n-1.5 ~ 1.5: 신호 없음\n-1.5 미만: 강한 하락 신호',
    };

    if (tooltips.containsKey(title)) {
      return TooltipWidget(message: tooltips[title]!);
    }
    return Container();
  }
}
