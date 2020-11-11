import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:subscription_app/app/data/models/feed.dart';
import 'package:subscription_app/app/data/repositories/feed_repository.dart';
import 'package:subscription_app/app/modules/dashboard/dashboard_controller.dart';
import 'package:subscription_app/app/modules/dashboard/dashboard_controller.dart';
import 'package:subscription_app/app/modules/dashboard/dashboard_page.dart';
import 'package:subscription_app/constants.dart';

import '../database/mock_feed_data_provider.dart';
import '../mock_connectivity.dart';

void main() {
  BindingsBuilder binding;
  setUp(() {
    binding = BindingsBuilder(() {
      Get.lazyPut<DashboardCtrl>(() => DashboardCtrl(
          feedRepository: FeedRepository(apiClient: MockFeedProvider()),
          connectivity: MockConnectivity()));
    });

    binding.builder();
  });
  testWidgets('Feeds are displayed with zero subscribed feed', (tester) async {
    await tester.pumpWidget(
      DashboardPageWrapper(),
    );
    await DashboardCtrl.to.getFeedList(initial: true);
    await tester.pump(Duration.zero);

    final numberOfFeedFinder = find.byKey(Key(NUMBER_OF_SUBSCRIBED_FEED_KEY));

    expect(find.text('Number of Subscribed Feed'), findsOneWidget);
    expect(numberOfFeedFinder, findsOneWidget);
    expect((numberOfFeedFinder.evaluate().first.widget as Text).data, '0');
    expect(find.text('No internet'), findsNothing);
    expect(find.byKey(Key(SEARCH_BUTTON_KEY)), findsOneWidget);
    expect(find.byKey(Key(FILTER_TEXTFIELD_KEY)), findsNothing);
    expect(find.byKey(Key(FEED_LIST_KEY)), findsOneWidget);
  });

  testWidgets(
      'When press SUBSCRIBE button, the button will be UNSUBSCRIBE and vice versa',
      (tester) async {
    await tester.pumpWidget(
      DashboardPageWrapper(),
    );
    await DashboardCtrl.to.getFeedList(initial: true);
    await tester.pump(Duration.zero);

    for (var feed in DashboardCtrl.to.feedPaginate.feeds) {
      print('feed ${feed.id}');
      expect(find.byKey(Key('subscribe_button_${feed.id}')), findsOneWidget);
      await tester
          .ensureVisible(find.byKey(Key('subscribe_button_${feed.id}')));
      await tester.tap(find.byKey(Key('subscribe_button_${feed.id}')));
      await tester.pump();
      expect(find.byKey(Key('unsubscribe_button_${feed.id}')), findsOneWidget);
      await tester
          .ensureVisible(find.byKey(Key('unsubscribe_button_${feed.id}')));
      await tester.tap(find.byKey(Key('unsubscribe_button_${feed.id}')));
      await tester.pump();
      expect(find.byKey(Key('subscribe_button_${feed.id}')), findsOneWidget);
    }
  });

  testWidgets(
      'When press search icon, the the search text field is displayed, when press it again, the text field is hidden.',
      (tester) async {
    await tester.pumpWidget(
      DashboardPageWrapper(),
    );
    await DashboardCtrl.to.getFeedList(initial: true);
    await tester.pump(Duration.zero);

    expect(find.byKey(Key(FILTER_TEXTFIELD_KEY)), findsNothing);
    await tester.tap(find.byKey(Key(SEARCH_BUTTON_KEY)));
    await tester.pump();
    expect(find.byKey(Key(FILTER_TEXTFIELD_KEY)), findsOneWidget);
    await tester.tap(find.byKey(Key(SEARCH_BUTTON_KEY)));
    await tester.pump();
    expect(find.byKey(Key(FILTER_TEXTFIELD_KEY)), findsNothing);
  });
}

class DashboardPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardPage(),
    );
  }
}
