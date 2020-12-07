import 'package:flutter/material.dart';
import 'package:candleline/bloc/market_chart_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/market_chart_model.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart' show DateFormat;

class MarketChartSeparateView extends StatelessWidget {
  const MarketChartSeparateView({Key key, @required this.type});
  final int type;

  @override
  Widget build(BuildContext context) {
    final MarketChartBloc mkBloc = BlocProvider.of<MarketChartBloc>(context);
    return StreamBuilder(
        stream: mkBloc.outCurrentMarketChartList,
        builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
          final List<Market> tmpList = snapshot.data ?? <Market>[Market(0, 0, 0, 0, 0, '')];
          return CustomPaint(
              size: Size.infinite,
              painter: _SeparateViewPainter(
                type: type,
                data: tmpList,
                lineWidth: 0.5,
                rectWidth: mkBloc.rectWidth,
                max: mkBloc.priceMax,
                min: mkBloc.priceMin,
                maxVolume: mkBloc.volumeMax,
                lineColor: const Color.fromRGBO(255, 255, 255, 0.4),
              ));
        });
  }
}

class _SeparateViewPainter extends CustomPainter {
  _SeparateViewPainter({
    Key key,
    @required this.data,
    @required this.max,
    @required this.min,
    @required this.maxVolume,
    @required this.rectWidth,
    this.lineWidth = 1.0,
    this.lineColor = Colors.grey,
    this.type
  });

  final List<Market> data;
  final double lineWidth;
  final Color lineColor;
  final double max;
  final double min;
  final double maxVolume;
  final double rectWidth;
  final int type;

  @override
  void paint(Canvas canvas, Size size) {
    if (max == null || min == null) {
      return;
    }
    
    if (type == 0) {
      drawPriceLine(canvas, size);
    } else {
      drawVolumeLine(canvas, size);
    }

  }

  drawText(Canvas canvas, Offset offset, String text) {
    TextPainter textPainter = new TextPainter(
        text: new TextSpan(
            text: text,
            style: new TextStyle(
                color: lineColor, fontSize: 10.0, fontWeight: FontWeight.normal)),
        textDirection: TextDirection.rtl);
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  drawPriceLine(Canvas canvas, Size size) {
    double height = size.height - 20 - 20;
    double width = size.width;

    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth;

    double heightOffset = height / 4;
    canvas.drawLine(Offset(0, 20), Offset(width, 20), linePaint);
    canvas.drawLine(
        Offset(0, heightOffset + 20), Offset(width, heightOffset + 20), linePaint);
    canvas.drawLine(Offset(0, heightOffset * 2 + 20),
        Offset(width, heightOffset * 2 + 20), linePaint);
    canvas.drawLine(Offset(0, heightOffset * 3 + 20),
        Offset(width, heightOffset * 3 + 20), linePaint);
    canvas.drawLine(
        Offset(0, height - 1 + 20), Offset(width, height - 1 + 20), linePaint);

    int count = (data.length ~/ 4).toInt() + 1;

    for (var i = 1; i < 4; i++) {
          canvas.drawLine(Offset((i * count - 0.5) * rectWidth ,0), Offset((i * count - 0.5) * rectWidth,height + 20), linePaint);
    }

    double priceOffset = (max - min) / 4;
    double origin = width - max.toStringAsPrecision(7).length * 6;
    drawText(canvas, Offset(origin, 20), max.toStringAsPrecision(7));
    drawText(canvas, Offset(origin, heightOffset -12 + 20), (min + priceOffset * 3).toStringAsPrecision(7));
    drawText(canvas, Offset(origin, heightOffset * 2 - 12 + 20), (min + priceOffset * 2).toStringAsPrecision(7));
    drawText(canvas, Offset(origin, heightOffset * 3 - 12 + 20), (min + priceOffset).toStringAsPrecision(7));
    drawText(canvas, Offset(origin, height - 12 + 20), min.toStringAsPrecision(7));

    for (var i = 0; i < 5; i++) {
      String date;
      Offset dateOrigin;
      if (i == 0) {
        date = data[0].date;
        dateOrigin = Offset(0, height+20);
      } else if (i == 4) {
        date = data.last.date;
        dateOrigin = Offset(width - 52, height+20);
      } else {
        date = data[i*count].date;
        dateOrigin = Offset((i * count - 0.5) * rectWidth - 25, height+20);
      }
      drawText(canvas, dateOrigin, date);
    }
  }

  drawVolumeLine(Canvas canvas, Size size) {
    double height = size.height - 20;
    double width = size.width;

    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth;

    int count = (data.length ~/ 4).toInt() + 1;

    canvas.drawLine(Offset(0, 20), Offset(width, 20), linePaint);

    for (var i = 1; i < 4; i++) {
          canvas.drawLine(Offset((i * count - 0.5) * rectWidth ,20), Offset((i * count - 0.5) * rectWidth,height + 20), linePaint);
    }
    
    double origin = width - max.toStringAsPrecision(7).length * 6;
    drawText(canvas, Offset(origin, 20), maxVolume.toStringAsPrecision(7));

  }

  @override
  bool shouldRepaint(_SeparateViewPainter old) {
    return data != null;
  }
}
