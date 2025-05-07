import 'package:flutter/material.dart';
import 'package:v4/screens/common/style/text_styles.dart';
import 'package:intl/intl.dart';

class RegionalProdWidget extends StatelessWidget {
  final Map<String, Map<String, dynamic>> regionalProduction;

  const RegionalProdWidget({
    super.key,
    required this.regionalProduction,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth =
            constraints.maxWidth > 1200 ? 1200 : constraints.maxWidth;
        double cellWidth = maxWidth / 4; // 셀의 개수에 따라 조정

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: maxWidth,
            child: Column(
              children: [
                _buildTableHeader(cellWidth),
                ...regionalProduction.entries.map((entry) {
                  return _buildTableRow(
                    region: entry.key,
                    data: entry.value,
                    cellWidth: cellWidth,
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // 테이블 헤더 구성
  Widget _buildTableHeader(double cellWidth) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: const Color(0xFFF8F8F8),
      child: Row(
        children: [
          _buildHeaderCell('Region', width: cellWidth),
          _buildHeaderCell('Area(ha)', width: cellWidth),
          _buildHeaderCell('Yield(ton)', width: cellWidth),
          _buildHeaderCell('Yield per 10a(kg)', width: cellWidth),
        ],
      ),
    );
  }

  // 개별 헤더 셀 생성
  static Widget _buildHeaderCell(String title, {required double width}) {
    return SizedBox(
      width: width,
      child: Center(
        child: Text(
          title,
          style: title.length > 8
              ? AppTextStyle.regular12
              : AppTextStyle.regular14,
        ),
      ),
    );
  }

  // 각 지역별 데이터를 표시하는 테이블 행 구성
  Widget _buildTableRow({
    required String region,
    required Map<String, dynamic> data,
    required double cellWidth,
  }) {
    final numberFormat = NumberFormat.decimalPattern(); // 로케일에 맞는 숫자 포맷터

    String regionText = region == '경기도'
        ? 'Gyeonggi'
        : region == '강원도'
            ? 'Gangwon'
            : region == '충청북도'
                ? 'Chungbuk'
                : region == '충청남도'
                    ? 'Chungnam'
                    : region == '전라북도'
                        ? 'Jeonbuk'
                        : region == '전라남도'
                            ? 'Jeonnam'
                            : region == '경상북도'
                                ? 'Gyeongbuk'
                                : region == '경상남도'
                                    ? 'Gyeongnam'
                                    : region == '제주도'
                                        ? 'Jeju'
                                        : region == '전체'
                                            ? 'All'
                                            : region;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFDDE1E6), width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildDataCell(regionText, width: cellWidth), // 변환된 시도 이름
          _buildDataCell(numberFormat.format(data['area']),
              width: cellWidth), // 면적
          _buildDataCell(numberFormat.format(data['production']),
              width: cellWidth), // 생산량
          _buildDataCell(numberFormat.format(data['per_10a']),
              width: cellWidth), // 10a당 생산량
        ],
      ),
    );
  }

  // 개별 데이터 셀 생성
  Widget _buildDataCell(String value, {required double width}) {
    return SizedBox(
      width: width,
      child: Center(
        child: Text(
          value,
          style: AppTextStyle.light14,
        ),
      ),
    );
  }
}
