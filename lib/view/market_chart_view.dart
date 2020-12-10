import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:candleline/bloc/market_chart_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/market_chart_model.dart';
import 'package:candleline/view/market_chart_single_view.dart';

class MarketChartPage extends StatelessWidget {
  const MarketChartPage({Key key, @required this.bloc}) : super(key: key);
  final MarketChartBloc bloc;
  @override
  Widget build(BuildContext context) {
    Offset lastPoint;
    int offset;
    double lastScale;
    int count;
    double currentRectWidth;
    bool isScale = false;
    ScrollController _controller = ScrollController(initialScrollOffset: bloc.rectWidth * bloc.stringList.length-bloc.screenWidth);
    _controller.addListener(() {
      print(_controller.offset);
      int currentIndex = (_controller.offset ~/ bloc.rectWidth).toInt();
      if (currentIndex < 0) {
        return;
      } else if (currentIndex > bloc.stringList.length - count) {
        return;
      }
      bloc.currentIndex = currentIndex;
      bloc.getSubMarketChartList(currentIndex, currentIndex + count);
    });

    return BlocProvider<MarketChartBloc>(
        //key: PageStorageKey('market'),
        bloc: bloc,
        child: GestureDetector(
            onScaleStart: (details) {
              currentRectWidth = bloc.rectWidth;
              isScale = true;
            },
            onScaleUpdate: (details) {
              double scale = details.scale;
              if (scale == 1.0) {
                return;
              }
              print(details.scale);
              lastScale = details.scale;
              double rectWidth = scale * currentRectWidth;
              count =
                  (MediaQuery.of(context).size.width ~/ bloc.rectWidth).toInt();
              bloc.setRectWidth(rectWidth);
              bloc.getSubMarketChartList(
                  bloc.currentIndex, bloc.currentIndex + count);
            },
            onScaleEnd: (details) {
              isScale = false;
            },
            child: StreamBuilder(
                stream: bloc.outMarketChartList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Market>> snapshot) {
                  List<Market> data = snapshot.data ?? <Market>[];
                  if (data != null) {
                    double width = MediaQuery.of(context).size.width;
                    count = (width ~/ bloc.rectWidth).toInt();
                    bloc.setScreenWith(width);
                    // _controller.jumpTo(bloc.rectWidth * bloc.stringList.length-bloc.screenWidth);
                  }
                  return Container(
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                color: Colors.black,
                                child: const MarketChartSingleView(type: 0),
                              ),
                              flex: 20,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.black,
                                child: const MarketChartSingleView(type: 1),
                              ),
                              flex: 4,
                            ),
                          ],
                        ),
                        Scrollbar(
                            child: SingleChildScrollView(
                                child: Container(
                                  width: bloc.rectWidth * data.length,
                                ),
                                controller: _controller,
                                scrollDirection: Axis.horizontal,
                                )),
                      ],
                    ),
                  );
                })));
  }
}
