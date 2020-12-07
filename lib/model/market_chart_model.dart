import 'package:flutter/material.dart';

class Market{
  Market(this.open, this.high, this.low, this.close, this.volumeto, this.date);
  double open;
  double high;
  double low;
  double close;
  double volumeto;
  String date;

  double priceMa1;
  double priceMa2;
  double priceMa3;
  double volMa1;
  double volMa2;

}


class MarketChartModel {
  Color lineColor;

}

class MarketChartCandleModel extends MarketChartModel {
  MarketChartCandleModel(
      this.hPrice,
      this.lPrice,
      this.openPrice,
      this.closePrice,
      this.time,
      this.change,
      this.volume,
      this.business,
      this.changePrice
      );
  double hPrice;
  double lPrice;
  double openPrice;
  double closePrice;
  int time;
  double change;
  double volume;
  double business;
  double changePrice;

}

class MarketChartColumnarPriceData extends MarketChartModel {
  MarketChartColumnarPriceData(
      this.hPrice,
      this.lPrice
      );
  double hPrice;
  double lPrice;
}

class MarketChartCandleData {
  Offset hPoint;
  Offset lPoint;
  Offset openPoint;
  Offset closePoint;
  double hPrice;
  double lPrice;
  int nDataIndex;

}


