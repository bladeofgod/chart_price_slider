


import 'package:chart_price_slider/demo/chart/chart_painter.dart';
import 'package:flutter/material.dart';

import '../chart_bean.dart';

class PaintChart extends StatefulWidget{

  static const padding = 20;

  @override
  State<StatefulWidget> createState() {

    return PaintChartState();
  }

}

class PaintChartState extends State<PaintChart> {

  double leftValue = 0.0;
  double rightValue = 1.0;

  @override
  Widget build(BuildContext context) {
    final size = Size(MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height / 5 * 1.6);
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CustomPaint(
            size: size,
            /// 绘制顺序依次是 painter  ,  child  ,foregroundPainter 后者会覆盖前者
            painter: buildPainter(),
            //foregroundPainter: ,
            child: Container(
              width: size.width,
              height: size.height,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  ChartPainter buildPainter(){
    return ChartPainter(
      leftStart: leftValue,rightEnd: rightValue,
    );
  }


}




















