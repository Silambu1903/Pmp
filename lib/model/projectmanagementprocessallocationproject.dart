class ProjectManagementProcessAllocationProject {



  String ?teamId;
  String ?projectId;
  String ?plannedHrs;
  bool?  isActive;
  String ? id;
  String  ? createdId;
  String? teamName;

  ProjectManagementProcessAllocationProject({
      this.teamId,
      this.projectId,
      this.plannedHrs,
      this.isActive,
      this.id,
      this.createdId,
      this.teamName});


  setTeam(String val){
    teamName = val;
  }


  setCreatedId(String val){
    createdId = val;
  }

  setProjectId(String val){
    projectId = val;
  }

  setTeamId(String val){
    teamId = val;
  }

  setHours(String val){
    plannedHrs = val;
  }

  setIsActive(bool val){
    isActive = val;
  }


}
