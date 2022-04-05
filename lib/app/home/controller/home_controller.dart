import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pv_test/app/api/api.dart';
import 'package:pv_test/app/model/movie.dart';

class HomeController extends GetxController {
  final BaseAPI api = BaseAPI();
  Movie movie;
  List<Results> listFilm = [];
  RefreshCallback onRefresh;
  bool isLoading = false;
  int pageIndex = 1;
  bool isLoadMore = false;
  int totalPage;

  initData() async {
    listFilm = [];
    try {
      isLoading = true;
      var result = await api.getAPI(page: 1);
      if (result.statusCode == 200) {
        movie = Movie.fromJson(jsonDecode(result.body));
        totalPage = movie.totalPages;
        listFilm = movie.results;
        pageIndex = movie.page;
        isLoading = false;
        update();
      }
      update();
    } catch (e) {
      isLoading = false;
    }
  }

  loadMore() async {
    if (isLoading) {
      return;
    }

    isLoadMore = true;
    update();

    if (pageIndex <= totalPage) {
      pageIndex++;
      try {
        isLoadMore = true;
        var result = await api.getAPI(page: pageIndex);
        if (result.statusCode == 200) {
          movie = Movie.fromJson(jsonDecode(result.body));
          List<Results> list = movie.results;
          list.forEach((e) {
            listFilm.add(e);
          });
          pageIndex = movie.page;
          isLoadMore = false;
          update();
        }
        update();
      } catch (e) {
        isLoadMore = false;
      }
    } else {
      return;
    }
  }

  formatDate(String date) {
    DateTime years = DateTime.parse(date);
    return DateFormat("yyyy").format(years);
  }
}
