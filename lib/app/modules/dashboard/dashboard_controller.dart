import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:subscription_app/app/data/models/feed.dart';
import 'package:subscription_app/app/data/models/feed_paginate.dart';
import 'package:subscription_app/app/data/models/subscribe_response.dart';
import 'package:subscription_app/app/data/repositories/feed_repository.dart';
import 'package:subscription_app/app/helpers/view_helpers.dart';

class DashboardCtrl extends GetxController {
  static DashboardCtrl get to => Get.find();

  final FeedRepository feedRepository;

  DashboardCtrl({@required this.feedRepository, Connectivity connectivity})
      : assert(feedRepository != null) {
    connectivity ??= Connectivity();
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _isConnected.value = false;
      } else {
        _isConnected.value = true;
        getFeedList(initial: true);
      }
    });
  }

  final _isSearchEnabled = false.obs;

  bool get isSearchEnabled => _isSearchEnabled.value;

  set isSearchEnabled(val) => _isSearchEnabled.value = val;

  final _subscriptionList = RxList<SubscribeResponse>([]);

  int get numberOfSubscribedFeed => _subscriptionList.length;

  set subscriptionList(val) => _subscriptionList.value = val;

  final _isLoading = Rx<bool>(false);

  bool get isLoading => _isLoading.value;

  set isLoading(val) => _isLoading.value = val;

  final _feedPaginate = Rx<FeedPaginate>();

  FeedPaginate get feedPaginate => _feedPaginate.value;

  set feedPaginate(val) => _feedPaginate.value = val;

  final _amountPerPage = 10;

  Timer _debounce;

  final _isConnected = false.obs;

  bool get isConnected => _isConnected.value;

  set isConnected(val) => _isConnected.value = val;

  FeedPaginate syncSubscription(FeedPaginate fp) {
    _subscriptionList.forEach((e) {
      var index = fp.feeds.indexWhere((element) => element.id == e.feedId);
      if (index >= 0) {
        fp.feeds[index].subscriptionId = e.id;
      }
    });
    return fp;
  }

  Future<void> getFeedList({@required bool initial, String keyword}) async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    var response = await feedRepository.getFeedList(
      page: initial
          ? 1
          : (_feedPaginate.value.feeds.length / _amountPerPage).floor() + 1,
      limit: _amountPerPage,
      keyword: keyword,
    );
    if (response.status) {
      var fp = syncSubscription(response.data);
      if (initial) {
        _feedPaginate.value = fp;
      } else {
        _feedPaginate.update((val) {
          val.feeds.addAll(fp.feeds);
        });
      }
    } else {
      ViewHelpers.showSnackbar(status: response.status, message: response.data);
    }
    isLoading = false;
  }

  void toggleSubscribe({@required Feed feed}) async {
    if (feed.subscriptionId != null) {
      _feedPaginate.update((val) {
        val.feeds[val.feeds.indexWhere((element) => element.id == feed.id)]
            .subscriptionId = null;
      });
      _subscriptionList.removeWhere((e) => e.feedId == feed.id);
      ViewHelpers.showSnackbar(
          status: false, message: 'Unsubscribed from ${feed.feedName}');
    } else {
      var response = await feedRepository.subscribeFeed(feedId: feed.id);
      if (response.status) {
        _feedPaginate.update((val) {
          val.feeds[val.feeds.indexWhere((element) => element.id == feed.id)]
              .subscriptionId = (response.data as SubscribeResponse).id;
        });
        _subscriptionList.add(response.data);
        ViewHelpers.showSnackbar(
            status: response.status, message: 'Subscribed to ${feed.feedName}');
      } else {
        ViewHelpers.showSnackbar(
            status: response.status, message: response.data);
      }
    }
  }

  void setSearch() {
    _isSearchEnabled.value = !_isSearchEnabled.value;
    if (!_isSearchEnabled.value) {
      getFeedList(initial: true);
    }
  }

  void filterByFeedName({String feedName}) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      getFeedList(initial: true, keyword: feedName);
    });
  }
}
