import "dart:async";

import 'package:flutter/material.dart';
import "package:logging/logging.dart";
import "package:photos/core/event_bus.dart";
import "package:photos/events/clear_and_unfocus_search_bar_event.dart";
import "package:photos/models/search/album_search_result.dart";
import "package:photos/models/search/generic_search_result.dart";
import 'package:photos/models/search/search_result.dart';
import "package:photos/services/collections_service.dart";
import "package:photos/ui/viewer/gallery/collection_page.dart";
import "package:photos/ui/viewer/search/result/search_result_widget.dart";
import "package:photos/utils/navigation_util.dart";

class SearchSuggestionsWidget extends StatefulWidget {
  // final List<SearchResult> results;
  final Stream<List<SearchResult>>? results;

  const SearchSuggestionsWidget(
    this.results, {
    Key? key,
  }) : super(key: key);

  @override
  State<SearchSuggestionsWidget> createState() =>
      _SearchSuggestionsWidgetState();
}

class _SearchSuggestionsWidgetState extends State<SearchSuggestionsWidget> {
  var searchResultWidgets = <Widget>[];
  late Stream<List<SearchResult>>? resultsStream;
  @override
  initState() {
    super.initState();
    resultsStream = widget.results;
  }

  @override
  didUpdateWidget(SearchSuggestionsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.results != oldWidget.results) {
      setState(() {
        print(
          "____ in didUpdateWidget. Updating stream from ${resultsStream.hashCode} to ${widget.results.hashCode}",
        );
        searchResultWidgets.clear();
        resultsStream = widget.results!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
      "_______ rebuiding SearchSuggestionWidget with stream : ${resultsStream.hashCode}",
    );
    // return const SizedBox.shrink();
    // late final String title;
    // final resultsCount = results.length;
    // title = S.of(context).searchResultCount(resultsCount);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Bus.instance.fire(ClearAndUnfocusSearchBar());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: StreamBuilder(
          key: UniqueKey(),
          stream: resultsStream,
          builder: (context, snapshot) {
            print("-----------  ${snapshot.connectionState}");
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                print("---------- ${snapshot.data!.first.name()}");
              } else {
                print("---------- empty data");
              }
              final results = snapshot.data as List<SearchResult>;
              for (SearchResult result in results) {
                searchResultWidgets.add(SearchResultsWidgetGenerator(result));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //     // Text(
                  //     //   title,
                  //     //   style: getEnteTextTheme(context).largeBold,
                  //     // ),
                  //     const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return searchResultWidgets[index];
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                        itemCount: searchResultWidgets.length,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          bottom: (MediaQuery.sizeOf(context).height / 2) + 50,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

class SearchResultsWidgetGenerator extends StatelessWidget {
  final SearchResult result;
  const SearchResultsWidgetGenerator(this.result, {super.key});

  @override
  Widget build(BuildContext context) {
    if (result is AlbumSearchResult) {
      final AlbumSearchResult albumSearchResult = result as AlbumSearchResult;
      return SearchResultWidget(
        result,
        resultCount: CollectionsService.instance.getFileCount(
          albumSearchResult.collectionWithThumbnail.collection,
        ),
        onResultTap: () => routeToPage(
          context,
          CollectionPage(
            albumSearchResult.collectionWithThumbnail,
            tagPrefix: result.heroTag(),
          ),
        ),
      );
    } else if (result is GenericSearchResult) {
      return SearchResultWidget(
        result,
        onResultTap: (result as GenericSearchResult).onResultTap != null
            ? () => (result as GenericSearchResult).onResultTap!(context)
            : null,
      );
    } else {
      Logger('SearchResultsWidgetGenerator').info("Invalid/Unsupported value");
      return const SizedBox.shrink();
    }
  }
}
