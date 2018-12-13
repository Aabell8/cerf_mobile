import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:cerf_mobile/main.dart';
import 'package:cerf_mobile/pages/NewTaskPage.dart';

void main() {
  testWidgets(
      'non-empty email and password, valid account, calls sign in, succeeds',
      (WidgetTester tester) async {
    NewTaskPage newTaskPage = NewTaskPage();
    await tester.pumpWidget(buildTestableWidget(newTaskPage));

    Finder addressField = find.byKey(Key('address'));
    await tester.enterText(addressField, '176 St George St.');

    Finder cityField = find.byKey(Key('city'));
    await tester.enterText(cityField, 'London');

    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    Finder hourField = find.byKey(Key('hour'));
    await tester.enterText(hourField, '12');

    Finder minuteField = find.byKey(Key('minute'));
    await tester.enterText(minuteField, '12');

    Finder createTaskButton = find.byKey(Key('createTaskButton'));
    await tester.tap(createTaskButton);

    await tester.pump();
  });
}

Widget buildTestableWidget(Widget widget) {
  // https://docs.flutter.io/flutter/widgets/MediaQuery-class.html
  return MediaQuery(
      data: MediaQueryData(), child: MaterialApp(home: widget));
}
