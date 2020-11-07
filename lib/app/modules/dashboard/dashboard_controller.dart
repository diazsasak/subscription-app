import 'dart:async';

import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:subscription_app/app/data/models/feed.dart';
import 'package:subscription_app/app/data/models/feed_paginate.dart';
import 'package:subscription_app/app/data/models/provider_response.dart';
import 'package:subscription_app/app/data/models/subscribe_response.dart';
import 'package:subscription_app/app/data/repositories/feed_repository.dart';
import 'package:subscription_app/app/helpers/view_utils.dart';

class DashboardCtrl extends GetxController {
  static DashboardCtrl get to => Get.find();

  final FeedRepository feedRepository;

  DashboardCtrl({@required this.feedRepository})
      : assert(feedRepository != null);

  final isSearch = Rx<bool>(false);

  final _subscriptionList = RxList<SubscribeResponse>([]);

  get subscriptionList => _subscriptionList;

  set subscriptionList(val) => _subscriptionList.value = val;

  final _isLoading = Rx<bool>(false);

  get isLoading => _isLoading.value;

  set isLoading(val) => _isLoading.value = val;

  final _feedPaginate = Rx<FeedPaginate>();

  get feedPaginate => _feedPaginate.value;

  set feedPaginate(val) => _feedPaginate.value = val;

  final _amountPerPage = 10;

  Timer _debounce;

  @override
  void onInit() {
    super.onInit();
    getFeedList(initial: true);
  }

  getFeedList({@required bool initial, String keyword}) async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    ProviderResponse response = await feedRepository.getFeedList(
      page: initial
          ? 1
          : (_feedPaginate.value.feeds.length / _amountPerPage).floor() + 1,
      keyword: keyword,
    );
    if (response.status) {
      FeedPaginate fp = response.data;
      if (feedPaginate == null || initial) {
        feedPaginate = fp;
      } else {
        _feedPaginate.update((val) {
          val.feeds.addAll(fp.feeds);
        });
      }
    } else {
      ViewUtils.showSnackbar(status: response.status, message: response.data);
    }
    isLoading = false;
  }

  toggleSubscribe({@required Feed feed}) async {
    if (feed.subscriptionId != null) {
      _feedPaginate.update((val) {
        val.feeds[val.feeds.indexWhere((element) => element.id == feed.id)]
            .subscriptionId = null;
      });
      ViewUtils.showSnackbar(
          status: false, message: 'Unsubscribed from ${feed.feedName}');
    } else {
      ProviderResponse response =
          await feedRepository.subscribeFeed(feedId: feed.id);
      if (response.status) {
        _feedPaginate.update((val) {
          val.feeds[val.feeds.indexWhere((element) => element.id == feed.id)]
              .subscriptionId = (response.data as SubscribeResponse).id;
        });
        ViewUtils.showSnackbar(
            status: response.status, message: 'Subscribed to ${feed.feedName}');
      } else {
        ViewUtils.showSnackbar(status: response.status, message: response.data);
      }
    }
  }

  setSearch() {
    isSearch.value = !isSearch.value;
  }

  getSubscribedFeedAmount() {
    return _feedPaginate.value.feeds
        .where((e) => e.subscriptionId != null)
        .toList()
        .length;
  }

  filterByFeedName({String feedName}) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      getFeedList(initial: true, keyword: feedName);
    });
  }
  
}
