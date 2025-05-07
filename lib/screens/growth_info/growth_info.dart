import 'package:flutter/material.dart';
import 'package:v4/data/mock/growth_mock.dart';
import 'package:v4/screens/common/drawer.dart';
import 'package:v4/screens/common/footer.dart';
import 'package:v4/screens/common/header.dart';
import 'package:v4/screens/common/style/text_styles.dart';
import 'package:v4/screens/common/widget/grade_btn.dart';
import 'package:v4/screens/common/widget/title_text.dart';
import 'package:v4/screens/common/widget/year_btn.dart';
import 'package:v4/screens/growth_info/widget/calculator_table.dart';
import 'package:v4/screens/growth_info/widget/cost_input_table.dart';
import 'package:v4/screens/growth_info/widget/cost_table.dart';
import 'package:v4/screens/growth_info/widget/diagnosis_table.dart';
import 'package:v4/screens/growth_info/widget/donut_chart.dart';
import 'package:v4/screens/growth_info/widget/growth_chart.dart';
import 'package:v4/screens/growth_info/widget/growth_table.dart';
import 'package:v4/screens/growth_info/widget/pred_chart.dart';
import 'package:v4/screens/growth_info/widget/progress_bar.dart';
import 'package:v4/screens/growth_info/widget/stage_bar.dart';
import 'package:v4/screens/utils/calculate/growth_cal.dart';
import 'package:v4/screens/utils/calculate/growth_calculator.dart';
import 'package:v4/screens/utils/format/plus_minus.dart';
import 'package:v4/screens/utils/growth_phase_eng.dart';
import 'package:v4/services/growth_service.dart';
import 'package:v4/widgets/custom_app_bar.dart';

class GrowthInfoPage extends StatefulWidget {
  const GrowthInfoPage({super.key});

  @override
  State<GrowthInfoPage> createState() => _GrowthInfoPageState();
}

class _GrowthInfoPageState extends State<GrowthInfoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //공통
  String selectedLanguage = '한국어';
  Future<void>? _growthInfoFuture;
  final GrowthService _growthService = GrowthService();
  Map<String, dynamic> growthMockupData = {};
  String selectedProduct = "들깨";
  String optimumTemp = '25'; //최적온도 - 파이어베이스 접근해서 가져와야 함
  bool isContinuousView = false;
  final List<Color> buttonColors = [
    const Color(0xFF0084FF),
    const Color(0xFF9568EE),
    const Color(0xFFFF9500),
    const Color(0xFFF8D32D),
    const Color(0xFF78B060),
  ];

  //분석
  Map<String, dynamic> growthActualData = {};
  String selectedForecast = '기온';
  Map<String, Color> yearColorMap = {};
  List<String> availableYears = [];
  List<String> selectedYears = [];
  Map<String, List<double>> currentProductionData = {};

  //예측
  Map<String, dynamic> growthPredData = {};
  List<String> availablePredYears = [];
  String selectedPredYear = '';
  String selectedPredForecast = '기온';
  List<double> predProductionData = [];
  List<double> predCurrProductionData = [];
  List<String> date = [];

  //진단
  Map<String, dynamic> calculationData = {};
  Map<String, dynamic> todoData = {};
  double currentCostRatio = 0;
  double estimatedProfitRatio = 0;

  Map<String, dynamic> costData = {
    '항목1': 0,
    '항목2': 0,
    '항목3': 0,
    '항목4': 0,
  };
  int totalCost = 0;
  int predTotalCost = 0;

  @override
  void initState() {
    super.initState();
    loadGrowthInfo();
  }

  Future<void> loadGrowthInfo() async {
    // final data = await _growthService.fetchGrowhInfo();
    if (mounted) {
      setState(() {
        growthMockupData = growthMockData;
      });
      _updateYearColorMap();
      _updateChartData();
      costData = {
        'Fertilizer': 0,
        'Pesticide': 0,
        'Electricity': 0,
        'Water': 0,
        'Gas': 0,
        'Etc': 0,
      };
      calculationData =
          growthMockupData['selectedCrops'][selectedProduct]['calculation'];
      todoData = growthMockupData['selectedCrops'][selectedProduct]['todo'];
    }
  }

  // 연도 버튼 컬러 매핑
  void _updateYearColorMap() {
    yearColorMap.clear(); // 기존 맵 초기화

    availableYears = growthMockupData['selectedCrops'][selectedProduct]
            ['actual']['forecastData']['history']['year']
        .keys
        .where((year) => year != '평년')
        .toList();
    availableYears.sort((a, b) => int.parse(b).compareTo(int.parse(a)));
    availableYears.add('평년');
    selectedYears = [
      availableYears[0],
    ];

    for (int i = 0; i < availableYears.length; i++) {
      String year = availableYears[i];
      if (year == '평년') {
        yearColorMap[year] = buttonColors.last; // 평년은 마지막 색상 사용
      } else if (i < buttonColors.length) {
        yearColorMap[year] = buttonColors[i]; // 버튼 색상과 매핑
      }
    }

    availablePredYears = growthMockupData['selectedCrops'][selectedProduct]
            ['predictions']['forecastDataPred']['forecast']['year']
        .keys
        .toList();
    availablePredYears.sort((a, b) => int.parse(b).compareTo(int.parse(a)));
    selectedPredYear = availablePredYears[0];
  }

  void _updateChartData() {
    growthActualData =
        growthMockupData['selectedCrops'][selectedProduct]['actual'];
    growthPredData =
        growthMockupData['selectedCrops'][selectedProduct]['predictions'];

    String forecastType = _getForecastType(selectedForecast);
    String forecastPredType = _getForecastType(selectedPredForecast);

    Map<String, dynamic> forecastData =
        growthActualData['forecastData']['history']['year'];
    Map<String, dynamic> forecastPredData =
        growthPredData['forecastDataPred']['forecast']['year'];

    currentProductionData = {
      for (var year in selectedYears)
        year: _getValidData(forecastData[year]?[forecastType] ?? [])
    };

    predProductionData = _getValidData(
        forecastPredData[selectedPredYear]?[forecastPredType] ?? []);
    date = List<String>.from(forecastPredData[selectedPredYear]['date'] ?? []);
    print('predProductionData>> $predProductionData');
    print('date>> $date');

    predCurrProductionData = [0, 0, 0, 0, 0];

    setState(() {});
  }

// 선택된 기상 데이터를 반환
  String _getForecastType(String selectedForecast) {
    switch (selectedForecast) {
      case '강수량':
        return 'rainfall';
      case '습도':
        return 'humidity';
      default:
        return 'temperature';
    }
  }

// null 제거 후 double로 변환
  List<double> _getValidData(List<dynamic> dataList) {
    return dataList
        .where((data) => data != null)
        .map((data) => data is int ? data.toDouble() : data as double)
        .toList();
  }

  void _updateDoughnutChart(int totalCost) {
    setState(() {
      currentCostRatio =
          totalCost == 0 ? 0 : totalCost / (calculationData['FinalCost']) * 100;

      estimatedProfitRatio = totalCost == 0
          ? 0
          : ((calculationData['PredictedSales'] -
                  (calculationData['FinalCost'] +
                      (totalCost - calculationData['CurrentCost']))) /
              calculationData['PredictedSales'] *
              100);
    });
  }

  void updateTotalCost(int newTotal) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        totalCost = newTotal;
        _updateDoughnutChart(totalCost);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
        color1: const Color(0XFF52A560),
        color2: const Color(0xFF020202),
      ),
      extendBodyBehindAppBar: true,
      drawer: CustomDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: _growthInfoFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height:
                          MediaQuery.of(context).size.height - kToolbarHeight,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
                  } else {
                    return SingleChildScrollView(
                      child: growthActualData['growthStatus'] != null
                          ? Column(
                              children: [
                                Container(
                                  color: const Color(0xFFF8F8F8),
                                  child: ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 1200),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomHeader(
                                          gradientColors: const [
                                            Color(0xFF58B368),
                                            Color(0xFF2C5633),
                                            Color(0xFF000000)
                                          ],
                                          selectedProduct: selectedProduct,
                                          title: 'GROWTH INFO',
                                          onProductChanged: (value) {
                                            setState(() {
                                              selectedProduct = value ?? '들깨';
                                              // _updateChartData();
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        const CustomTextWidget(
                                            text: 'Analysis'),
                                        Container(
                                          padding: const EdgeInsets.all(16.0),
                                          color: Colors.white,
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text('Growth Status',
                                                  style: AppTextStyle.medium16),
                                              GrowthTableWidget(
                                                dataRows: [
                                                  [
                                                    'Growth Days',
                                                    'Day ${growthActualData['growthStatus']['daysFromSowing']}'
                                                  ],
                                                  [
                                                    'Growth Rate',
                                                    '${growthActualData['growthStatus']['overallProgress']}%'
                                                  ],
                                                  [
                                                    'Phase',
                                                    getGrowthStageInEng(getGrowthStageInEng(
                                                        calculateGrowthStage(
                                                            growthActualData[
                                                                    'growthStatus']
                                                                [
                                                                'overallProgress'],
                                                            growthActualData[
                                                                'growthStages'])))
                                                  ],
                                                  [
                                                    'Days to Harvest',
                                                    '${calculateDaysUntilHarvest(growthActualData['growthStatus']['estimatedHarvestDate'])} days'
                                                  ],
                                                  [
                                                    'Std. Harvest Date',
                                                    '${growthActualData['growthStatus']['estimatedHarvestDate']}'
                                                  ],
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              ProgressBarWidget(
                                                progressRate: growthActualData[
                                                            'growthStatus']
                                                        ['overallProgress'] /
                                                    100,
                                                barColor: 'curr',
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        '${growthActualData['growthStatus']['sowingDate']}',
                                                        style: AppTextStyle
                                                            .light12),
                                                    const Spacer(),
                                                    Text(
                                                        '${growthActualData['growthStatus']['estimatedHarvestDate']}',
                                                        style: AppTextStyle
                                                            .light12),
                                                  ],
                                                ),
                                              ),
                                              StageBarWidget(
                                                growthStages: growthActualData[
                                                    'growthStages'],
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              const Text('Growth Environment',
                                                  style: AppTextStyle.medium16),
                                              GrowthTableWidget(
                                                dataRows: [
                                                  [
                                                    'Current Temp',
                                                    '${growthActualData['forecastData']['current']['temperature']}${growthActualData['forecastData']['current']['unit']}'
                                                  ],
                                                  [
                                                    'Optimal Temp',
                                                    '$optimumTemp${growthActualData['forecastData']['current']['unit']}'
                                                  ],
                                                  [
                                                    'Vs. Optimal',
                                                    '${formatArrowIndicator(growthActualData['forecastData']['current']['changes']['Optimum'])}(${formatPositiveValue(growthActualData['forecastData']['current']['changes']['Optimum_rate'])})'
                                                  ],
                                                  [
                                                    'Vs. Previous Year',
                                                    '${formatArrowIndicator(growthActualData['forecastData']['current']['changes']['LastYear'])}(${formatPositiveValue(growthActualData['forecastData']['current']['changes']['LastYear_rate'])})'
                                                  ],
                                                  [
                                                    'Vs. Average',
                                                    '${formatArrowIndicator(growthActualData['forecastData']['current']['changes']['CommonYear'])}(${formatPositiveValue(growthActualData['forecastData']['current']['changes']['CommonYear_rate'])})'
                                                  ],
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              GradeButtonWidget(
                                                onGradeChanged:
                                                    (newSelectedForecast) {
                                                  setState(() {
                                                    selectedForecast =
                                                        newSelectedForecast;
                                                    _updateChartData();
                                                  });
                                                },
                                                btnNames: const [
                                                  '기온',
                                                  '강수량',
                                                  '습도'
                                                ],
                                                selectedBtn: '기온',
                                              ),
                                              const SizedBox(height: 8),
                                              YearButtonWidget(
                                                availableYears: availableYears,
                                                selectedYears: selectedYears,
                                                onYearsChanged:
                                                    (updatedSelectedYears) {
                                                  setState(() {
                                                    selectedYears =
                                                        updatedSelectedYears;
                                                    _updateChartData();
                                                  });
                                                },
                                                yearColorMap: yearColorMap,
                                                isContinuousView:
                                                    isContinuousView,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              GrowthChart(
                                                selectedYears: selectedYears,
                                                currentProductionData:
                                                    currentProductionData,
                                                isContinuousView:
                                                    isContinuousView,
                                                onToggleView: (bool newValue) {
                                                  setState(() {
                                                    isContinuousView = newValue;
                                                  });
                                                },
                                                yearColorMap: yearColorMap,
                                                unit: selectedForecast == '기온'
                                                    ? '(°C)'
                                                    : '',
                                                hoverText:
                                                    selectedForecast == '기온'
                                                        ? 'point.x : point.y°F'
                                                        : 'point.x : point.y°',
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const CustomTextWidget(
                                            text: 'Forecast'),
                                        Container(
                                          padding: const EdgeInsets.all(16.0),
                                          color: Colors.white,
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text('Growth Status',
                                                  style: AppTextStyle.medium16),
                                              GrowthTableWidget(
                                                dataRows: [
                                                  [
                                                    'Growth Days(D+7)',
                                                    'Day ${growthPredData['growthStatusPred']['daysFromSowingPred']}'
                                                  ],
                                                  [
                                                    'Growth Rate',
                                                    '${growthPredData['growthStatusPred']['overallProgressPred']}%'
                                                  ],
                                                  [
                                                    'Forecast Phase',
                                                    getGrowthStageInEng(
                                                        calculateGrowthStage(
                                                            growthPredData[
                                                                    'growthStatusPred']
                                                                [
                                                                'overallProgressPred'],
                                                            growthPredData[
                                                                'growthStages']))
                                                  ],
                                                  [
                                                    'Days to Harvest',
                                                    '${calculateDaysUntilHarvest(growthPredData['growthStatusPred']['estimatedHarvestDatePred'])} days'
                                                  ],
                                                  [
                                                    'Forecast Harvest',
                                                    '${growthPredData['growthStatusPred']['estimatedHarvestDatePred']}'
                                                  ],
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              ProgressBarWidget(
                                                progressRate: growthPredData[
                                                            'growthStatusPred'][
                                                        'overallProgressPred'] /
                                                    100,
                                                barColor: 'pred',
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        '${growthPredData['growthStatusPred']['sowingDate']}',
                                                        style: AppTextStyle
                                                            .light12),
                                                    const Spacer(),
                                                    Text(
                                                        '${growthPredData['growthStatusPred']['estimatedHarvestDatePred']}',
                                                        style: AppTextStyle
                                                            .light12),
                                                  ],
                                                ),
                                              ),
                                              StageBarWidget(
                                                growthStages: growthActualData[
                                                    'growthStages'],
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              const Text('Growth Environment',
                                                  style: AppTextStyle.medium16),
                                              GrowthTableWidget(
                                                dataRows: [
                                                  [
                                                    'Forecast Temp',
                                                    '${growthPredData['forecastDataPred']['current']['temperature']}${growthPredData['forecastDataPred']['current']['unit']}'
                                                  ],
                                                  [
                                                    'Optimal Temp',
                                                    '$optimumTemp${growthActualData['forecastData']['current']['unit']}'
                                                  ],
                                                  [
                                                    'Compared to Optimal',
                                                    '${formatArrowIndicator(growthPredData['forecastDataPred']['current']['changes']['Optimum'])}(${formatPositiveValue(growthPredData['forecastDataPred']['current']['changes']['Optimum_rate'])})'
                                                  ],
                                                  [
                                                    '1-Week Avg. Temp',
                                                    '${formatArrowIndicator(growthPredData['forecastDataPred']['current']['changes']['LastYear'])}(${formatPositiveValue(growthPredData['forecastDataPred']['current']['changes']['LastYear_rate'])})'
                                                  ],
                                                  [
                                                    '2-Week Avg. Temp',
                                                    '${formatArrowIndicator(growthPredData['forecastDataPred']['current']['changes']['CommonYear'])}(${formatPositiveValue(growthPredData['forecastDataPred']['current']['changes']['CommonYear_rate'])})'
                                                  ],
                                                ],
                                              ),
                                              GradeButtonWidget(
                                                onGradeChanged:
                                                    (newSelectedForecast) {
                                                  setState(() {
                                                    selectedPredForecast =
                                                        newSelectedForecast;
                                                    _updateChartData();
                                                  });
                                                },
                                                btnNames: const [
                                                  '기온',
                                                  '강수량',
                                                  '습도'
                                                ],
                                                selectedBtn: '기온',
                                              ),
                                              const SizedBox(height: 8),
                                              GradeButtonWidget(
                                                onGradeChanged:
                                                    (newSelectedForecast) {
                                                  setState(() {
                                                    selectedPredYear =
                                                        newSelectedForecast;
                                                    _updateChartData();
                                                  });
                                                },
                                                btnNames: availablePredYears,
                                                selectedBtn:
                                                    availablePredYears[0],
                                              ),
                                              GrowthTrendChart(
                                                latestPred: predProductionData,
                                                date: date,
                                                actualName: 'Current',
                                                predictedName: 'Predicted',
                                                unit: '',
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const CustomTextWidget(
                                            text: 'Diagnosis'),
                                        Container(
                                          padding: const EdgeInsets.all(16.0),
                                          color: Colors.white,
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                  'Standard Cost (Seed-Harvest)',
                                                  style: AppTextStyle.medium16),
                                              CostTableWidget(
                                                costData: {
                                                  'Fertilizer': calculationData[
                                                      'fertilizer'],
                                                  'pesticide': calculationData[
                                                      'pesticide'],
                                                  'Electricity':
                                                      calculationData[
                                                          'electricity'],
                                                  'Water':
                                                      calculationData['water'],
                                                  'Gas': calculationData['gas'],
                                                  'Etc': calculationData['etc'],
                                                },
                                              ),
                                              // 도넛 차트
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      child: DoughnutChart(
                                                        value: calculationData[
                                                                'CurrentCost'] /
                                                            calculationData[
                                                                'FinalCost'] *
                                                            100,
                                                        title: 'Std. Cost Rate',
                                                        color: const Color(
                                                            0xFFFFBB00),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      child: DoughnutChart(
                                                        value: calculationData[
                                                            'RevenueRate'],
                                                        title:
                                                            'Std. Profit Rate',
                                                        color: const Color(
                                                            0xFFFF9900),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Text('Std. Cost Calc',
                                                  style: AppTextStyle.medium16),
                                              CalculatorTable(data: {
                                                '현재 성장률': growthActualData[
                                                            'growthStatus']
                                                        ['overallProgress']
                                                    .toInt(),
                                                '단위': calculationData[
                                                    'CurrencyUnit'],
                                                '수익률': calculationData[
                                                    'RevenueRate'],
                                                '현재비용': calculationData[
                                                    'CurrentCost'],
                                                '최종비용': calculationData[
                                                    'FinalCost'],
                                                'Avg. Std. Revenue':
                                                    calculationData[
                                                        'StandardAverageSales'],
                                                'Avg. Std. Profit':
                                                    calculationData[
                                                        'StandardAverageProfit'],
                                              }),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Text('Actual Cost (Now)',
                                                  style: AppTextStyle.medium16),
                                              CostInputTableWidget(
                                                costData: costData,
                                                onTotalCostChanged:
                                                    updateTotalCost,
                                              ),
                                              // 도넛 차트
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      child: DoughnutChart(
                                                        value: currentCostRatio,
                                                        title:
                                                            'Current Cost Rate',
                                                        color: const Color(
                                                            0xFF78B060),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      child: DoughnutChart(
                                                        value:
                                                            estimatedProfitRatio,
                                                        title:
                                                            'Expected Profit Rate',
                                                        color: const Color(
                                                            0xFF309975),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Text('Actual Cost Calc',
                                                  style: AppTextStyle.medium16),
                                              CalculatorTable(
                                                data: generateCalculationData(
                                                  growthActualData:
                                                      growthActualData,
                                                  calculationData:
                                                      calculationData,
                                                  totalCost: totalCost,
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 20,
                                              ),
                                              DiagnosisTableWidget(
                                                  diagnosisData: todoData),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Footer(),
                              ],
                            )
                          : const Text('Loading'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
