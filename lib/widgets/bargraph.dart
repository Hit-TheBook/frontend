import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/colors.dart';

class BarGraph extends StatelessWidget {
  final List<double> data;
  final List<String> labels; // 각 막대의 라벨 리스트 추가

  const BarGraph({Key? key, required this.data, required this.labels}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0.w),
      child: SizedBox(
        height: 200.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: data.asMap().entries.map((entry) {
            int index = entry.key;
            double value = entry.value;
            Color barColor = (index == data.length - 1) ? neonskyblue1 : gray1;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 20.w,
                  height: value,
                  color: barColor,
                ),
                SizedBox(height: 5.h),
                Text(
                  value.toString(),
                  style: TextStyle(fontSize: 10.sp),
                ),
                SizedBox(height: 5.h),
                Text(
                  labels[index], // 각 막대의 라벨 표시
                  style: TextStyle(fontSize: 10.sp,color: black1),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
