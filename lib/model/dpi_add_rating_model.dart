class DpiAddRatingList {
  var userId, taskId;
  double? ratingValue;

  DpiAddRatingList({this.userId, this.taskId, this.ratingValue});

  setUserId(var value){
    userId = value;
  }

  setTaskId(var value){
    taskId = value;
  }

  setRatingId(var value){
    ratingValue = value;
  }
}
