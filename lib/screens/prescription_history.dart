import 'package:drugkit/Navigation/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drugkit/logic/prescription_history/prescription_history_cubit.dart';

class PrescriptionHistoryScreen extends StatelessWidget {
  const PrescriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
        title: const Text(
          "My Prescriptions",
          style: TextStyle(
            color: Color(0xFF0C1467),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<PrescriptionHistoryCubit, PrescriptionHistoryState>(
        builder: (context, state) {
          if (state is PrescriptionHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrescriptionHistoryError) {
            return Center(child: Text(state.message));
          } else if (state is PrescriptionHistorySuccess) {
            final prescriptions = state.prescriptions;

            if (prescriptions.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: prescriptions.length,
              itemBuilder: (context, index) {
                final item = prescriptions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Prescription ${index + 1}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0C1467),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 18, color: Colors.black54),
                          const SizedBox(width: 8),
                          Text(item.date),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.medication,
                              size: 18, color: Colors.black54),
                          const SizedBox(width: 8),
                          Text(
                              "${item.prescriptionDrugs.length} medicines detected"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.description,
                              size: 18, color: Colors.black54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Description: ${item.description}",
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0C1467),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.prescriptionDetails,
                              arguments: item,
                            );
                          },
                          child: const Text(
                            "View",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/noprescriptionIcon.png', height: 120),
          const SizedBox(height: 16),
          const Text(
            "You haven’t uploaded any prescriptions yet",
            style: TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0C1467),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.upload),
            label: const Text("Upload Your Prescription"),
          ),
        ],
      ),
    );
  }
}
