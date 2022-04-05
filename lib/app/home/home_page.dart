import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pv_test/app/constant/string.dart';
import 'package:pv_test/app/home/controller/home_controller.dart';
import 'package:pv_test/app/model/movie.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HomeController controller;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    controller = HomeController();
    super.initState();
    controller.initData();
    _controller.addListener(() {
      _onScroll();
    });
  }

  void _onScroll() {
    if (!_controller.hasClients || controller.isLoadMore) return;

    final thresholdReached =
        _controller.position.extentAfter < AppText.endReachedThreshold;

    if (thresholdReached) {
      // Load more!
      controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 32, bottom: 16, left: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                    Text(
                      'Back',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 8,
                  bottom: 8,
                ),
                child: Text(
                  'Popular list',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                  ),
                ),
              ),
              !controller.isLoading
                  ? Expanded(
                      child: Stack(
                        children: [
                          RefreshIndicator(
                            onRefresh: _onRefresh,
                            child: GridView.count(
                              controller: _controller,
                              childAspectRatio: (180 / 250),
                              crossAxisCount: 2,
                              crossAxisSpacing: 1.0,
                              mainAxisSpacing: 16.0,
                              children: List.generate(
                                  controller.listFilm.length, (index) {
                                Results film = controller.listFilm[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Container(
                                    height: 200,
                                    width: 250,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          "${AppText.imageUrl}${film?.posterPath ?? ''}",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Text("${controller.listFilm[index].backdropPath}"),
                                        Positioned(
                                            bottom: 10,
                                            left: 5,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 130,
                                                  child: Text(
                                                    (film?.releaseDate ?? '')
                                                            .isNotEmpty
                                                        ? controller.formatDate(
                                                            film.releaseDate)
                                                        : DateTime.now()
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    softWrap: true,
                                                  ),
                                                ),
                                                Container(
                                                  width: 130,
                                                  child: Text(
                                                    film?.title ?? '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            )),
                                        Positioned(
                                            top: 10,
                                            right: 5,
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topRight,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      Colors.orange,
                                                      Colors.red,
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(90))),
                                              child: Center(
                                                child: Text(
                                                  film?.voteAverage ?? '',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: controller.isLoadMore
                                ? Center(
                                    child: Container(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(),
                                  ))
                                : SizedBox(),
                          )
                        ],
                      ),
                    )
                  : Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    controller.initData();
  }

  Future<void> _loadMore() async {}
}
