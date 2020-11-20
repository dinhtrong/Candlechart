import 'package:flutter/material.dart';
import 'package:candleline/view/market_chart_candle_view.dart';
import 'package:candleline/view/market_chart_columnar_view.dart';
import 'package:candleline/view/market_chart_solide_view.dart';
import 'package:candleline/view/market_chart_separate_view.dart';
import 'package:candleline/view/market_chart_area_view.dart';
import 'package:candleline/bloc/market_chart_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';

class MarketChartSingleView extends StatelessWidget {
  const MarketChartSingleView({
    Key key,
    @required this.type,
  });
  final int type;

  @override
  Widget build(BuildContext context) {
    final MarketChartBloc mkBloc = BlocProvider.of<MarketChartBloc>(context);
    return StreamBuilder(
        stream: mkBloc.outRealTimeOpen,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          bool isOpenRealTime = false;
          if (snapshot.data != null) {
            isOpenRealTime = snapshot.data;
          }
          if (type == 0) {
            List<Widget> widgetList = <Widget>[];
            if (isOpenRealTime == true) {
              widgetList = <Widget>[MarketChartSeparateView(type: 0), MarketChartAreaView()];
            } else {
              widgetList = <Widget>[
                MarketChartSeparateView(type: 0),
                MarketChartCandleView(),
                MarketChartSolideView(type: 0),
                MarketChartSolideView(type: 1),
                MarketChartSolideView(type: 2)
              ];
            }
            return Container(
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: widgetList,
              ),
            );
          } else {
            List<Widget> widgetList = <Widget>[];
            if (isOpenRealTime == true) {
              widgetList = <Widget>[
                MarketChartSeparateView(type: 1),
                MarketChartColumnarView(type: 1),
              ];
            } else {
              widgetList = <Widget>[
                MarketChartSeparateView(type: 1),
                MarketChartColumnarView(type: 0),
              ];
            }
            return Container(
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: widgetList,
              ),
            );
          }});
  }
}
