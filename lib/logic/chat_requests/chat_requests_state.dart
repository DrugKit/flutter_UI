// chat_requests_state.dart
part of 'chat_requests_cubit.dart';

abstract class ChatRequestsState {}

class ChatRequestsInitial extends ChatRequestsState {}

class ChatRequestsLoading extends ChatRequestsState {}

class ChatRequestsSuccess extends ChatRequestsState {
  final List<ChatRequestModel> requests;

  ChatRequestsSuccess(this.requests);
}

class ChatRequestsError extends ChatRequestsState {
  final String message;

  ChatRequestsError(this.message);
}
