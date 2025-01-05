enum ItinerarySteps{
  locations,
  carType,
  payment,
  waitingDriver,
  offer,
  driverComing,
  tripInProgress
}

extension ActionsItinerary on ItinerarySteps{
  bool get hasNext => this != ItinerarySteps.waitingDriver;
  bool get hasPrevious => this != ItinerarySteps.locations;
}