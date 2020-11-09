import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subscription_app/app/modules/dashboard/dashboard_controller.dart';
import 'package:subscription_app/app/modules/dashboard/local_widgets/feed_list_item.dart';

class DashboardPage extends StatelessWidget {
  final ctrl = DashboardCtrl.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => ctrl.isSearchEnabled
              ? TextField(
                  key: Key('text_field'),
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search by feed name',
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: (String v) => ctrl.filterByFeedName(feedName: v),
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                )
              : const Text('Dashboard'),
        ),
        actions: [
          IconButton(
            icon: Obx(() =>
                ctrl.isSearchEnabled ? const Icon(Icons.clear) : const Icon(Icons.search)),
            onPressed: ctrl.setSearch,
            key: Key('search_button'),
          )
        ],
      ),
      body: Obx(
        () => ctrl.isLoading && ctrl.feedPaginate == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ctrl.feedPaginate == null
                ? Center(
                    child: FlatButton(
                      child: const Text(
                        'Get Feeds',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => ctrl.getFeedList(initial: true),
                      color: Colors.blue,
                    ),
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification sn) {
                      if (sn.metrics.pixels >=
                              (sn.metrics.maxScrollExtent - 200) &&
                          ctrl.feedPaginate.total >
                              ctrl.feedPaginate.feeds.length) {
                        ctrl.getFeedList(initial: false);
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      onRefresh: () => ctrl.getFeedList(initial: true),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Text('Number of Subscribed Feed'),
                                    Text(
                                      '${ctrl.numberOfSubscribedFeed}',
                                      style: const TextStyle(fontSize: 30.0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ctrl.feedPaginate.feeds.isEmpty
                                  ? const Center(
                                      child: Text('Empty.'),
                                    )
                                  : ListView.builder(
                                      itemCount: ctrl.feedPaginate.total >
                                              ctrl.feedPaginate.feeds.length
                                          ? ctrl.feedPaginate.feeds.length + 1
                                          : ctrl.feedPaginate.feeds.length,
                                      itemBuilder: (context, index) {
                                        if (ctrl.feedPaginate.total >
                                                ctrl.feedPaginate.feeds
                                                    .length &&
                                            index ==
                                                ctrl.feedPaginate.feeds
                                                    .length) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        return FeedListItem(
                                          feed: ctrl.feedPaginate.feeds[index],
                                          onPressed: () => ctrl.toggleSubscribe(
                                            feed:
                                                ctrl.feedPaginate.feeds[index],
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
