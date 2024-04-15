import 'dart:io';

import 'package:agrotech_app/components/image_popup.dart';
import 'package:agrotech_app/model/prediction.dart';
import 'package:agrotech_app/screens/analysis_screen/analysis_screen.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ResultScreen extends StatefulWidget {
  static const route = '/result-screen';

  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late File? _image;
  late Prediction _prediction;

  @override
  void didChangeDependencies() {
    final Map<String, dynamic> predictionResult =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      _image = predictionResult['image'] as File?;
      _prediction = predictionResult['prediction'] as Prediction;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: () =>
                  Navigator.of(context).pushNamed(AnalysisScreen.route),
              child: Container(
                  padding: const EdgeInsets.all((8)),
                  child: const Icon(Icons.info)))
        ],
        title: const GFTypography(
          text: 'Results',
          showDivider: false,
          type: GFTypographyType.typo2,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                ImagePopup(
                  imageFile: FileImage(_image!),
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 20),
                Expanded(child: _field('Disease Name', _prediction.name)),
              ],
            ),
            const SizedBox(height: 20),
            _field('Disease Info', _prediction.information),
            const SizedBox(height: 20),
            _field('Precautions', _prediction.precautions)
          ],
        ),
      ),
    );
  }
}

Widget _field(String label, dynamic value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 14,
              color: Colors.green,
              height: 2,
              fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.green[50]),
        child: value is List<String>
            ? // Check if value is a list of precautions
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: value
                    .map((precaution) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            '- $precaution',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ))
                    .toList(),
              )
            : Text(
                value.toString(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
      ),
    ],
  );
}
