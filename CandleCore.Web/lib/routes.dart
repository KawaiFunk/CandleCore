import 'package:candle_core/presentation/screens/home_page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {'/': (context) => const HomePage()};
}
