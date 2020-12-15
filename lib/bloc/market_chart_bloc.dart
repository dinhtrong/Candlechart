import 'dart:math';
import 'package:rxdart/rxdart.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/market_chart_model.dart';
import 'package:candleline/manager/market_chart_data_calculate_manager.dart';
import 'package:candleline/model/market_chart_data.dart';
class MarketChartBloc extends BlocBase {
  MarketChartBloc() {
    initData();
  }
  final BehaviorSubject<List<Market>> marketChartListController =
      BehaviorSubject<List<Market>>();
  final BehaviorSubject<List<Market>> marketChartCurrentListController =
      BehaviorSubject<List<Market>>();
  final PublishSubject<bool> marketChartRealTimeOpenController =
      PublishSubject<bool>();

  Sink<List<Market>> get _inMarketChartList => marketChartListController.sink;
  Stream<List<Market>> get outMarketChartList => marketChartListController.stream;

  Sink<List<Market>> get _inCurrentMarketChartList =>
      marketChartCurrentListController.sink;
  Stream<List<Market>> get outCurrentMarketChartList =>
      marketChartCurrentListController.stream;

  Sink<bool> get _inRealTimeOpen => marketChartRealTimeOpenController.sink;
  Stream<bool> get outRealTimeOpen => marketChartRealTimeOpenController.stream; 

  List<Market> marketChartList = <Market>[];
  List<Market> stringList = <Market>[];
  bool realTimeOpen = false;

  int currentIndex = 0;

  double rectWidth = 7.0;
  double screenWidth = 375;

  double priceMax;
  double priceMin;
  double volumeMax;

  void initData() {

  }
  @override
  void dispose() {
    marketChartListController.close();
    marketChartCurrentListController.close();
    marketChartRealTimeOpenController.close();
  }

  void updateDataList(List<MarketChartData> dataList) {
    if (dataList != null && dataList.isNotEmpty) {
      stringList.clear();
      for (final MarketChartData item in dataList) {
        final Market data = Market(item.open, item.high, item.low, item.close, item.vol, item.date);
        stringList.add(data);
      }
      stringList = MarketChartDataCalculateManager.calculateMarketChartData(ChartType.MA, stringList);
      _inMarketChartList.add(stringList);
    }
  }
  void openRealTime(bool isOpen) {
    realTimeOpen = isOpen;
    _inRealTimeOpen.add(isOpen);
  }

  void setScreenWith(double width) {
    screenWidth = width;
    final double count = screenWidth / rectWidth;
    final int num =  count.toInt();
    if (stringList.length - num > 0) {
      currentIndex = stringList.length - num;
      getSubMarketChartList(stringList.length - num, stringList.length);
    }
  }

  void getSubMarketChartList(int from, int to) {
    final List<Market> list = stringList;
    marketChartList = list.sublist(from,to);
    calculateLimit();
    _inCurrentMarketChartList.add(marketChartList);
  }

  void setRectWidth(double width) {
    if (width > 25.0 || width < 2.0) {
      return;
    }
    rectWidth = width;
  }
  
  void calculateLimit() {
    double _priceMax = -double.infinity;
    double _priceMin = double.infinity;
    double _volumeMax = -double.infinity;
    for (final Market i in marketChartList) {
      _volumeMax = max(i.volumeto, _volumeMax);

      _priceMax = max(_priceMax, i.high);
      _priceMin = min(_priceMin, i.low);

      if (i.priceMa1 != null) {
        _priceMax = max(_priceMax, i.priceMa1);
        _priceMin = min(_priceMin, i.priceMa1);
      }
      if (i.priceMa2 != null) {
        _priceMax = max(_priceMax, i.priceMa2);
        _priceMin = min(_priceMin, i.priceMa2);
      }
      if (i.priceMa3 != null) {
        _priceMax = max(_priceMax, i.priceMa3);
        _priceMin = min(_priceMin, i.priceMa3);
      }

    }
    priceMax = _priceMax;
    priceMin = _priceMin;
    volumeMax = _volumeMax;
  }      
}
