import 'package:adhan/adhan.dart';

class OrganisationModel {
  final int id;
  final String title;
  final CalculationMethod param;
  final List<String> supportedCountries;

  OrganisationModel({
    required this.id,
    required this.title,
    required this.param,
    required this.supportedCountries,
  });
}
