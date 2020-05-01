

import 'package:chart_price_slider/demo/chart_bean.dart';
import 'package:flutter/material.dart';

class SliderPrice extends StatefulWidget{

  final List<ChartBean> list;

  ///根部宽高 可用于校准
  final double rootWidth,rootHeight;

  ///滑块监听 目前参数暂定为 : param1 : 是否滑动  param2 : 当前index
  final Function rightSlidListener,leftSlidListener;


  SliderPrice({@required this.list, this.rootWidth, this.rootHeight = 300,
    this.rightSlidListener, this.leftSlidListener})
    :assert(list != null);

  @override
  State<StatefulWidget> createState() {

    return SliderPriceState();
  }

}

class SliderPriceState extends State<SliderPrice> {

  ///分割多少块
  int segmentPart;

  //是否拖动中
  bool isLeftDragging = false;
  bool isRightDragging = false;

  ///左右价格tag
  String _leftPrice = '0';
  String _rightPrice ="2000";

  ///左右滑块的位置
  Offset leftSlideImageOffset;
  Offset rightSlideImageOffset;

  ///左右滑块
  GlobalKey leftImageKey = GlobalKey();
  GlobalKey rightImageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    segmentPart = widget.list.length - 1;

    _leftPrice = widget.list[0].x;
    _rightPrice = widget.list.last.x;

  }


  @override
  Widget build(BuildContext context) {

    return Material(
      child: Container(
        child: Center(),
      ),
    );
  }
}





















