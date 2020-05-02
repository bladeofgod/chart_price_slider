

import 'dart:math';

import 'package:chart_price_slider/demo/chart_bean.dart';

Random random = Random();

final List<ChartBean> beanList = List.generate(30, (index){
  return ChartBean(x:"${index * 50}",y:((index*1) * (random.nextInt(10)+5))/1);
});