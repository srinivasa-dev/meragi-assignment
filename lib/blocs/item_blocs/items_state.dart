part of 'items_bloc.dart';

abstract class ItemsState extends Equatable {
  const ItemsState();
}

class ItemsInitial extends ItemsState {
  @override
  List<Object> get props => [];
}

class ItemsLoadingState extends ItemsState {
  @override
  List<Object> get props => [];
}

class ItemsLoadedState extends ItemsState {
  final List<ItemsModel> items;

  const ItemsLoadedState({required this.items});

  @override
  List<Object?> get props => [items];

}

class ItemsErrorState extends ItemsState {

  final String error;

  const ItemsErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}