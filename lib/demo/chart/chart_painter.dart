

import 'package:flutter/material.dart';

import '../chart_bean.dart';

class ChartPainter extends CustomPainter{

  double leftStart,rightEnd;//左右绘制的点位

  List<double> minMax = [0,0]; // 存贮极值，用于调整chart分部
  List<ChartBean> chartBeans;//chart data
  Color lineColor;
  double lineWith;
  List<Color> fillColors;//图表填充颜色
  static const double padding = 20;
  int yAxisNum ;

  ChartPainter({this.leftStart = 0,this.rightEnd = 1, this.chartBeans, this.lineColor,
    this.lineWith, this.fillColors, this.yAxisNum});

  //注意这里是左下开始 右上结束。
  double startX, endX, startY, endY;//表的实际绘制区域（去除padding）
  double _fixedHeight, _fixedWidth; //chart宽高

  Path path;

  @override
  void paint(Canvas canvas, Size size) {
    _init(size);
    _drawLine(canvas, size); //绘制曲线
  }

  ///绘制曲线
  void _drawLine(Canvas canvas, Size size) {
    if (chartBeans == null || chartBeans.length == 0) return;
    var paint = Paint()
      ..isAntiAlias = true//抗锯齿
      ..strokeWidth = lineWith
      ..strokeCap = StrokeCap.round//这个是画笔结束后的样式：这里是圆形
      ..color = lineColor
      ..style = PaintingStyle.stroke;
    ///安卓原生端 可以根据PathMeasure 得到路径每个点的坐标
    ///flutter 是通过computeMetrics ，作用基本是一致的.
    if (minMax[0] <= 0) return;
    var pathMetrics = path.computeMetrics(forceClosed: false);//第二个参数是否要连接起点
    ///生成的list，每个元素代表一条path生成的Metrics，(咱们这里只有一个path，所以元素只有一个)
    var list = pathMetrics.toList();
    ///这里我们根据 left right 对path 进行截取
    var length = list.length.toInt() -
        (list.length.toInt() * leftStart) - (list.length.toInt() * (1-rightEnd));
    Path linePath = new Path();
    //填充颜色区域
    Path shadowPath = new Path();
    for (int i = 0; i < length; i++) {
      //开始抽取位置
      double startExtr = list[i].length * (leftStart );
      //结束抽取位置
      double endExtr = list[i].length * (rightEnd);
      var extractPath =
      list[i].extractPath(startExtr, endExtr , startWithMoveTo: true);
      //extractPath.getBounds()
      linePath.addPath(extractPath, Offset(0, 0));
      shadowPath = extractPath;
    }

    ///给画笔添加着色器，可以通过各种渐变createShader（）方法生成着色器
    /// 这里使用的是线性渐变、还有RadialGradient,SweepGradient
    if (fillColors != null) {
      var shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.clamp,
          colors: fillColors)
          .createShader(Rect.fromLTRB(startX, endY, startX, startY));

      ///从path的最后一个点连接起始点，形成一个闭环
      shadowPath
        ..lineTo(startX + (_fixedWidth * rightEnd) , startY)
        ..lineTo((startX+ (endX * leftStart ) ), startY)
        ..close();
      ///先画阴影再画曲线，目的是防止阴影覆盖曲线
      canvas
        ..drawPath(
            shadowPath,
            new Paint()
              ..shader = shader
              ..isAntiAlias = true
              ..style = PaintingStyle.fill);
    }


    canvas.drawPath(linePath, paint);
  }

  void _init(Size size) {

    initBorder(size);
    initPath(size);
  }
  //key : X轴的值， value:Y轴所在屏幕的位置，可以用于点击交互功能
  Map<double, Offset> _points = new Map();

  //生成绘制路径
  void initPath(Size size) {
    if (path == null) {
      if (chartBeans != null && chartBeans.length > 0 && minMax[0] > 0) {
        path = Path();
        double preX,//前一个数据的 x 值
            preY,//前一个数据的 y 值
            currentX,
            currentY;
        int length =  chartBeans.length;
        //x轴 两值之间的间距
        double W = _fixedWidth / (length - 1);

        for (int i = 0; i < length; i++) {
          if (i == 0) {
            var key = startX;//第一个数的x值
            // chartBeans[i].y / maxMin[0] 算出当前y值为最大的值得百分比，
            // *  表高 得出具体所对应的Y轴值
            //用 startY - y值  可以得到最终在屏幕上的y值
            var value = (startY - chartBeans[i].y / minMax[0] * _fixedHeight);
            //移动到对应数据的位置
            path.moveTo(key, value);
            //保存下来这个数据的位置
            _points[key] = Offset(key, value);
            continue;
          }
          //绘制完第一个点后，向右平移一个 宽度（w）
          currentX = startX + W * i;
          //前一个数据的 x 值
          preX = startX + W * (i - 1);
          //前一个数据的y值
          preY = (startY - chartBeans[i - 1].y / minMax[0] * _fixedHeight);
          currentY = (startY - chartBeans[i].y / minMax[0] * _fixedHeight);
          _points[currentX] = Offset(currentX, currentY);

          //绘制贝塞尔路径  （可以百度了解，有很详尽的介绍）
          path.cubicTo((preX + currentX) / 2, preY, // control point 1
              (preX + currentX) / 2, currentY,      //  control point 2
              currentX, currentY);
          //如果使用直线 可以直接.lineTo(...)
        }
      }
    }
  }

  ///计算边界
  void initBorder(Size size) {
    //四周预定一定空间
    startX = yAxisNum > 0 ? padding * 2.5 : padding * 2;
    endX = size.width - padding * 2;
    startY = size.height - padding * 2;
    endY = padding * 2;
    //根据对角位置，算出chart宽度和高度
    _fixedHeight = startY - endY;
    _fixedWidth = endX - startX;
    //y轴 最大和最小值
    minMax = calculateMaxMin(chartBeans);
  }


  ///是否重绘
  @override
  bool shouldRepaint(ChartPainter oldDelegate) {
    ///可以根据自己的需求进行某些值得判断来做出是否重绘的行为
    return true;
  }

  ///算出  chart data的极值
  List<double> calculateMaxMin(List<ChartBean> chatBeans) {
    if (chatBeans == null || chatBeans.length == 0) return [0, 0];
    double max = 0.0, min = 0.0;
    for (ChartBean bean in chatBeans) {
      if (max < bean.y) {
        max = bean.y;
      }
      if (min > bean.y) {
        min = bean.y;
      }
    }
    return [max, min];
  }

}
















