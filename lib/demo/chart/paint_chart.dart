


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
//            child: Container(
//              width: size.width,
//              height: size.height,
//              color: Colors.white,
//            ),
          ),
          SizedBox(
            height: 30,
          ),
          RangeSlider(
              values: RangeValues(leftValue,rightValue),
              divisions: 100,
              min: 0.0,
              max: 1.0,
              onChanged: (values){
                debugPrint("range value : $values");
                leftValue = values.start;
                rightValue = values.end;
                setState(() {

                });
              })
        ],
      ),
    );
  }

  ChartPainter buildPainter(){
    var dataList = [
      ChartBean(x: "\$2000", y: 32),
      ChartBean(x: "\$1100", y: 48),
      ChartBean(x: "\$1400", y: 32),
      ChartBean(x: "\$500", y: 24),
      ChartBean(x: "\$800", y: 50),
      ChartBean(x: "\$1800", y: 25),
      ChartBean(x: "\$1200", y: 18),
      ChartBean(x: "\$2000", y: 32),
      ChartBean(x: "\$1100", y: 48),
      ChartBean(x: "\$1400", y: 32),
    ];
    return ChartPainter(
      leftStart: leftValue,rightEnd: rightValue,
      chartBeans: dataList,
      lineColor: Colors.blueAccent,
      fillColors: [
        Colors.orange.withOpacity(0.8),
        Colors.orangeAccent.withOpacity(0.5)
      ],
      lineWith: 3,
      yAxisNum: dataList.length
    );
  }


}




















