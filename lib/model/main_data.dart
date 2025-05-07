class MainData {
  final String commodity;
  final String optimalPurchaseTime;
  final PriceInfo priceInfo;
  final GrowthInfo growthInfo;
  final CropInfo cropInfo;

  MainData({
    required this.commodity,
    required this.optimalPurchaseTime,
    required this.priceInfo,
    required this.growthInfo,
    required this.cropInfo,
  });

  factory MainData.fromJson(Map<String, dynamic> json) {
    return MainData(
      commodity: json['commodity'] ?? '',
      optimalPurchaseTime: json['optimal_purchase_time'] ?? '',
      priceInfo: PriceInfo.fromJson(json['price_info'] ?? {}),
      growthInfo: GrowthInfo.fromJson(json['growth_info'] ?? {}),
      cropInfo: CropInfo.fromJson(json['crop_info'] ?? {}),
    );
  }
}

class PriceInfo {
  final String currentDate;
  final String predictedDate;
  final double currentPrice;
  final double rateCurrentPrice;
  final double previousPrice;
  final double ratePreviousPrice;
  final double lastYearPrice;
  final double rateLastYearPrice;
  final double averagePrice;
  final double rateAveragePrice;
  final double predictedPrice;
  final double amountValue;
  final double percentageChangeValue;
  final double accuracy;
  final double outOfRangeProbability;
  final double stabilityProbability;
  final List<double?> actualPrices;
  final List<double?> predictedPrices;
  final List<String> date;

  PriceInfo({
    required this.currentDate,
    required this.predictedDate,
    required this.currentPrice,
    required this.rateCurrentPrice,
    required this.previousPrice,
    required this.ratePreviousPrice,
    required this.lastYearPrice,
    required this.rateLastYearPrice,
    required this.averagePrice,
    required this.rateAveragePrice,
    required this.predictedPrice,
    required this.amountValue,
    required this.percentageChangeValue,
    required this.accuracy,
    required this.outOfRangeProbability,
    required this.stabilityProbability,
    required this.actualPrices,
    required this.predictedPrices,
    required this.date,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      currentDate: json['current_date'] ?? '',
      predictedDate: json['predicted_date'] ?? '',
      currentPrice: json['current_price']?.toDouble() ?? 0.0,
      rateCurrentPrice: json['rate_current_price']?.toDouble() ?? 0.0,
      previousPrice: json['previous_price']?.toDouble() ?? 0.0,
      ratePreviousPrice: json['rate_previous_price']?.toDouble() ?? 0.0,
      lastYearPrice: json['last_year_price']?.toDouble() ?? 0.0,
      rateLastYearPrice: json['rate_last_year_price']?.toDouble() ?? 0.0,
      averagePrice: json['average_price']?.toDouble() ?? 0.0,
      rateAveragePrice: json['rate_average_price']?.toDouble() ?? 0.0,
      predictedPrice: json['predicted_price']?.toDouble() ?? 0.0,
      amountValue: json['amount_value']?.toDouble() ?? 0.0,
      percentageChangeValue: json['percentage_change_value']?.toDouble() ?? 0.0,
      accuracy: json['accuracy']?.toDouble() ?? 0.0,
      outOfRangeProbability:
          json['out_of_range_probability']?.toDouble() ?? 0.0,
      stabilityProbability: json['stability_probability']?.toDouble() ?? 0.0,
      actualPrices: List<double?>.from(
          (json['actual_prices'] ?? []).map((x) => x?.toDouble())),
      predictedPrices: List<double?>.from(
          (json['predicted_prices'] ?? []).map((x) => x?.toDouble())),
      date: List<String>.from(json['date'] ?? []),
    );
  }
}

class GrowthInfo {
  final String currentDate;
  final String predictedDate;
  final double currentGrowthRate;
  final double forecastedGrowthRate;
  final double growthDifference;
  final double standardProfit;
  final dynamic forecastedProfit;
  final double standardProduction;
  final dynamic forecastedProduction;
  final String standardHarvestDate;
  final String forecastedHarvestDate;
  final double? currentTemperature;
  final double? forecastedTemperature;
  final double? differenceValue;
  final double? differenceRate;
  final double? optimalComparisonValue;
  final double? optimalComparisonRate;
  final double? yearOnYearValue;
  final double? yearOnYearRate;
  final double? averageComparisonValue;
  final double? averageComparisonRate;
  final List<double?> actualTemperatures;
  final List<double?> predictedTemperatures;
  final List<String> date;

  GrowthInfo({
    required this.currentDate,
    required this.predictedDate,
    required this.currentGrowthRate,
    required this.forecastedGrowthRate,
    required this.growthDifference,
    required this.standardProfit,
    required this.forecastedProfit,
    required this.standardProduction,
    required this.forecastedProduction,
    required this.standardHarvestDate,
    required this.forecastedHarvestDate,
    this.currentTemperature,
    this.forecastedTemperature,
    this.differenceValue,
    this.differenceRate,
    this.optimalComparisonValue,
    this.optimalComparisonRate,
    this.yearOnYearValue,
    this.yearOnYearRate,
    this.averageComparisonValue,
    this.averageComparisonRate,
    required this.actualTemperatures,
    required this.predictedTemperatures,
    required this.date,
  });

  factory GrowthInfo.fromJson(Map<String, dynamic> json) {
    return GrowthInfo(
      currentDate: json['current_date'] ?? '',
      predictedDate: json['predicted_date'] ?? '',
      currentGrowthRate: json['current_growth_rate']?.toDouble() ?? 0.0,
      forecastedGrowthRate: json['forecasted_growth_rate']?.toDouble() ?? 0.0,
      growthDifference: json['growth_difference']?.toDouble() ?? 0.0,
      standardProfit: json['standard_profit']?.toDouble() ?? 0.0,
      forecastedProfit: json['forecasted_profit'],
      standardProduction: json['standard_production']?.toDouble() ?? 0.0,
      forecastedProduction: json['forecasted_production'],
      standardHarvestDate: json['standard_harvest_date'] ?? '',
      forecastedHarvestDate: json['forecasted_harvest_date'] ?? '',
      currentTemperature: json['current_temperature'],
      forecastedTemperature: json['forecasted_temperature'],
      differenceValue: json['difference_value'],
      differenceRate: json['difference_rate'],
      optimalComparisonValue: json['optimal_comparison_value'],
      optimalComparisonRate: json['optimal_comparison_rate'],
      yearOnYearValue: json['year_on_year_value'],
      yearOnYearRate: json['year_on_year_rate'],
      averageComparisonValue: json['average_comparison_value'],
      averageComparisonRate: json['average_comparison_rate'],
      actualTemperatures: List<double?>.from(json['actual_temperatures'] ?? []),
      predictedTemperatures:
          List<double?>.from(json['predicted_temperatures'] ?? []),
      date: List<String>.from(json['date'] ?? []),
    );
  }
}

class CropInfo {
  final String currentDate;
  final String predictedDate;
  final dynamic actualProductionCurrentYear;
  final dynamic forecastedProductionNextYear;
  final dynamic standardComparisonValue;
  final dynamic standardComparisonRate;
  final dynamic averageYield;
  final dynamic lastYearYield;
  final dynamic productionPer10a;
  final dynamic range;
  final dynamic rangeOutProbability;
  final dynamic stabilityProbability;
  final List<dynamic> actualProductions;
  final List<dynamic> predictedProductions;
  final List<String> date;

  CropInfo({
    required this.currentDate,
    required this.predictedDate,
    required this.actualProductionCurrentYear,
    required this.forecastedProductionNextYear,
    required this.standardComparisonValue,
    required this.standardComparisonRate,
    required this.averageYield,
    required this.lastYearYield,
    required this.productionPer10a,
    required this.range,
    required this.rangeOutProbability,
    required this.stabilityProbability,
    required this.actualProductions,
    required this.predictedProductions,
    required this.date,
  });

  factory CropInfo.fromJson(Map<String, dynamic> json) {
    return CropInfo(
      currentDate: json['current_date'] ?? '',
      predictedDate: json['predicted_date'] ?? '',
      actualProductionCurrentYear: json['actual_production_current_year'],
      standardComparisonValue: json['forecasted_production_next_year'],
      forecastedProductionNextYear: json['standard_comparison_value'],
      standardComparisonRate: json['standard_comparison_rate'],
      averageYield: json['average_yield'],
      lastYearYield: json['last_year_yield'],
      productionPer10a: json['production_per_10a'],
      range: json['range'],
      rangeOutProbability: json['range_out_probability'],
      stabilityProbability: json['stability_probability'],
      actualProductions: List<dynamic>.from(json['actual_productions'] ?? []),
      predictedProductions:
          List<dynamic>.from(json['predicted_productions'] ?? []),
      date: List<String>.from(json['date'] ?? []),
    );
  }
}
