import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drugkit/models/chat_request_model.dart';
import 'package:drugkit/network/api_service.dart';

part 'chat_requests_state.dart';

class ChatRequestsCubit extends Cubit<ChatRequestsState> {
  ChatRequestsCubit() : super(ChatRequestsInitial());

  Future<void> getAllRequests() async {
    emit(ChatRequestsLoading());

    try {
      final response = await DioHelper().getData(path: "Chat/getAllRequests");
      final List<dynamic> data = response.data;
      final requests = data.map((e) => ChatRequestModel.fromJson(e)).toList();
      emit(ChatRequestsSuccess(requests));
    } catch (e) {
      emit(ChatRequestsError("Failed to load requests"));
    }
  }
}
