import 'package:home_widget/home_widget.dart';

import '../data.dart' show CountDate;

// New: Add these constants
// TO DO: Replace with your App Group ID
const String appGroupId = 'com.maybejules';
const String iOSWidgetName = 'CounterWidget';
const String androidWidgetName = 'CounterWidget';

void updateHomeWidget(CountDate counter) {
  // Save the headline data to the widget
  HomeWidget.saveWidgetData<int>('todays_count', counter.count);
  HomeWidget.saveWidgetData<String>('todays_date', counter.date);
  HomeWidget.updateWidget(
    iOSName: iOSWidgetName,
    androidName: androidWidgetName,
  );
}
