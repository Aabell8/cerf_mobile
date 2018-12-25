import 'package:cerf_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cerf_mobile/services/auth.dart';

void main() {
  testWidgets('Check services functions', (WidgetTester tester) async {
    final Auth auth = Auth();
    auth
        .loginWithEmailAndPassword("Austin6@gmail.com", "Testing123")
        .then((res) => print(res));
  });
}
