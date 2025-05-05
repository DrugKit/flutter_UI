import 'package:drugkit/logic/chat_requests/chat_requests_cubit.dart';
import 'package:drugkit/models/chat_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatbotRequestsScreen extends StatelessWidget {
  const ChatbotRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatRequestsCubit()..getAllRequests(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(),
          title: const Text(
            "My requests",
            style: TextStyle(
              color: Color(0xFF0C1467),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<ChatRequestsCubit, ChatRequestsState>(
          builder: (context, state) {
            if (state is ChatRequestsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatRequestsError) {
              return Center(child: Text(state.message));
            } else if (state is ChatRequestsSuccess) {
              final requests = state.requests;

              if (requests.isEmpty) {
                return const Center(child: Text("No requests found."));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final ChatRequestModel request = requests[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Request ${index + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF0C1467),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Symptoms:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0C1467),
                            ),
                          ),
                          Text(request.request),
                          const SizedBox(height: 6),
                          const Text(
                            "Recommendation:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0C1467),
                            ),
                          ),
                          Text(request.response),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Image.asset(
                                'assets/calendar.png',
                                height: 18,
                                width: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                request.date.split("T").first, // just the date
                                style: const TextStyle(
                                  color: Color(0xFF0C1467),
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
