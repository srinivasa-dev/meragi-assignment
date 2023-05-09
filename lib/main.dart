import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:meragi/blocs/item_blocs/items_bloc.dart';
import 'package:meragi/models/items_model.dart';
import 'package:meragi/services/items_service.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => ItemsService(),
          ),
        ],
        child: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final ItemsBloc _itemsBloc = ItemsBloc();
  bool _loading = false;
  List<ItemsModel> _itemList = [];

  @override
  void initState() {
    _itemsBloc.add(LoadItemsBloc(context: context));
    super.initState();
  }

  @override
  void dispose() {
    _itemsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemsBloc, ItemsState>(
      bloc: _itemsBloc,
      listener: (context, state) {
        if(state is ItemsLoadingState) {
          setState(() {
            _loading = true;
          });
        } else if(state is ItemsLoadedState) {
          setState(() {
            _itemList = state.items;
            _loading = false;
          });
        } else if(state is ItemsErrorState) {
          setState(() {
            _loading = false;
          });
        } else {
          setState(() {
            _loading = false;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'ITEMS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                decoration: TextDecoration.overline,
              ),
            ),
            centerTitle: true,
          ),
          body: !_loading ? buildListView() : buildLoadingListView(),
        );
      },
    );
  }

  ListView buildLoadingListView() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[300]!,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 500,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10.0,),
                        Container(
                          height: 10,
                          width: 200,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: _itemList.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Image.network(
                  _itemList[index].image!,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _itemList[index].title!,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Colors.blue,
                            )
                        ),
                        child: Text(
                          _itemList[index].category!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      Wrap(
                        children: [
                          Text(
                            _itemList[index].rating!.rate!,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 5.0,),
                          RatingBar.builder(
                            initialRating: double.parse(_itemList[index].rating!.rate!),
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20.0,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            ignoreGestures: true,
                            onRatingUpdate: (rate) {},
                          ),
                          const SizedBox(width: 5.0,),
                          Text(
                            '(${_itemList[index].rating!.count!})',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[700]!,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      RichText(
                        text: TextSpan(
                          text: '₹',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: _itemList[index].price!,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ]
                        ),
                      ),
                      const SizedBox(height: 10.0,),
                      ExpandableText(
                        _itemList[index].description!,
                        expandText: 'show more',
                        collapseText: 'show less',
                        maxLines: 2,
                        linkColor: Colors.blue,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.grey[800]!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

