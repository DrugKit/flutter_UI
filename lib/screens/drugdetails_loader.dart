import 'package:drugkit/logic/searchdrugname/drug_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drugkit/screens/drugdetails.dart';

class DrugDetailsLoaderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrugDetailsCubit, DrugDetailsState>(
      builder: (context, state) {
        if (state is DrugDetailsLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is DrugDetailsSuccess) {
          return DrugDetailsScreen(drug: state.drug);
        } else if (state is DrugDetailsFailure) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                "Failed to load drug details.\n${state.error}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text("No data available.")),
          );
        }
      },
    );
  }
}
