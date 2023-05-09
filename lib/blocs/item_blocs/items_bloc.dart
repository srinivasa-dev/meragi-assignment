import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meragi/models/items_model.dart';
import 'package:meragi/services/items_service.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  ItemsBloc() : super(ItemsInitial()) {
    on<ItemsEvent>((event, emit) async {
      if(event is LoadItemsBloc) {
        emit(ItemsLoadingState());
        try {
          var itemsResponse = await ItemsService().getItems();

          if(itemsResponse.statusCode == 200) {
            var data = json.decode(itemsResponse.body);
            List<ItemsModel> items = [];
            for(var item in data) {
              items.add(ItemsModel.fromJson(item));
            }
            emit(ItemsLoadedState(items: items));
          } else {
            ScaffoldMessenger.of(event.context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Oops Something went wrong!',
                ),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 3),
              ),
            );
            emit(ItemsErrorState(error: itemsResponse.statusCode.toString()));
          }
        } catch (_) {
          ScaffoldMessenger.of(event.context).showSnackBar(
            SnackBar(
              content: Text(
                _.toString(),
              ),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
          emit(const ItemsErrorState(error: 'Oops Something went wrong!'));
        }
      }
    });
  }
}
