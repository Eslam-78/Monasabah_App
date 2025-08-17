import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/fav/favBloc.dart';
import '../manager/fav/favEvent.dart';
import '../manager/fav/favState.dart';

import 'favoriteservice.dart';

class FavPage extends StatefulWidget {
  final int customerId;

  FavPage({required this.customerId});

  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  late FavBloc favoriteBloc;
  late int customerId;

  @override
  void initState() {
    super.initState();
    customerId = widget.customerId;
    favoriteBloc = FavBloc(favoriteService: FavoriteService());
    favoriteBloc.add(GetFavorite(customerId: widget.customerId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المفضلة')),
      body: BlocProvider(
        create: (context) => favoriteBloc,
        child: BlocBuilder<FavBloc, FavState>(
          builder: (context, state) {
            if (state is FavoriteInitial) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FavoriteLoaded) {
              if (state.favoriteList.isNotEmpty) {
                return ListView.builder(
                  itemCount: state.favoriteList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.favoriteList[index]['name']),
                      subtitle: Text(state.favoriteList[index]['price'].toString()),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          favoriteBloc.add(UpdateFavorite(
                            customerId: customerId,
                            favorite: state.favoriteList[index],
                          ));
                        },
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text('المفضلة فارغة.'));
              }
            } else if (state is FavoriteListError) {
              return Center(child: Text(state.errorMessage));
            } else {
              return Center(child: Text('خطأ غير معروف.'));
            }
          },
        ),
      ),
    );
  }
}
