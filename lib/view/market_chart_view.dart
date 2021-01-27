import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:candleline/bloc/market_chart_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/market_chart_model.dart';
import 'package:candleline/view/market_chart_single_view.dart';
class MarketChartPage extends StatefulWidget {
  const MarketChartPage({Key key, @required this.bloc}) : super(key: key);
  final MarketChartBloc bloc;
  @override
  _MarketChartPageState createState() => _MarketChartPageState(bloc);
}

class _MarketChartPageState extends State<MarketChartPage> {
  _MarketChartPageState(this.bloc);
  MarketChartBloc bloc;
  int currentIndex = 0;
  @override
  void dispose() {
    currentIndex = 0;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Offset lastPoint;
    int offset;
    double lastScale;
    int count;
    double currentRectWidth;
    bool isScale = false;
    final ScrollController _controller = ScrollController(initialScrollOffset: bloc.rectWidth * bloc.stringList.length-bloc.screenWidth);
    _controller.addListener(() {
      print(_controller.offset);
      currentIndex = (_controller.offset ~/ bloc.rectWidth).toInt();
      if (currentIndex < 0) {
        return;
      } else if (currentIndex > bloc.stringList.length - count) {
        return;
      }
      bloc.currentIndex = currentIndex;
      if (currentIndex >= 0) {
        bloc.getSubMarketChartList(currentIndex, currentIndex + count);
      }
      
    });
    return BlocProvider<MarketChartBloc>(
      //key: PageStorageKey('market'),
        bloc: bloc,
        child: GestureDetector(
            onScaleStart: (ScaleStartDetails details) {
              currentRectWidth = bloc.rectWidth;
              isScale = true;
            },
            onScaleUpdate: (ScaleUpdateDetails details) {
              final double scale = details.scale;
              if (scale == 1.0) {
                return;
              }
              print(details.scale);
              lastScale = details.scale;
              final double rectWidth = scale * currentRectWidth;
              count =
                  (MediaQuery.of(context).size.width ~/ bloc.rectWidth).toInt();
              bloc.setRectWidth(rectWidth);
              bloc.getSubMarketChartList(
                  bloc.currentIndex, bloc.currentIndex + count);
            },
            onScaleEnd: (ScaleEndDetails details) {
              isScale = false;
            },
            child: StreamBuilder<List<Market>>(
                stream: bloc.outMarketChartList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Market>> snapshot) {
                  return  OrientationBuilder(
                    builder: (context, orientation) {
                      final List<Market> data = snapshot.data ?? <Market>[];
                      final double width = MediaQuery.of(context).size.width;
                      count = (width ~/ bloc.rectWidth).toInt();
                      if (orientation == Orientation.landscape) {
                        bloc.setRectWidth(14);
                      } else {
                        bloc.setRectWidth(7);
                      }
                      if (data.isNotEmpty && data != null && currentIndex >= 0) {
                        if ((currentIndex + count) < data.length) {
                          bloc.getSubMarketChartList(currentIndex, currentIndex + count);
                        } else {
                          bloc.getSubMarketChartList(0, data.length);
                        }
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
                                // Expanded(
                                //   child: Container(
                                //     color: Colors.black,
                                //     child: const MarketChartSingleView(type: 1),
                                //   ),
                                //   flex: 4,
                                // ),
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
                    },
                  ); ;
                })));

  }
}
