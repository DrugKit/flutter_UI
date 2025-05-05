class ChatRequestModel {
  final int id;
  final String request;
  final String response;
  final String date;

  ChatRequestModel({
    required this.id,
    required this.request,
    required this.response,
    required this.date,
  });

  factory ChatRequestModel.fromJson(Map<String, dynamic> json) {
    return ChatRequestModel(
      id: json['id'],
      request: json['request'],
      response: json['response'],
      date: json['date'],
    );
  }
}
