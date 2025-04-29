part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<DrugModel> drugs;

  SearchSuccess(this.drugs);
}

class SearchError extends SearchState {
  final String errorMessage;

  SearchError(this.errorMessage);
}
