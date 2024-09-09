import 'package:flutter_test/flutter_test.dart';
import 'package:project1/models/dday_model.dart';


void main() {
  test('DdayModel fromJson and toJson', () {
    final json = {
      'ddayName': 'Test Event',
      'startDate': '2024-09-09T13:11:22.086Z',
      'endDate': '2024-09-09T13:11:22.086Z',
    };

    final dday = DdayModel.fromJson(json);

    expect(dday.ddayName, 'Test Event');
    expect(dday.startDate, DateTime.parse('2024-09-09T13:11:22.086Z'));
    expect(dday.endDate, DateTime.parse('2024-09-09T13:11:22.086Z'));

    final jsonOutput = dday.toJson();

    expect(jsonOutput['ddayName'], 'Test Event');
    expect(jsonOutput['startDate'], '2024-09-09T13:11:22.086Z');
    expect(jsonOutput['endDate'], '2024-09-09T13:11:22.086Z');
  });
}
