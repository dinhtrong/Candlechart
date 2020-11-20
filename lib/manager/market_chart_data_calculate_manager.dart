import 'package:candleline/model/market_chart_model.dart';

enum ChartType {
  UnKnow,
  MA,
  BOLL,
  VOL,
  MACD,
  KDJ,
  RSI,
  WR
}

mixin MarketChartDataCalculateManager {

  static final List<int> kPriceMaList = <int>[5, 10, 30];
  static final List<int> kVolumeMaList = <int>[5, 10];

  static List<Market> calculateMarketChartData(ChartType type, List<Market> dataList) {

    switch (type) {
      case ChartType.MA: {
        return _calculatePriceMa(dataList);
      }
      case ChartType.VOL: {
        return _calculateVolumeMa(dataList);
      }
      default: {
        return dataList;
      }
    }
  }

  static List<Market> _calculatePriceMa(List<Market> dataList) {
    final List<Market> tmpList = dataList;
    for(int numIndex = 0; numIndex < kPriceMaList.length; numIndex ++) {
      final int num = kPriceMaList[numIndex];
      if (num <= 0) {
        return tmpList;
      }
      for(int nIndex = 0; nIndex < tmpList.length; nIndex ++) {
        final Market data = tmpList[nIndex];
        if((numIndex == 0 && data.priceMa1 != null) ||
            (numIndex == 0 && data.priceMa2 != null) ||
            (numIndex == 0 && data.priceMa3 != null)) {
          return tmpList;
        }
        if(nIndex + 1 >= num) {
          Market lastData;
          if(nIndex > 0) {
            lastData = tmpList[nIndex - 1];
          }
          double lastMa;
          if(lastData != null) {
            switch (numIndex) {
              case 0: {
                lastMa = lastData.priceMa1;
                break;
              }
              case 1: {
                lastMa = lastData.priceMa2;
                break;
              }
              case 2: {
                lastMa = lastData.priceMa3;
                break;
              }
              default:{
                break;
              }
            }
          }
          double priceMa = 0;
          if(lastMa != null) {
            final Market deleteData = tmpList[nIndex - num];
            priceMa = lastMa * num + data.close - deleteData.close;
          } else {
            final List<Market> aveArray = tmpList.sublist(nIndex - num + 1, num);
            for(final Market tmpData in aveArray) {
              priceMa += tmpData.close;
            }
          }
          priceMa = priceMa / num;
          switch (numIndex) {
            case 0: {
              tmpList[nIndex].priceMa1 = priceMa;
              break;
            }
            case 1: {
              tmpList[nIndex].priceMa2 = priceMa;
              break;
            }
            case 2: {
              tmpList[nIndex].priceMa3 = priceMa;
              break;
            }
            default: {
              break;
            }
          }
        }
      }
    }
    return tmpList;
  }

  static List<Market> _calculateVolumeMa(List<Market> dataList) {
    return dataList;

  }




}
