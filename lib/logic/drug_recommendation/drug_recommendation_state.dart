part of 'drug_recommendation_cubit.dart';

@immutable
abstract class DrugRecommendationState {}

class DrugRecommendationInitial extends DrugRecommendationState {}

class DrugRecommendationLoading extends DrugRecommendationState {}

class DrugRecommendationSuccess extends DrugRecommendationState {
  final List<DrugRecommendationModel> drugs;

  DrugRecommendationSuccess(this.drugs);
}

class DrugRecommendationError extends DrugRecommendationState {
  final String message;

  DrugRecommendationError(this.message);
}
