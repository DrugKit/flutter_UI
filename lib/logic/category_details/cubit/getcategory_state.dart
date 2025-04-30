part of 'getcategory_cubit.dart';

@immutable
sealed class GetcategoryState {}

final class GetcategoryInitial extends GetcategoryState {}

final class GetcategoryLoading extends GetcategoryState{}
final class GetcategorySuccess extends GetcategoryState{}

class GetcategoryError extends GetcategoryState {
  final String errorMessage;

  GetcategoryError(this.errorMessage);
}