import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:v4/model/main_data.dart';
import 'package:v4/screens/common/drawer.dart';
import 'package:v4/screens/common/footer.dart';
import 'package:v4/screens/common/style/text_styles.dart';
import 'package:v4/screens/common/widget/info_text.dart';
import 'package:v4/screens/common/widget/pred_curr_chart.dart';
import 'package:v4/screens/growth_info/widget/progress_bar.dart';
import 'package:v4/screens/main/widget/banner_card.dart';
import 'package:v4/screens/main/widget/main_table.dart';
import 'package:v4/screens/main/widget/main_table_top.dart';
import 'package:v4/screens/main/widget/more_btn.dart';
import 'package:v4/screens/utils/format/number_format.dart';
import 'package:v4/screens/utils/format/plus_minus.dart';
import 'package:v4/services/main_service.dart';
import 'package:v4/widgets/custom_app_bar.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  double progressValue = 0.3;
  String selectedLanguage = '한국어';
  String selectedProduct = "들깨";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<MainData> _mainDataFuture;
  final MainService _mainService = MainService();

  @override
  void initState() {
    super.initState();
    _mainDataFuture = _mainService.fetchMainData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // 프로필 버튼 동작 추가
        },
      ),
      extendBodyBehindAppBar: true,
      drawer: CustomDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<MainData>(
                future: _mainDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height:
                          MediaQuery.of(context).size.height - kToolbarHeight,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text("No Data Available"));
                  }

                  final mainData = snapshot.data!;
                  return Column(
                    children: [
                      MainCardWidget(
                        prod: mainData.commodity,
                        optimalPurchaseTime: mainData.optimalPurchaseTime,
                      ),
                      Container(
                        width: double.infinity,
                        color: const Color(0xFFF8F8F8),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1200),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 20),
                                  child: MoreButtonWidget(
                                    title: 'PRICE INFO',
                                    onPressed: () {
                                      context.go('/price_info');
                                    },
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InfoTextWidget(
                                          text:
                                              'Export price per ton(dollars)'),
                                      MainTopRowWidget(dataRows: [
                                        {
                                          'Current(${mainData.priceInfo.currentDate})':
                                              formatCurrency(mainData
                                                  .priceInfo.currentPrice)
                                        },
                                        {
                                          'Predicted(${mainData.priceInfo.predictedDate})':
                                              formatCurrency(mainData
                                                  .priceInfo.predictedPrice)
                                        },
                                        {
                                          'Compared to Current':
                                              '${formatCurrency(mainData.priceInfo.amountValue)}(${mainData.priceInfo.percentageChangeValue}%)'
                                        },
                                      ]),
                                      MainTableWidget(
                                        dataRows: [
                                          [
                                            'Previous',
                                            '${formatArrowIndicator(mainData.priceInfo.previousPrice)}\n(${formatPositiveValue(mainData.priceInfo.ratePreviousPrice)})'
                                          ],
                                          [
                                            'Last Year',
                                            '${formatArrowIndicator(mainData.priceInfo.lastYearPrice)}\n(${formatPositiveValue(mainData.priceInfo.rateLastYearPrice)})'
                                          ],
                                          [
                                            'Avg. Year',
                                            '${formatArrowIndicator(mainData.priceInfo.averagePrice)}\n(${formatPositiveValue(mainData.priceInfo.rateAveragePrice)})'
                                          ],
                                          [
                                            'Accuracy',
                                            '${mainData.priceInfo.accuracy}%'
                                          ],
                                          [
                                            'Out-of-Range Probability',
                                            '${mainData.priceInfo.outOfRangeProbability}%'
                                          ],
                                          [
                                            'Stability Probability',
                                            '${mainData.priceInfo.stabilityProbability}%'
                                          ],
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      TrendChart(
                                        latestPred:
                                            mainData.priceInfo.predictedPrices,
                                        latestActual:
                                            mainData.priceInfo.actualPrices,
                                        date: mainData.priceInfo.date,
                                        actualName: 'Current',
                                        predictedName: 'Predicted',
                                        unit: '(dollars)',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 20),
                                  child: MoreButtonWidget(
                                    title: 'GROWTH INFO',
                                    onPressed: () {
                                      context.go('/growth_info');
                                    },
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      MainTopRowWidget(dataRows: [
                                        {
                                          'Standard(${mainData.growthInfo.currentDate})':
                                              '${mainData.growthInfo.currentGrowthRate}%'
                                        },
                                        {
                                          'Forecast(${mainData.growthInfo.predictedDate})':
                                              '${mainData.growthInfo.forecastedGrowthRate}%'
                                        },
                                        {
                                          'Compared to Standard':
                                              formatPositiveValue(mainData
                                                  .growthInfo.growthDifference)
                                        },
                                      ]),
                                      MainTableWidget(
                                        dataRows: [
                                          [
                                            'Standard Harvest',
                                            mainData
                                                .growthInfo.standardHarvestDate
                                          ],
                                          [
                                            'Standard Profit',
                                            formatCurrency(mainData
                                                .growthInfo.standardProfit)
                                          ],
                                          [
                                            'Standard Yield',
                                            formatCurrency(mainData
                                                .growthInfo.standardProduction)
                                          ],
                                          [
                                            'Forecast Harvest',
                                            mainData.growthInfo
                                                .forecastedHarvestDate
                                          ],
                                          [
                                            'Forecast Profit',
                                            formatCurrency(mainData
                                                .growthInfo.forecastedProfit)
                                          ],
                                          [
                                            'Forecast Yield',
                                            formatCurrency(mainData.growthInfo
                                                .forecastedProduction)
                                          ],
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Current',
                                              style: AppTextStyle.regular12,
                                            ),
                                            Spacer(),
                                            Text(
                                              '100%',
                                              style: AppTextStyle.regular12,
                                            ),
                                          ],
                                        ),
                                      ),
                                      ProgressBarWidget(
                                        progressRate: mainData
                                                .growthInfo.currentGrowthRate /
                                            100,
                                        barColor: 'curr',
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Predicted',
                                              style: AppTextStyle.regular12,
                                            ),
                                            Spacer(),
                                            Text(
                                              '100%',
                                              style: AppTextStyle.regular12,
                                            ),
                                          ],
                                        ),
                                      ),
                                      ProgressBarWidget(
                                        progressRate: mainData.growthInfo
                                                .forecastedGrowthRate /
                                            100,
                                        barColor: 'pred',
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      InfoTextWidget(
                                          text:
                                              'Optimal Temperature for \'Growth Phase\': 25°C'),
                                      MainTopRowWidget(dataRows: [
                                        {
                                          'Current(${mainData.growthInfo.currentDate})':
                                              '${mainData.growthInfo.currentTemperature}℃'
                                        },
                                        {
                                          'Forecast(${mainData.growthInfo.predictedDate})':
                                              '${mainData.growthInfo.forecastedTemperature}℃'
                                        },
                                        {
                                          'Compared to Current':
                                              '${mainData.growthInfo.differenceValue}℃(${formatPositiveValue(mainData.growthInfo.differenceRate)})'
                                        },
                                      ]),
                                      MainTableWidget(
                                        dataRows: [
                                          [
                                            'Vs. Optimal',
                                            '${formatArrowIndicator(mainData.growthInfo.optimalComparisonValue)}(${formatPositiveValue(mainData.growthInfo.optimalComparisonRate)})'
                                          ],
                                          [
                                            'Vs. Last Year',
                                            '${formatArrowIndicator(mainData.growthInfo.yearOnYearValue)}(${formatPositiveValue(mainData.growthInfo.yearOnYearRate)})'
                                          ],
                                          [
                                            'Vs. Avg. Year',
                                            '${formatArrowIndicator(mainData.growthInfo.averageComparisonValue)}(${formatPositiveValue(mainData.growthInfo.averageComparisonRate)})'
                                          ],
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      TrendChart(
                                        latestPred: mainData
                                            .growthInfo.predictedTemperatures,
                                        latestActual: mainData
                                            .growthInfo.actualTemperatures,
                                        date: mainData.growthInfo.date,
                                        actualName: 'Current',
                                        predictedName: 'Forecast',
                                        unit: '(℃)',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 20),
                                  child: MoreButtonWidget(
                                    title: 'CULTIVATION INFO',
                                    onPressed: () {
                                      context.go('/crop_info');
                                    },
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MainTopRowWidget(dataRows: [
                                        {
                                          'Actual(${mainData.cropInfo.currentDate})':
                                              formatCurrency(mainData.cropInfo.actualProductionCurrentYear)
                                        },
                                        {
                                          'Predicted(${mainData.cropInfo.predictedDate})':
                                              formatCurrency(mainData.cropInfo.forecastedProductionNextYear)
                                        },
                                        {
                                          'Compared to Standard':
                                              '${mainData.cropInfo.standardComparisonValue}(${mainData.cropInfo.standardComparisonRate})'
                                        },
                                      ]),
                                      MainTableWidget(
                                        dataRows: [
                                          [
                                            'Avg. Year',
                                            formatCurrency(mainData.cropInfo.averageYield)
                                          ],
                                          [
                                            'Last Year',
                                            formatCurrency(mainData.cropInfo.lastYearYield)
                                          ],
                                          [
                                            'Yield per 10a',
                                            '${mainData.cropInfo.productionPer10a}'
                                          ],
                                          [
                                            'Range',
                                            '${mainData.cropInfo.range}'
                                          ],
                                          [
                                            'Out-of-Range Probability',
                                            '${mainData.cropInfo.rangeOutProbability}'
                                          ],
                                          [
                                            'Stability Probability',
                                            '${mainData.cropInfo.stabilityProbability}'
                                          ],
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      TrendChart(
                                        latestPred: mainData
                                            .cropInfo.predictedProductions,
                                        latestActual:
                                            mainData.cropInfo.actualProductions,
                                        date: mainData.cropInfo.date,
                                        actualName: 'Actual',
                                        predictedName: 'Predicted',
                                        unit: '(ton)',
                                      ),
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
                      ),
                      const Footer(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
