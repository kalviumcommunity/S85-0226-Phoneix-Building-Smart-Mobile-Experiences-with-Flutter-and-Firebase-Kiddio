import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';

void main() {
  test('Kiddio app widget can be created', () {
    const app = KiddioApp();
    expect(app, isNotNull);
  });
}
