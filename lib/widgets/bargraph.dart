import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/colors.dart';

class BarGraph extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final int? highlightedIndex; // 색칠할 인덱스

  const BarGraph({
    Key? key,
    required this.data,
    required this.labels,
    this.highlightedIndex, // 추가
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxValue = data.reduce((a, b) => a > b ? a : b);
    double containerHeight = 80.h;
    double scaleFactor = containerHeight / maxValue;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0.w),
      child: SizedBox(
        height: containerHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: data.asMap().entries.map((entry) {
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
                  height: value * scaleFactor,
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
