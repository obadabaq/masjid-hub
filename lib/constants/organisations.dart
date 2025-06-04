import 'package:adhan/adhan.dart';
import 'package:masjidhub/models/organisationModel.dart';

final List<OrganisationModel> organisationList = [
  OrganisationModel(
    id: 0,
    title: 'Muslim World League',
    param: CalculationMethod.muslim_world_league,
    supportedCountries: [],
  ),
  OrganisationModel(
    id: 1,
    title: 'Egyptian General Authority of Survey',
    param: CalculationMethod.egyptian,
    supportedCountries: [],
  ),
  OrganisationModel(
    id: 2,
    title: 'University of Islamic Sciences, Karachi',
    param: CalculationMethod.karachi,
    supportedCountries: ['PK', 'IN'],
  ),
  OrganisationModel(
    id: 3,
    title: 'Umm al-Qura University, Makkah',
    param: CalculationMethod.umm_al_qura,
    supportedCountries: ['SA'],
  ),
  OrganisationModel(
    id: 4,
    title: 'Dubai Region',
    param: CalculationMethod.dubai,
    supportedCountries: ['AE'],
  ),
  OrganisationModel(
    id: 5,
    title: 'Moon Sighting Committee',
    param: CalculationMethod.moon_sighting_committee,
    supportedCountries: [],
  ),
  OrganisationModel(
    id: 6,
    title: 'Institute of Geophysics, University of Tehran',
    param: CalculationMethod.egyptian,
    supportedCountries: [],
  ),
  OrganisationModel(
    id: 7,
    title: 'ISNA method',
    param: CalculationMethod.north_america,
    supportedCountries: ['US'],
  ),
  OrganisationModel(
    id: 8,
    title: 'Kuwait',
    param: CalculationMethod.kuwait,
    supportedCountries: ['KW'],
  ),
  OrganisationModel(
    id: 9,
    title: 'Qatar',
    param: CalculationMethod.qatar,
    supportedCountries: ['QA'],
  ),
  OrganisationModel(
    id: 10,
    title: 'Majlis Ugama Islam Singapura',
    param: CalculationMethod.singapore,
    supportedCountries: ['MY', 'SG'],
  ),
  OrganisationModel(
    id: 11,
    title: 'Diyanet İşleri Başkanlığı, Turkey',
    param: CalculationMethod.turkey,
    supportedCountries: ['TR'],
  ),
  OrganisationModel(
    id: 12,
    title: 'University of Tehran',
    param: CalculationMethod.tehran,
    supportedCountries: [],
  ),
];
