import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:foodplanner/services/fetch_meal.dart';
import 'package:foodplanner/services/api_config.dart'; // Import the api_config.dart file

class DateTimePickerWidget extends StatefulWidget {
  @override
  _DateTimePickerWidgetState createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  DateTime selectedDate = DateTime.now();
  String mealTitle = '';
  String mealImageRef = '';
  String baseUrl = ApiConfig.baseUrl;

  @override
  void initState() {
    super.initState();
    _fetchMealData();
  }

  Future<void> _fetchMealData() async {
    final mealService = MealService(apiUrl: '$baseUrl/api/meal/getmeal');
    final mealData = await mealService.fetchMealData(
        'user123', DateFormat('yyyy-MM-dd').format(selectedDate));

    setState(() {
      mealTitle = mealData['title'] ?? 'No meal available';
      mealImageRef = mealData['image_ref'] ?? '';
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _fetchMealData();
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd. MMMM').format(selectedDate);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Text(
            'Madpakke i dag d. $formattedDate',
            style: TextStyle(fontSize: 16),
          ),
        ),
        /* SizedBox(height: 20),
        Text(
          'Meal Title: $mealTitle',
          style: TextStyle(fontSize: 20),
        ),*/
        mealImageRef.isNotEmpty
            ? Image.network(
                mealImageRef,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Image not available'));
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              )
            : Container(),
      ],
    );
  }
}
