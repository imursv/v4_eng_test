import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:v4/data/mock/crop_mock.dart';
import 'package:v4/screens/common/drawer.dart';
import 'package:v4/screens/common/footer.dart';
import 'package:v4/screens/common/header.dart';
import 'package:v4/screens/common/style/text_styles.dart';
import 'package:v4/screens/common/widget/dropdown.dart';
import 'package:v4/screens/common/widget/grade_btn.dart';
import 'package:v4/screens/common/widget/title_text.dart';
import 'package:v4/screens/common/widget/year_btn.dart';
import 'package:v4/screens/crop_info/widget/crop_chart.dart';
import 'package:v4/screens/crop_info/widget/crop_pred_chart.dart';
import 'package:v4/screens/crop_info/widget/crop_table.dart';
import 'package:v4/screens/crop_info/widget/regional_bar_chart.dart';
import 'package:v4/screens/crop_info/widget/regional_prod_table.dart';
import 'package:v4/screens/crop_info/widget/statistic_chart.dart';
import 'package:v4/screens/utils/format/number_format.dart';
import 'package:v4/widgets/custom_app_bar.dart';

class CropInfoPage extends StatefulWidget {
  const CropInfoPage({super.key});

  @override
  State<CropInfoPage> createState() => _CropInfoPageState();
}

class _CropInfoPageState extends State<CropInfoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //공통
  String selectedLanguage = '한국어';
  Map<String, dynamic> cropMockData = {};
  String selectedProduct = "들깨";
  String selectedCountry = "한국";
  bool isContinuousView = false; //그래프 이어서 보기 - '평년'버튼 유무 때문에 필요
  final List<Color> buttonColors = [
    const Color(0xFF0084FF),
    const Color(0xFF9568EE),
    const Color(0xFFFF9500),
    const Color(0xFFF8D32D),
    const Color(0xFF78B060),
    const Color(0xFF0084FF),
    const Color(0xFF9568EE),
    const Color(0xFFFF9500),
    const Color(0xFFF8D32D),
    const Color(0xFF78B060),
    const Color(0xFF0084FF),
    const Color(0xFF9568EE),
    const Color(0xFFFF9500),
    const Color(0xFFF8D32D),
    const Color(0xFF78B060),
    const Color(0xFF0084FF),
    const Color(0xFF9568EE),
    const Color(0xFFFF9500),
    const Color(0xFFF8D32D),
    const Color(0xFF78B060),
  ];
 
  List<dynamic> marketOptions = [];
  //분석
  List<List<dynamic>> cropInfo = [];
  List<String> availableRegions = [];
  List<String> selectedRegions = [];
  Map<String, Color> RegionColorMap = {};
  Map<String, List<double>> currentProductionData = {};
  List<String> availableYears = [];
  String selectedYear = '';
  Map<String, Map<String, dynamic>> regionalProduction = {};

  //예측
  List<List<dynamic>> cropPredInfo = [];
  List<String> availablePredRegions = [];
  String selectedPredRegion = '전체';
  Map<String, Color> RegionPredColorMap = {};
  List<double> predProductionData = [];
  List<double> currPredProductionData = [];
  List<String> availablePredYears = [];
  List<String> date = [];
  int currentYear = DateTime.now().year;
  String selectedPredYear = '';
  Map<String, Map<String, dynamic>> regionalPredProduction = {};

  //국가별
  Map<String, dynamic> statistic = {};

  @override
  void initState() {
    super.initState();
    _updateYearData();
    _updateRegionColorMap();
    _updateChartData();
    _updateStatistic();
  }

  void _updateYearData() {
    availableYears = cropMockupData['selectedCrops'][selectedProduct]['crops']
            [selectedCountry]['실제생산']['sido_value']
        .keys
        .toList();
    selectedYear = availableYears.last;
    availablePredYears = cropMockupData['selectedCrops'][selectedProduct]
            ['crops'][selectedCountry]['예측생산']['sido_value']
        .keys
        .toList();
    selectedPredYear = availablePredYears.last;
    marketOptions =
        cropMockupData['selectedCrops'][selectedProduct]['markets'] ?? [];
  }

  void _updateChartData() {
    // 선택된 작물 및 국가의 실제생산 데이터 가져오기
    Map<String, dynamic> cropData = cropMockupData['selectedCrops']
        [selectedProduct]['crops'][selectedCountry];

    // 선택된 연도들의 데이터 가져오기
    currentProductionData = {
      for (var region in selectedRegions)
        region: List<double>.from((cropData['실제생산'][region] ?? [])
            .where((data) => data != null)
            .map((data) => data!.toDouble()))
    };
    predProductionData = List<double>.from(
        (cropData['예측생산'][selectedPredRegion] ?? [])
            .where((data) => data != null)
            .map((data) => data!.toDouble()));

    currPredProductionData = List<double>.from(
        (cropData['실제생산'][selectedPredRegion] ?? [])
            .where((data) => data != null)
            .map((data) => data!.toDouble()));
    date = [
      for (int year = currentYear - 9; year <= currentYear; year++) '$year년'
    ];

    regionalProduction = cropData['실제생산']['sido_value'][selectedYear];
    regionalPredProduction = cropData['예측생산']['sido_value'][selectedPredYear];
    setState(() {});
  }

  void _updateRegionColorMap() {
    RegionColorMap.clear();

    availableRegions = cropMockupData['selectedCrops'][selectedProduct]['crops']
            [selectedCountry]['실제생산']
        .keys
        .where((year) => year != 'act_analysis' && year != 'sido_value')
        .toList();

    selectedRegions = [availableRegions[0]];
    availablePredRegions = cropMockupData['selectedCrops'][selectedProduct]
            ['crops'][selectedCountry]['예측생산']
        .keys
        .where((year) => year != 'pred_analysis' && year != 'sido_value')
        .toList();

    selectedPredRegion = availablePredRegions[0];
    String year;
    for (int i = 0; i < availableRegions.length; i++) {
      year = availableRegions[i];
      RegionColorMap[year] = buttonColors[i];
    }
  }

  void _updateStatistic() {
    statistic = cropMockupData['selectedCrops'][selectedProduct]['crops']
        [selectedCountry]['statistic'];
  }

  @override
  Widget build(BuildContext context) {
    // 테이블 정보
    final actAnalysis = cropMockupData['selectedCrops'][selectedProduct]
        ['crops'][selectedCountry]['실제생산']['act_analysis'];
    cropInfo = [
      ['Actual Yield(2024)', formatCurrency(actAnalysis['this_value']), 'ton'],
      ['Actual Area(2024)', formatCurrency(actAnalysis['actual_area']), 'ha'],
      ['Yield per 10a(2024)', actAnalysis['production_per_10a'], 'kg'],
      [
        'Avg. Year',
        formatCurrency(actAnalysis['value_compared_average_year']),
        'ton'
      ],
      [
        'Last Year',
        formatCurrency(actAnalysis['value_compared_last_value']),
        'ton'
      ],
      [
        'Cultivation Stability Index',
        actAnalysis['cultivation_stability_index'],
        ''
      ],
    ];
    final predAnalysis = cropMockupData['selectedCrops'][selectedProduct]
        ['crops'][selectedCountry]['예측생산']['pred_analysis'];
    cropPredInfo = [
      [
        'Forecast Yield(2024)',
        formatCurrency(predAnalysis['this_value']),
        'ton'
      ],
      ['Forecast Area(2024)', formatCurrency(predAnalysis['pred_area']), 'ha'],
      [
        'Yield Range',
        '${formatCurrency(predAnalysis['range'][0])} ~ ${formatCurrency(predAnalysis['range'][1])}',
        ''
      ],
      [
        'Out-of-Range Probability',
        predAnalysis['out_of_range_probability'],
        '%'
      ],
      [
        'Stability Probability',
        predAnalysis['stability_section_probability'],
        '%'
      ],
      ['Signal Index', predAnalysis['signal_index'], ''],
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      key: _scaffoldKey,
      appBar: CustomAppBar(
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        onLanguageChanged: (String value) {
          setState(() {
            selectedLanguage = value;
          });
        },
        onProfilePressed: () {
          // 프로필 버튼 동작
        },
        color1: const Color(0xFFBB9160),
        color2: const Color(0xFF020202),
      ),
      extendBodyBehindAppBar: true,
      drawer: CustomDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Container(
                  color: const Color(0xFFF8F8F8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomHeader(
                        gradientColors: const [
                          Color(0xFFD0A16A),
                          Color(0xFF604B32),
                          Color(0xFF000000)
                        ],
                        selectedProduct: selectedProduct,
                        title: 'CROP INFO',
                        onProductChanged: (value) {
                          setState(() {
                            selectedProduct = value ?? '들깨';
                            _updateChartData();
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Region: ',
                            style: AppTextStyle.light16,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          DropdownWidget(
                            options: marketOptions,
                            selectedValue: selectedCountry,
                            onChanged: (value) {
                              setState(() {
                                selectedCountry = value ?? '한국';
                                // _updateChartData(); // 국가 변경 시 데이터 업데이트
                              });
                            },
                          ),
                        ],
                      ),
                      const CustomTextWidget(text: 'Analysis'),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.white,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CropInfoTable(cropInfo: cropInfo),
                            YearButtonWidget(
                              availableYears: availableRegions,
                              selectedYears: selectedRegions,
                              onYearsChanged: (updatedSelectedYears) {
                                setState(() {
                                  selectedRegions = updatedSelectedYears;
                                  _updateChartData();
                                });
                              },
                              yearColorMap: RegionColorMap,
                              isContinuousView: isContinuousView,
                            ),
                            const SizedBox(height: 16),
                            CropChart(
                              selectedRegions: selectedRegions,
                              currentProductionData: currentProductionData,
                              gradeColorMap: RegionColorMap,
                              unit: 'Yield(ton)',
                            ),
                            const SizedBox(height: 10),
                            DropdownWidget(
                              options: availableYears,
                              selectedValue: selectedYear,
                              onChanged: (value) {
                                setState(() {
                                  selectedYear = value ?? selectedYear;
                                  _updateChartData(); // 국가 변경 시 데이터 업데이트
                                });
                              },
                            ),
                            RegionalBarWidget(
                              regionalProduction: regionalProduction,
                              color: const Color(0xFF87C46D),
                            ),
                            RegionalProdWidget(
                                regionalProduction: regionalProduction),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const CustomTextWidget(text: 'Forecast'),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.white,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CropInfoTable(cropInfo: cropPredInfo),
                            GradeButtonWidget(
                              onGradeChanged: (newSelectedForecast) {
                                setState(() {
                                  selectedPredRegion = newSelectedForecast;
                                  _updateChartData();
                                });
                              },
                              btnNames: availablePredRegions,
                              selectedBtn: selectedPredRegion,
                            ),
                            CropPredChart(
                              latestPred: predProductionData,
                              latestActual: currPredProductionData,
                              date: date,
                              actualName: 'Actual',
                              predictedName: 'Predicted',
                              unit: '',
                            ),
                            const SizedBox(height: 16),
                            DropdownWidget(
                              options: availablePredYears,
                              selectedValue: selectedPredYear,
                              onChanged: (value) {
                                setState(() {
                                  selectedPredYear = value ?? selectedPredYear;
                                  _updateChartData(); // 국가 변경 시 데이터 업데이트
                                });
                              },
                            ),
                            RegionalBarWidget(
                              regionalProduction: regionalPredProduction,
                              color: const Color(0xFF3EB080),
                            ),
                            RegionalProdWidget(
                                regionalProduction: regionalPredProduction),
                          ],
                        ),
                      ),
                      const CustomTextWidget(text: 'Country Statistics'),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.white,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Export Amount',
                                style: AppTextStyle.medium16),
                            LineChart(statisticData: statistic),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }

  // 지역 셀렉트박스(드롭다운)
  Widget _countryDropdown() {
    List<String> marketOptions =
        cropMockupData['selectedCrops'][selectedProduct]['markets'] ?? [];
    return Container(
      width: 134,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButton<String>(
          value: selectedCountry,
          items: marketOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: AppTextStyle.regular16,
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCountry = value ?? '대한민국';
              _updateChartData(); // 국가 변경 시 데이터 업데이트
            });
          },
          dropdownColor: Colors.white,
          icon:
              Image.asset('assets/icon/arrow_down.png', width: 20, height: 20),
          style: const TextStyle(color: Color(0xFF363B45)),
          underline: const SizedBox(),
          isExpanded: true,
        ),
      ),
    );
  }
}
