


import 'package:chart_price_slider/demo/chart_clip_path.dart';
import 'package:chart_price_slider/demo/generator.dart';
import 'package:chart_price_slider/demo/price_slider.dart';
import 'package:flutter/material.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/adapter_android_mp.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_line_data_set.dart';
import 'package:mp_chart/mp/core/data_provider/line_data_provider.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/fill_formatter/i_fill_formatter.dart';

class DemoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return DemoPageState();
  }

}

class DemoPageState extends State<DemoPage> {

  List<Entry> chartSet = [];

  LineChartController controller;


  @override
  void initState() {
    generateChart();
    _initController();

    _initLineData();
    super.initState();
  }

  void _initLineData() async {

    LineDataSet set1;
    // create a dataset and give it a type
    set1 = LineDataSet(chartSet,"DataSet 1");

    set1.setMode(Mode.CUBIC_BEZIER);
    set1.setCubicIntensity(0.2);
    set1.setDrawFilled(true);
    set1.setDrawCircles(false);
    set1.setLineWidth(0.5);
    set1.setCircleRadius(4);
    set1.setDrawValues(false);//点击图表 不显示value
    //set1.setCircleColor(Colors.red);//折线上的圆点颜色
    set1.setHighLightColor(Colors.yellowAccent);
    set1.setColor1(Colors.black45);//曲线颜色
    set1.setFillColor(Colors.grey);//填充颜色
    //set1.setFillAlpha(100);
    set1.setDrawHorizontalHighlightIndicator(false);
    set1.setFillFormatter(A());

    // create a data object with the data sets
    controller.data = LineData.fromList(List()..add(set1))
      ..setValueTypeface(TypeFace())
      ..setValueTextSize(9)
      ..setDrawValues(false);

    setState(() {});
  }

  void _initController() {
    var desc = Description()..enabled = false;
    controller = LineChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft.enabled = false;
          //axisLeft.setLabelCount2(6, false);
//          axisLeft
//            ..typeface = Util.LIGHT
//            ..setLabelCount2(6, false)
//            ..textColor = (ColorUtils.WHITE)
//            ..position = (YAxisLabelPosition.INSIDE_CHART)
//            ..drawGridLines = (false)
//            ..axisLineColor = (ColorUtils.WHITE);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight.enabled = (false);
        },
        legendSettingFunction: (legend, controller) {
          (controller as LineChartController).setViewPortOffsets(0, 0, 0, 0);
          legend.enabled = (false);
          var data = (controller as LineChartController).data;
          if (data != null) {
            var formatter = data.getDataSetByIndex(0).getFillFormatter();
            if (formatter is A) {
              formatter.setPainter(controller);
            }
          }
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis.enabled = (false);
        },
        drawGridBackground: true,
        dragXEnabled: false,
        dragYEnabled: false,
        scaleXEnabled: false,
        scaleYEnabled: false,
        pinchZoomEnabled: false,
        gridBackColor: Color.fromARGB(0, 0, 0, 0),
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        description: desc);
    controller.infoBgColor = Colors.transparent;
    //controller.painter.setGridBackgroundColor(Colors.transparent);

  }

  generateChart(){
    beanList.forEach((bean){
      chartSet.add(Entry(x: double.parse(bean.x),y: bean.y));
    });

  }
  double leftImageMargin = 0.0;
  double rightImageMargin = 0.0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double rootWidth = size.width;
    final double rootHeight = size.height;

    return  Container(
      color: Colors.lightBlue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: rootWidth,
            height: rootHeight*0.5,
            child: Stack(
              children: <Widget>[
                ///
                //bottom chart
                buildLineChart(),
                //above chart
                ClipPath(
                  clipper: ChartClipPath(Size(30,20),//可以根据设计图也可以通过key传出来，这里方便起见
                      leftImageMargin, rightImageMargin,rootHeight * 0.4),
                  child: buildLineChart(),
                ),


                ///
                Positioned(
                  bottom: 0,
                  child: SliderPrice(list: beanList,rootWidth: rootWidth,rootHeight: rootHeight * 0.4,
                    leftSlidListener: (dragging,index,leftImageMargin){
                      debugPrint("left ------- $dragging ------- $index");
                    },
                    rightSlidListener: (dragging,index,rightImageMargin){
                      debugPrint("right ------- $dragging ------- $index");
                    },),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget buildLineChart(){
    var lineChart = LineChart(controller);

    controller.autoScaleMinMaxEnabled = false;
    controller.infoBgColor = Colors.transparent;
    //controller.backgroundColor = Colors.yellowAccent;
//    controller.animator
//      ..reset()
//      ..animateXY1(2000, 2000);
    return lineChart;

  }

}

class A implements IFillFormatter {
  LineChartController _controller;

  void setPainter(LineChartController controller) {
    _controller = controller;

  }

  @override
  double getFillLinePosition(
      ILineDataSet dataSet, LineDataProvider dataProvider) {
    _controller.painter.setGridBackgroundColor(Colors.transparent);
    return _controller?.painter?.axisLeft?.axisMinimum;
  }
}