part of 'items_bloc.dart';

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();
}

class LoadItemsBloc extends ItemsEvent {
  final BuildContext context;

  const LoadItemsBloc({required this.context});

  @override
  List<Object?> get props => [context];
}
