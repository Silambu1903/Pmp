import 'dart:core';

class RatingValue {
  var id,
      date,
      department_id,
      attitude,
      on_time_delivery,
      punctuality,
      quality_of_work,
      rated_by,
      smartness,
      workstation_neatness,
      total_rating_value,
      user_id,
      team_id;

  RatingValue({
      this.id,
      this.date,
      this.department_id,
      this.attitude,
      this.on_time_delivery,
      this.punctuality,
      this.quality_of_work,
      this.smartness,
      this.workstation_neatness,
      this.total_rating_value,
      this.rated_by,
      this.user_id,
      this.team_id});

  setValueAttitude(double val) {
    attitude = val;
  }

  setValueOnTimeDelivery(double val) {
    on_time_delivery = val;
  }

  setValuePunctuality(double val) {
    punctuality = val;
  }

  setValueQualityOfWork(double val) {
    quality_of_work = val;
  }

  setValueSmartness(double val) {
    smartness = val;
  }

  setValueWorkstationNeatness(double val) {
    workstation_neatness = val;
  }
}
