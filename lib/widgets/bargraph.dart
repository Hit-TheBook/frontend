import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/colors.dart';

class BarGraph extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final int? highlightedIndex;

  const BarGraph({
    Key? key,
    required this.data,
    required this.labels,
    this.highlightedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 데이터가 비어있다면 기본값 0으로 채운다.
    List<double> processedData = data.isEmpty ? List.generate(
        labels.length, (index) => 0.0) : data;

    // Get max value, and set a minimum value to avoid disappearing bars
    double maxValue = processedData.reduce((a, b) => a > b ? a : b);
    maxValue = maxValue == 0.0 ? 1.0 : maxValue; // Avoid zero max value

    double containerHeight = 80.h;
    double scaleFactor = containerHeight / maxValue;

    return processedData.every((value) =>
    value == 0.0) // Check if all values are truly zero
        ? Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0.w),
      child: SizedBox(
        height: containerHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: processedData
              .asMap()
              .entries
              .map((entry) {
            int index = entry.key;
            double value = entry.value;

            // 선택된 막대의 색상을 변경
            Color barColor = (index == highlightedIndex) ? neonskyblue1 : gray1;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value.toStringAsFixed(0),
                  style: TextStyle(fontSize: 12.sp, color: black1),
                ),
                Container(
                  width: 15.w,
                  height: value * scaleFactor < 1 ? 1 : value * scaleFactor,
                  // Ensure minimum height
                  color: barColor,
                ),
                SizedBox(height: 5.h),
                Text(
                  labels[index],
                  style: TextStyle(fontSize: 12.sp, color: black1),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    )
        : Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0.w),
      child: SizedBox(
        height: containerHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: processedData
              .asMap()
              .entries
              .map((entry) {
            int index = entry.key;
            double value = entry.value;

            // 선택된 막대의 색상을 변경
            Color barColor = (index == highlightedIndex) ? neonskyblue1 : gray1;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value.toStringAsFixed(0),
                  style: TextStyle(fontSize: 12.sp, color: black1),
                ),
                Container(
                  width: 15.w,
                  height: value * scaleFactor < 1 ? 1 : value * scaleFactor,
                  // Ensure minimum height
                  color: barColor,
                ),
                SizedBox(height: 5.h),
                Text(
                  labels[index],
                  style: TextStyle(fontSize: 12.sp, color: black1),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}