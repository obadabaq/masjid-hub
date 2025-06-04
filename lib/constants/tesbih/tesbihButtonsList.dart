import 'package:masjidhub/models/tesbih/tesbihAnalyticsStateModel.dart';
import 'package:masjidhub/utils/enums/tesbihAnalyticsEnums.dart';

final List<TesbihAnalyticsStateModel> tesbihButtonsList = [
  TesbihAnalyticsStateModel(
    label: 'daily',
    state: TesbihAnalyticsState.daily,
  ),
  TesbihAnalyticsStateModel(
    label: 'weekly',
    state: TesbihAnalyticsState.weekly,
  ),
  TesbihAnalyticsStateModel(
    label: 'monthly',
    state: TesbihAnalyticsState.monthly,
  ),
  TesbihAnalyticsStateModel(
    label: 'yearly',
    state: TesbihAnalyticsState.yearly,
  ),
];
