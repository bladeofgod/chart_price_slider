

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
  ///单个区间宽度
  double singleW ;

  ///最小间距 （禁止碰撞距离）
  int minimumDistance = 5;

  ///滑块宽度
  double blockSize = 30;

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

  //滑块 左右边距
  double leftImageMargin = 0;
  double rightImageMargin = 0;

  double leftBlackLineW = 0; // 左边黑线的padding
  double rightBlackLineW = 0; // 右边黑线的padding

  int leftImageCurrentIndex = 0; // 左边选中的价格索引
  int rightImageCurrentIndex = 0; // 右边选中的价格索引


  @override
  void initState() {
    super.initState();
    segmentPart = widget.list.length - 1;
    singleW = widget.rootWidth / segmentPart;

    _leftPrice = widget.list[0].x;
    _rightPrice = widget.list.last.x;

    WidgetsBinding.instance.addPostFrameCallback((_){
      leftSlideImageOffset = generateWidgetInfo(leftImageKey);
      rightSlideImageOffset = generateWidgetInfo(rightImageKey);

    });

  }

  Offset generateWidgetInfo(GlobalKey key){
    if(key == null )return null;
    RenderBox box = key.currentContext.findRenderObject();
    Offset offset = box.localToGlobal(Offset.zero);
    return offset;
  }


  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.lightBlueAccent,
      child: Container(
        height: widget.rootHeight,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //_priceRangeBlock(),
            //SizedBox(height: 10,),
            //_priceBlock(_leftPrice, _rightPrice),
            //SizedBox(height: 10,),
            /// x轴 +  左右滑块
            Container(
              height: widget.rootHeight,
              color: Colors.transparent,
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    bottom: 25,
                    child: _lineBlock(context, widget.rootWidth),
                  ),
                  _leftImageBlock(context, widget.rootWidth),
                  _rightImageBlock(context, widget.rootWidth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

       /*
      * 左边滑块，使用到：_imageItem
      * */
  _leftImageBlock(BuildContext context, double screenWidth) {

    return Positioned(
      left: leftImageMargin,
      //top: 0,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: isLeftDragging,
                child: Text(_leftPrice,style: TextStyle(fontSize: 12,color: Colors.black),),
              ),
              SizedBox(
                width: 1,
                height: widget.rootHeight*0.7,
              ),

              GestureDetector(
                child: _imageItem(leftImageKey),
                //水平方向移动 拖拽
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  ///  details.delta.direction > 0 向左滑  、小于=0 向右滑动
                  //print("direction ____ ${details.delta.direction}");
                  //bool isSlide2Left =
                  isLeftDragging = true;
                  //print('拖拽中');w
                  if(leftImageMargin < 0) {//处理左边边界
                    leftImageMargin = 0;///确保不越界
                    //_leftBlackLineW = 2;
                    leftBlackLineW = 2;
                  } else
                    //这里进行两滑块相遇处理，如果小于等于5个步长，则不允许继续向右滑动
                  if (details.delta.direction <= 0
                      && ((screenWidth-(rightImageMargin+blockSize))-(leftImageMargin + blockSize))
                          <(singleW* minimumDistance)){
                    return ;
                  }
                  else {
                    leftImageMargin += details.delta.dx;
                    ///确保线宽不溢出
                    leftBlackLineW = leftImageMargin+blockSize/2;
                  }

                  double _leftImageMarginFlag = leftImageMargin;
                  //print('拖拽结束');
                  //刷新上方的 price indicator
                  for(int i = 0; i< widget.list.length;i++){
                    if(_leftImageMarginFlag < singleW * (0.5 + i)){
                      ///判断滑块位置区间 显示对应价格
                      _leftPrice = widget.list[i].x;
                      leftImageCurrentIndex = i;

                      break;
                    }
                  }
                  setState(() {});// 刷新UI
                  if(widget.leftSlidListener != null){
                    widget.leftSlidListener(true,leftImageCurrentIndex);
                  }
                },
                ///拖拽结束
                onHorizontalDragEnd: (DragEndDetails details) {
                  isLeftDragging = false;

                  if ( ((screenWidth-(rightImageMargin+blockSize))-(leftImageMargin+blockSize))<(singleW*5)){
                    setState(() {

                    });
                    return ;
                  }

                  double _leftImageMarginFlag = leftImageMargin;
                  //print('拖拽结束');
                  ///拖拽结束后，需要对滑块进行校准
                  for(int i = 0; i< widget.list.length;i++){
                    if(_leftImageMarginFlag < singleW * (0.5 + i)){
                      if(i == 0){
                        leftImageMargin = 0;
                      }else{

                        leftImageMargin = singleW * i;

                      }
                      _leftPrice = widget.list[i].x;
                      leftImageCurrentIndex = i;
                      break;
                    }
                  }
                  //解决快速滑动时，导致的横线溢出问题
                  leftBlackLineW = leftImageMargin + blockSize;

                  //print('选中第$_leftImageCurrentIndex个');
                  //setState(() {});// 刷新UI

                  if(widget.leftSlidListener != null){
                    widget.leftSlidListener(false,leftImageCurrentIndex);
                  }
                },
              ),

              Container(
                padding:  EdgeInsets.only(top: 6),
                child: Text(_leftPrice,style: TextStyle(fontSize: 12,
                    color:!isLeftDragging ? Colors.black : Colors.white),),
              )

            ],
          ),

        ],
      ),
    );
  }

  /*
      * 右边image滑块，使用到：_imageItem
      * */
  _rightImageBlock(BuildContext context, double screenWidth) {

    return Positioned(
      right: rightImageMargin,
      //top: 0,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        overflow: Overflow.visible,
        children: <Widget>[

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: isRightDragging,
                child: Text(_rightPrice,style: TextStyle(fontSize: 12,color: Colors.black),),
              ),
              SizedBox(
                width: 1,
                height: widget.rootHeight*0.7,
              ),

              GestureDetector(
                child: _imageItem(rightImageKey),
                //水平方向移动
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  ///  details.delta.direction > 0 向左滑  、小于=0 向右滑动
                  //print("right direction ____ ${details.delta.direction}");
                  isRightDragging = true;
                  //print(_rightImageMargin);
                  if(rightImageMargin < 0) {//处理右边边界

                    rightImageMargin = 0;
                    ///确保不溢出
                    rightBlackLineW = 2;
                  } else
                    //这里进行两滑块相遇处理，如果小于等于5个步长，则不允许继续向右滑动 PS:下方注释的是处理单个步长的
                  if(details.delta.direction >0 &&
                      ((screenWidth-(rightImageMargin+blockSize))-(leftImageMargin+blockSize))
                          <(singleW*minimumDistance)){
                    return;
                  }

                  else {

                    rightImageMargin = rightImageMargin - details.delta.dx;
                    rightBlackLineW = rightImageMargin+blockSize/2;
                  }
                  double _rightImageMarginFlag = rightImageMargin;
                  //print('拖拽结束');
                  for(int i = 0; i< widget.list.length;i++){
                    if(_rightImageMarginFlag < singleW * (0.5 + i)){

                      _rightPrice = widget.list[(widget.list.length - 1) -i].x;
                      rightImageCurrentIndex = i;
                      break;
                    }
                  }
                  setState(() {}); // 刷新UI
                  if(widget.rightSlidListener != null){
                    widget.rightSlidListener(true,rightImageCurrentIndex);
                  }
                },
                onHorizontalDragEnd: (DragEndDetails details){

                  isRightDragging = false;
                  if(((screenWidth-(rightImageMargin+blockSize))-(leftImageMargin+blockSize))<(singleW*minimumDistance)){
                    setState(() {

                    });
                    return;
                  }

                  double _rightImageMarginFlag = rightImageMargin;
                  //print('拖拽结束');
                  for(int i = 0; i< widget.list.length;i++){
                    if(_rightImageMarginFlag < singleW * (0.5 + i)){
                      if(i == 0){
                        rightImageMargin = 0;

                      }else{
                        rightImageMargin = singleW * i;
                      }
                      _rightPrice = widget.list[(widget.list.length - 1) -i].x;

                      rightImageCurrentIndex = i;
                      break;
                    }
                  }

                  //解决快速滑动时，导致的横线溢出问题
                  rightBlackLineW = rightImageMargin  +blockSize;
                  //print('选中第$_rightImageCurrentIndex个');
                  //setState(() {});// 刷新UI

                  if(widget.rightSlidListener != null){
                    widget.rightSlidListener(false,rightImageCurrentIndex);
                  }
                },
              ),
//              Visibility(
//                visible: ! isRightDragging,
//                child: Text("$_rightPrice",style: TextStyle(fontSize: 12,color: Colors.black),),
//              ),
              Container(
                padding:  EdgeInsets.only(top: 6),
                child: Text(_rightPrice,style: TextStyle(fontSize: 12,
                    color:!isRightDragging ? Colors.black : Colors.white),),
              ),

            ],
          ),

        ],
      ),
    );
  }



  /*
      * 横线视图模块,包括黄色横线和黑色横线
      * */
  _lineBlock(BuildContext context, double screenWidth) {
    return Row(
      children: <Widget>[
//        SizedBox(
//          width: 20,
//        ),
        Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              height: 5.0,
              width: screenWidth,
              alignment: Alignment.center,
              //margin: EdgeInsets.only(left: blockSize / 2),
              padding: EdgeInsets.only(left: leftBlackLineW,right: rightBlackLineW),
              child: Container(
                color: Colors.black,
                height: 3,
                width: screenWidth ,
              ),
            ),

          ],
        ),
      ],
    );
  }


  // 滑块的image
  _imageItem(GlobalKey key){
    //return Icon(Icons.settings_applications,color: Colors.red,size: 30,);
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(6)
      ),
      width: blockSize,
      height: blockSize*0.7,
    );
  }


}





















