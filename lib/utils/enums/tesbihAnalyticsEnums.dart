enum TesbihAnalyticsState { daily, weekly, monthly, yearly }

// To map daily count to different analytical views
const Map<TesbihAnalyticsState, int> multipleMapping = {
  TesbihAnalyticsState.daily: 1,
  TesbihAnalyticsState.weekly: 7, // One week has 7 days
  TesbihAnalyticsState.monthly: 30,
  TesbihAnalyticsState.yearly: 365,
};

const TesbihAnalyticsState defaultState = TesbihAnalyticsState.daily;

extension TesbihState on TesbihAnalyticsState {
  int get multiples => multipleMapping[this] ?? defaultState.multiples;
}
