String getLoginDetails = r'''
                      query GetLoginDetails($_eq: String = "",$_eq1: String = "",) {
  Project_Management_Process_user_registration(where: {employe_code: {_eq: $_eq}, password: {_eq: $_eq1}}) {
    avatar
    created_date
    created_id
    email
    employe_code
    id
    is_active
    mobile_no
    password
    type
    user_name
    department_id
    team_id
  }
}
''';

String getLoginDetailsWithoutPassword = r'''
                      query GetLoginDetails($_eq: String = "") {
  Project_Management_Process_user_registration(where: {employe_code: {_eq: $_eq}}) {
    avatar
    created_date
    created_id
    email
    employe_code
    id
    is_active
    mobile_no
    password
    type
    user_name
    department_id
    team_id
  }
}
''';

String taskListUserQuery = r'''
                    query MyQuery($user_id: uuid = "",$project_id: uuid = "") {
  Project_Management_Process_task_assign(where: {userRegistrationByAssigneeToId: {id: {_eq: $user_id}}, task_creation: {project_id: {_eq: $project_id}}}) {
    id
    date
    active
    project_assgin_id
    task_assign_hrs
    task_id
    task_creation {
      project_id
      planned_hrs
      task_name
      task_description
      id
    }
  }
}
''';

String qpiProjectCalculation = r'''
                  query MyQuery($projectId: uuid = "") {
  Project_Management_Process_project_creation(where: {id: {_eq: $projectId}}) {
    id
    project_weightage
    project_name
    project_assigns {
      id
      user_registration {
        id
        user_name
        team_id
        department_id
      }
      daily_reports_aggregate {
        aggregate {
          sum {
            spent_hrs
          }
        }
      }
      task_assigns_aggregate {
        aggregate {
          sum {
            task_assign_hrs
          }
        }
      }
    }
  }
}

''';


String insertUser =
    r''' mutation insertUser($user_name: String = "", $email: String = "", $password: String = "", $type: String = "", $mobile_no: String = "", $employe_code: String = "",  $is_active: Boolean!, $avatar: String = "", $created_id: uuid = "", $department_id: uuid = "", $team_id: uuid = "" ){
insert_Project_Management_Process_user_registration(objects: {user_name: $user_name, email: $email, password: $password, type: $type, mobile_no: $mobile_no, employe_code: $employe_code, avatar: $avatar, is_active: $is_active, created_id: $created_id, department_id: $department_id, team_id: $team_id}) {
    returning {
      id
    }
  }
}  
''';

String insertDpiQuery =
    r''' mutation MyMutation($user_id: uuid = "",$ratedby_id: uuid = "",$task_id: uuid = "",$team_id: uuid = "",$department_id: uuid = "",$rating: float8! = "",$createdDate: date! ) {
  insert_Project_Management_Process_daily_performance_index(objects: {user_id:$user_id, task_id: $task_id,rated_by:$ratedby_id, rating:$rating,team_id:$team_id,department_id:$department_id,created_date:$createdDate}) {
    returning {
      id
    }
  }
}
''';

String insertSpiQuery =
    r''' 
mutation MyMutation($user_id: uuid = "",$ratedby_id: uuid = "",$team_id: uuid = "",$department_id: uuid = "",$rating: float8! = "",$createdDate: date!) {
  insert_Project_Management_Process_supervisors_performance_index(objects: {user_id:$user_id,rated_by:$ratedby_id, rating:$rating,team_id:$team_id,department_id:$department_id,created_date:$createdDate}) {
    returning {
      id
    }
  }
}
''';


String insertQpiQuery = r'''
                   mutation MyMutation($user_id:uuid="",$project_id:uuid="",$team_id:uuid="",$rating : float8!,$ratedby_id: uuid = "",$department_id: uuid = "") {
  insert_Project_Management_Process_quality_performance_index(objects: {user_id: $user_id, project_id: $project_id, rating_value: $rating,team_id:$team_id,rated_by:$ratedby_id,department_id:$department_id}) {
    returning {
      id
    }
  }
}
''';

String insertPriQuery = r'''
mutation MyMutation($user_id:uuid="",$project_id:uuid="",$team_id:uuid="",$rating : float8!,$ratedby_id: uuid = "",$department_id: uuid = "") {
  insert_Project_Management_Process_productivity_index(objects: {user_id: $user_id, project_id: $project_id, rating: $rating,team_id:$team_id,rated_by:$ratedby_id,department_id:$department_id}) {
    returning {
      id
    }
  }
}
''';


String insertDailyTask =
    r'''mutation insertDailyTask($user_id: uuid = "", $team_id: uuid = "", $task_details: String = "", $spent_hrs: float8!, $remarks: String = "", $project_id: uuid = "", $department_id: uuid = "",$task_assign_id: uuid = "",$project_assgin_id: uuid = "") {
  insert_Project_Management_Process_daily_report(objects: {user_id: $user_id, team_id: $team_id, task_details: $task_details, spent_hrs: $spent_hrs, remarks: $remarks, project_id: $project_id, department_id: $department_id, task_assign_id: $task_assign_id,project_assgin_id:$project_assgin_id}) {
    returning {
      id
    }
  }
}
''';

String insertCommentQuery =
    r''' mutation Project_Management_Process_project_comments($user_id: uuid = "", $project_id: uuid = "", $comment: String = ""){
 insert_Project_Management_Process_project_comments(objects: {user_id: $user_id, project_id: $project_id, comment: $comment}) {
    returning {
      id
    }
  }
}  
''';

String projectAssign =
    r''' mutation projectAssign($assigned_id: uuid = "", $user_id: uuid = "", $project_id: uuid = "", $is_active: Boolean!, $assigned_hrs: Boolean! ){
 insert_Project_Management_Process_project_assign(objects: {assigned_id: $assigned_id, is_active: $is_active, user_id: $user_id, project_id: $project_id, assigned_hrs: $assigned_hrs}) {
    returning {
      id
    }
  }
}  
''';

String projectAssignUser =
    r'''query MyQuery($project_id: uuid = "", $assigned_id: uuid = "",$task_id: uuid = "") {
 item : Project_Management_Process_project_assign(where: {project_id: {_eq: $project_id}, assigned_id: {_eq: $assigned_id}}) {
    id
    user_registration {
      avatar
      password
      mobile_no
      is_active
      id
      employe_code
      user_name
      email
      department_id
     
    }
  }
 item1 : Project_Management_Process_project_assign(where: {project_id: {_eq: $project_id}, user_id: {_eq: $assigned_id}}) {
    id
    user_registration {
      avatar
      password
      mobile_no
      is_active
      id
      employe_code
      user_name
      email
      department_id
     
    }
  }
Project_Management_Process_task_assign(where: {task_id: {_eq: $task_id}}){
      id
     task_assign_hrs
        userRegistrationByAssigneeToId {
          user_name
          id
        }
  }
}
''';

String taskAssignQuery =
    r''' mutation MyMutation($task_id: uuid = "", $project_assgin_id: uuid = "",$assignee_to_id: uuid = "",$assigned_by_id: uuid = "", $task_assign_hrs: float8!) {
  insert_Project_Management_Process_task_assign(objects: {task_id: $task_id, project_assgin_id: $project_assgin_id, task_assign_hrs: $task_assign_hrs, assignee_to_id: $assignee_to_id, assigned_by_id:$assigned_by_id}) {
    returning {
      id
    }
  }
}
''';

String taskAssignUpdateQuery =
    r''' mutation MyMutation($taskId:uuid = "",$hours :float8!) {
  update_Project_Management_Process_task_assign(where: {id: {_eq: $taskId}}, _set: {task_assign_hrs:$hours}) {
    returning {
      id
    }
  }
}
''';

String projectAssignByTeamLead =
    r''' mutation projectAssign($assigned_id: uuid = "", $user_id: uuid = "", $project_id: uuid = "", $is_active: Boolean!,$assigned_hrs: Boolean!){
 insert_Project_Management_Process_project_assign(objects: {assigned_id: $assigned_id, is_active: $is_active, user_id: $user_id, assigned_hrs: $assigned_hrs, project_id: $project_id}) {
    returning {
      id
    }
  }
}  
''';

String projectAssignHours =
    r''' mutation projectAssign($id: uuid = "",$assign_hr: String = "",$assigned_hrs: Boolean!){
 insert_Project_Management_Process_assign_hrs(objects: {id: $id ,assign_hrs: $assign_hr}) {
    returning {
      id
    }
  }
 update_Project_Management_Process_project_assign(where: {id: {_eq: $id}}, _set: {assigned_hrs: $assigned_hrs}) {
    returning {
      assigned_hrs
    }
  }
}  
''';

String updateProjectQuery = r'''
mutation update_Project_Management_Process_project_creation($_eq: uuid = "",$delivery_date: String = "", $planned_hrs : String = "", $description : String = "", $project_code : String = "", $project_name : String = "", $update_date : String = "", $deparment_id: uuid = "", $create_date: String = "",$is_active : Boolean!) {
  update_Project_Management_Process_project_creation(where: {id: {_eq: $_eq}}, _set: {project_name: $project_name, project_code: $project_code, planned_hrs: $planned_hrs, is_active: $is_active, description: $description, deparment_id:  $deparment_id delivery_date: $delivery_date, create_date: $create_date, update_date: $update_date}) {
    returning {
      id
      planned_hrs
    }
  }
}
''';

String updateProjectStatusQuery = r'''
mutation update_Project_Management_Process_project_creation($_eq: uuid = "",$status: String = "") {
  update_Project_Management_Process_project_creation(where: {id: {_eq: $_eq}}, _set: {status: $status}) {
    returning {
      id
      planned_hrs
    }
  }
}
''';

String updateUserQuery = r''' 
mutation MyMutation($employe_code: String = "", $user_name : String = "", $email : String = "", $password : String = "", $mobile_no : String = "", $is_active : Boolean!) {
  update_Project_Management_Process_user_registration(where: {employe_code: {_eq: $employe_code}}, _set: {user_name: $user_name, email: $email, password: $password, mobile_no: $mobile_no, is_active: $is_active}) {
    returning {
      id
      user_name
      is_active
    }
  }
} 
''';

String updateUserPassword =
    r''' mutation updateUserPassword($_eq:String ="", $password: String = ""){
update_Project_Management_Process_user_registration(where: {employe_code: {_eq: $_eq}}, _set: {password: password}) {
    returning {
      password
    }
  }
}  
''';

String getDepartmentDetails = r''' query getDepartmentDetails(){
Project_Management_Process_department_creation {
    group
    id
    is_active
  }
  Project_Management_Process_team_creation {
    team_name
    id
    department_id
  }
}
''';

String getTeamDetails = r''' query getTeamDetails($_eq: uuid = ""){
  Project_Management_Process_team_creation(where: {department_id: {_eq: $_eq}}) {
    department_id
    icon
    team_name
    id
  }
}
''';

String getCommentsQuery = r''' query getTeamDetails($_eq: uuid = ""){
  Project_Management_Process_project_comments(where: {project_id: {_eq: $_eq}}) {
     user_id
    project_id
    date
    comment
    user_registration {
      user_name
      avatar
    }
  }
}
''';
String getCreatedUser = r''' query getCreatedUser($_eq: uuid = ""){
   Project_Management_Process_user_registration(where: {created_id: {_eq:$_eq}} , order_by: {id: asc, is_active: desc}) {
    avatar
    created_date
    created_id
    email
    employe_code
    id
    is_active
    mobile_no
    password
    type
    user_name
    department_id
    team_id
  }
}
''';

String dpiRatingQuery =
    r''' query getDailyTask($_eq1: date!, $_eq2: uuid = "") {
  Project_Management_Process_daily_report(where: {date: {_eq: $_eq1}, user_id: {_eq: $_eq2}}, order_by: {created_date: desc}) {
    user_id
    team_id
    task_details
    spent_hrs
    remarks
    project_id
    department_id
    created_date
    task_assign {
       id
      task_id
      task_assign_hrs
      task_creation {
        task_name
      }
    }
    project_creation {
      project_code
      project_name
      project_weightage
    }
  }
}
''';

String getDailyTask =
    r'''query getDailyTask($_eq1: uuid = "", $_eq2: uuid = "") {
  Project_Management_Process_daily_report(where: {task_assign_id: {_eq: $_eq1}, user_id: {_eq: $_eq2}}, order_by: {created_date: desc}) {
    user_id
    team_id
    task_details
    spent_hrs
    remarks
    project_id
    department_id
    created_date
  }
}
''';

String getTeamReport = r'''query MyQuery($_eq: uuid = "") {
  Project_Management_Process_team_creation(where: {department_id: {_eq: $_eq}}) {
    id
    team_name
    daily_reports_aggregate {
      aggregate {
        sum {
          spent_hrs
        }
      }
    }
    daily_reports {
      created_date
      spent_hrs
      remarks
      task_details
      user_registration {
        user_name
        employe_code
        avatar
      }
      project_creation {
        project_code
        project_name
      }
      department_creation {
        group
      }
    }
  }
}
''';

String getTeamLeadReportQuery = r'''query MyQuery($_eq: uuid = "") {
  Project_Management_Process_team_creation(where: {id: {_eq: $_eq}}) {
    team_name
    daily_reports_aggregate {
      aggregate {
        sum {
          spent_hrs
        }
      }
    }
    daily_reports {
      created_date
      spent_hrs
      remarks
      task_details
      user_registration {
        user_name
        employe_code
        avatar
      }
      project_creation {
        project_code
        project_name
      }
      department_creation {
        group
      }
    }
  }
}
''';

String getRatingData = r'''query MyQuery {
  item1: Project_Management_Process_rating_performance_aggregate {
    aggregate {
      avg {
        attitude
        on_time_delivery
        punctuality
        quality_of_work
        smartness
        total_rating_value
        workstation_neatness
      }
    }
  }
  item2:Project_Management_Process_rating_performance {
    id
    date
    department_id
    attitude
    on_time_delivery
    punctuality
    quality_of_work
    rated_by
    smartness
    workstation_neatness
    total_rating_value
    user_id
    team_id
    department_id
  userRegistrationByUserId{
    user_name
  }
    user_registration {
      user_name
    }
    team_creation {
      team_name
    }
  }
}
''';

String getOverAllRatingQuery = r'''query MyQuery {
  Project_Management_Process_user_registration {
    user_name
    employe_code
    type
    daily_performance_indices_aggregate {
      aggregate {
        sum {
          rating
        }
      }
    }
    productivity_indices_aggregate {
      aggregate {
        sum {
          rating
        }
      }
    }
    quality_performance_indices_aggregate {
      aggregate {
        sum {
          rating_value
        }
      }
    }
    supervisors_performance_indices_aggregate {
      aggregate {
        sum {
          rating
        }
      }
    }  
  }
  Project_Management_Process_daily_performance_index_aggregate {
    aggregate {
      sum {
        rating
      }
      count
    }
  }
  Project_Management_Process_supervisors_performance_index_aggregate {
    aggregate {
      sum {
        rating
      }
      count
    }
  }
  Project_Management_Process_quality_performance_index_aggregate {
    aggregate {
      sum {
        rating_value
      }
      count
    }
  }
  Project_Management_Process_productivity_index_aggregate {
    aggregate {
      sum {
        rating
      }
      count
    }
  }
}
''';

String getOverAllRatingDepartmentWiseQuery = r'''query MyQuery($_eq: uuid = "") {
  Project_Management_Process_user_registration(where: {department_id: {_eq: $_eq}}) {
    user_name
    employe_code
    type
    daily_performance_indices_aggregate {
      aggregate {
        sum {
          rating
        }
      }
    }
    productivity_indices_aggregate {
      aggregate {
        sum {
          rating
        }
      }
    }
    quality_performance_indices_aggregate {
      aggregate {
        sum {
          rating_value
        }
      }
    }
    supervisors_performance_indices_aggregate {
      aggregate {
        sum {
          rating
        }
      }
    }
  }
  Project_Management_Process_daily_performance_index_aggregate(where: {department_id: {_eq:$_eq}}) {
    aggregate {
      sum {
        rating
      }
      count
    }
  }
  Project_Management_Process_supervisors_performance_index_aggregate(where: {department_id: {_eq: $_eq}}) {
    aggregate {
      sum {
        rating
      }
      count
    }
  }
  Project_Management_Process_quality_performance_index_aggregate(where: {department_id: {_eq: $_eq}}) {
    aggregate {
      sum {
        rating_value
      }
      count
    }
  }
  Project_Management_Process_productivity_index_aggregate(where: {department_id: {_eq: $_eq}}) {
    aggregate {
      sum {
        rating
      }
      count
    }
  }
}

''';

String getOverAllRatingTeamWiseQuery = r'''query MyQuery($_eq: uuid = "") {
  Project_Management_Process_user_registration(where: {team_id: {_eq: $_eq}}) {
    user_name
    employe_code
    type
    daily_performance_indices_aggregate {
      aggregate {
        sum {
          rating
        }
      }
    }
    productivity_indices_aggregate {
      aggregate {
        sum {
          rating
        }
      }
    }
    quality_performance_indices_aggregate {
      aggregate {
        sum {
          rating_value
        }
      }
    }
    supervisors_performance_indices_aggregate {
      aggregate {
        sum {
          rating
        }
      }
    }
  }
  Project_Management_Process_daily_performance_index_aggregate(where: {team_id: {_eq:$_eq}}) {
    aggregate {
      sum {
        rating
      }
      count
    }
  }
  Project_Management_Process_supervisors_performance_index_aggregate(where: {team_id: {_eq: $_eq}}) {
    aggregate {
      sum {
        rating
      }
      count
    }
  }
  Project_Management_Process_quality_performance_index_aggregate(where: {team_id: {_eq: $_eq}}) {
    aggregate {
      sum {
        rating_value
      }
      count
    }
  }
  Project_Management_Process_productivity_index_aggregate(where: {team_id: {_eq: $_eq}}) {
    aggregate {
      sum {
        rating
      }
      count
    }
  }
}
''';

String getRatingDataByDep = r'''query MyQuery($_eq: uuid = "") {
  item1: Project_Management_Process_rating_performance_aggregate(where: {department_id: {_eq: $_eq}}) {
    aggregate {
      avg {
        attitude
        on_time_delivery
        punctuality
        quality_of_work
        smartness
        total_rating_value
        workstation_neatness
      }
    }
  }
  item2: Project_Management_Process_rating_performance(where: {department_id: {_eq: $_eq}}) {
    id
    date
    department_id
    attitude
    on_time_delivery
    punctuality
    quality_of_work
    rated_by
    smartness
    workstation_neatness
    total_rating_value
    user_id
    team_id
    department_id
    userRegistrationByUserId {
      user_name
    }
    user_registration {
      user_name
    }
    team_creation {
      team_name
    }
  }
}
''';

String getRatingDataByTeam = r'''query MyQuery($_eq: uuid = "") {
  item1: Project_Management_Process_rating_performance_aggregate(where: {team_id: {_eq: $_eq}}) {
    aggregate {
      avg {
        attitude
        on_time_delivery
        punctuality
        quality_of_work
        smartness
        total_rating_value
        workstation_neatness
      }
    }
  }
  item2: Project_Management_Process_rating_performance(where: {team_id: {_eq: $_eq}}) {
    id
    date
    department_id
    attitude
    on_time_delivery
    punctuality
    quality_of_work
    rated_by
    smartness
    workstation_neatness
    total_rating_value
    user_id
    team_id
    department_id
    userRegistrationByUserId {
      user_name
    }
    user_registration {
      user_name
    }
    team_creation {
      team_name
    }
  }
}
''';

String getProjectReportSuperAdmin = r'''query MyQuery {
  Project_Management_Process_project_creation {
    project_code
    project_name
    create_date
    delivery_date
    planned_hrs
    status
    allocation_projects {
      planned_hrs
      team_creation {
        team_name
      }
    }
    daily_reports {
      spent_hrs
      team_creation {
        team_name
      }
    }
    daily_reports_aggregate {
      aggregate {
        sum {
          spent_hrs
        }
      }
    }
  }
}

''';

String getProjectReportTeamLead =
    r'''query MyQuery($_eq: uuid = "", $_date: String = "", $_status: String = "") {
  Project_Management_Process_allocation_project(where: {team_id: {_eq: $_eq}, project_creation: {status: {_eq: $_status}, create_date: {_iregex:  $_date}}}, order_by: {project_creation: {update_date: desc}}) {
    project_creation {
      project_code
      project_name
      create_date
      delivery_date
      planned_hrs
      status
      daily_reports(where: {team_id: {_eq: $_eq}}) {
        spent_hrs
        user_registration {
          user_name
        }
      }
      daily_reports_aggregate(where: {team_id: {_eq: $_eq}}) {
        aggregate {
          sum {
            spent_hrs
          }
        }
      }
    }
  }
}
''';

String getProjectReportDepartmentHead =
    r'''query MyQuery($_eq: uuid = "", $_date: String = "", $_status: String = "") {
  Project_Management_Process_project_creation(where: {deparment_id: {_eq: $_eq}, create_date: {_iregex: $_date}, status: {_eq: $_status}}, order_by: {update_date: desc}) {
    project_code
    project_name
    create_date
    delivery_date
    planned_hrs
    status
    allocation_projects {
      planned_hrs
      team_creation {
        team_name
      }
    }
    daily_reports {
      spent_hrs
      team_creation {
        team_name
      }
    }
    daily_reports_aggregate {
      aggregate {
        sum {
          spent_hrs
        }
      }
    }
  }
}
''';

String getCreatedUserByTeam = r''' query getCreatedUser($_eq: uuid = ""){
   item1: Project_Management_Process_user_registration(where: {created_id: {_eq: $_eq}}) {
    avatar
    created_date
    created_id
    department_id
    email
    employe_code
    is_active
    id
    mobile_no
    password
    team_id
    type
    user_name
  }
    item2: Project_Management_Process_user_registration(where: {id: {_eq: $_eq}}) {
    avatar
    created_date
    created_id
    department_id
    email
    employe_code
    is_active
    id
    mobile_no
    password
    team_id
    type
    user_name
  }
}
''';

String getTeamListQuery = r''' query getCreatedUser($_eq: uuid = "") {
  Project_Management_Process_user_registration(where: {team_id: {_eq: $_eq}}) {
    avatar
    created_date
    created_id
    department_id
    email
    employe_code
    is_active
    id
    mobile_no
    password
    team_id
    type
    user_name
    daily_reports_aggregate {
      aggregate {
        sum {
          spent_hrs
        }
      }
    }
  }
}
''';

String getIndividualReportQuery =
    r'''query MyQuery($_eq: uuid = "", $_date: String = "") {
  Project_Management_Process_daily_report(order_by: {created_date: desc}, where: {user_id: {_eq: $_eq}, created_date: {_iregex: $_date}}) {
    user_registration {
      user_name
      id
    }
    department_id
    remarks
    spent_hrs
    task_details
    created_date
    project_creation {
      project_name
    }
  }
  Project_Management_Process_daily_report_aggregate {
    aggregate {
      sum {
        spent_hrs
      }
    }
  }
}
''';

String getAssigneeTeamQuery =
    r'''query MyQuery($_eq1: uuid = "", $_eq2: uuid = "") {
  Project_Management_Process_project_assign(where: {user_id: {_eq: $_eq1}}, order_by: {project_creation: {update_date: desc}}) {
    assigned_date
    assigned_id
    is_active
    id
    project_id
    project_creation {
      project_code
      project_name
      planned_hrs
      is_active
      status
      id
      description
      deparment_id
      delivery_date
      create_date
      allocation_projects(where: {team_id: {_eq: $_eq2}}) {
        is_active
        planned_hrs
        created_id
        created_date
        project_id
        team_id
        id
      }
      project_assigns {
        user_id
        assigned_hrs
        assign_hr {
          id
          assign_hrs
        }
      }
      project_comments {
        user_registration {
          user_name
        }
        comment
      }
    }
    assign_hr {
      assign_hrs
    }
  }
}
''';

String getAssigneeFilterTeamQuery =
    r'''query MyQuery($_eq1: uuid = "", $_eq2: uuid = "", $_date: String = "", $_status: String = "") {
  Project_Management_Process_project_assign(where: {user_id: {_eq: $_eq1}, project_creation: {status: {_eq: $_status}, create_date: {_iregex: $_date}}}, order_by: {project_creation: {update_date: desc}}) {
    assigned_date
    assigned_id
    is_active
    id
    project_id
    project_creation {
      daily_reports_aggregate(where:{user_id: {_eq: $_eq1}}){
        aggregate{
          sum{
            spent_hrs
          }
        }
      }
      project_code
      project_name
      planned_hrs
      is_active
      status
      id
      description
      deparment_id
      delivery_date
      create_date
      allocation_projects(where: {team_id: {_eq: $_eq2}}) {
        is_active
        planned_hrs
        created_id
        created_date
        project_id
        team_id
        id
      }
      project_assigns {
        user_id
        assigned_hrs
        assign_hr {
          id
          assign_hrs
        }
      }
      project_comments {
        user_registration {
          user_name
        }
        comment
      }
    }
    assign_hr {
      assign_hrs
    }
  }
}

''';

String getAssigneIndividualTeamQuery =
r'''query MyQuery($_eq1: uuid = "", $_eq2: uuid = "", $project_id: uuid = "") {
  Project_Management_Process_project_assign(where: {user_id: {_eq: $_eq1}, project_creation: {id: {_eq: $project_id},}}) {
    assigned_date
    assigned_id
    is_active
    id
    project_id
    project_creation {
      daily_reports_aggregate(where:{user_id: {_eq: $_eq1}}){
        aggregate{
          sum{
            spent_hrs
          }
        }
      }
      project_code
      project_name
      planned_hrs
      is_active
      status
      id
      description
      deparment_id
      delivery_date
      create_date
      allocation_projects(where: {team_id: {_eq: $_eq2}}) {
        is_active
        planned_hrs
        created_id
        created_date
        project_id
        team_id
        id
      }
      project_assigns {
        user_id
        assigned_hrs
        assign_hr {
          id
          assign_hrs
        }
      }
      project_comments {
        user_registration {
          user_name
        }
        comment
      }
    }
    assign_hr {
      assign_hrs
    }
  }
}
''';


String insertConferenceBookingQuery =
    r'''mutation MyMutation($_eq1: uuid = "", $_eq2: uuid = "", $_date: String = "", $_description: String = "",$_start_time: String = "", $_end_time: String = "") {
  insert_Project_Management_Process_conference_booking(objects: {date:  $_date, department_id: $_eq1, description:$_description, end_time: $_end_time, start_time:$_start_time, team_id: $_eq2}) {
    returning {
      id
    }
  }
}
''';

String mutationRating = r'''
mutation MyMutation($ratedBy: uuid = "",  $userId: uuid = "", $teamid: uuid = "", $departmentid: uuid = "", $workstation_neatness: float8!, $total_rating_value: float8!, $smartness:  float8!, $quality_of_work: float8!, $punctuality: float8!, $on_time_delivery: float8!, $attitude:  float8!) {
  insert_Project_Management_Process_rating_performance(objects: {rated_by: $ratedBy,  user_id: $userId, team_id: $teamid, department_id: $departmentid, workstation_neatness: $workstation_neatness, total_rating_value:$total_rating_value, smartness: $smartness, quality_of_work: $quality_of_work, punctuality: $punctuality, on_time_delivery: $on_time_delivery, attitude:  $attitude}) {
    returning {
      id
    }
  }
}
''';

String mutationDateRating = r'''
mutation MyMutation($ratedBy: uuid = "", $ratingId: uuid = "", $ratingValue: float8!, $userId: uuid = "",$date: date = "",$teamid : uuid = "",$departmentid : uuid = "") {
  insert_Project_Management_Process_rating_performance(objects: {rated_by: $ratedBy, rating_id: $ratingId, rating_value: $ratingValue, user_id: $userId, date: $date, team_id: $teamid, department_id: $departmentid}) {
    returning {
      id
    }
  }
}
''';

String mutationManagerRating = r'''
mutation MyMutation($ratedBy: uuid = "",  $userId: uuid = "",$departmentid : uuid = "", $workstation_neatness: float8!, $total_rating_value: float8!, $smartness:  float8!, $quality_of_work: float8!, $punctuality: float8!, $on_time_delivery: float8!, $attitude:  float8!) {
  insert_Project_Management_Process_rating_performance(objects: {rated_by: $ratedBy,  user_id: $userId, department_id: $departmentid, workstation_neatness: $workstation_neatness, total_rating_value:$total_rating_value, smartness: $smartness, quality_of_work: $quality_of_work, punctuality: $punctuality, on_time_delivery: $on_time_delivery, attitude:  $attitude}) {
    returning {
      id
    }
  }
}
''';

String mutationManagerDateRating = r'''
mutation MyMutation($ratedBy: uuid = "", $ratingId: uuid = "", $ratingValue: float8!, $userId: uuid = "",$date: date = "",$departmentid : uuid = "") {
  insert_Project_Management_Process_rating_performance(objects: {rated_by: $ratedBy, rating_id: $ratingId, rating_value: $ratingValue, user_id: $userId, date: $date, department_id: $departmentid}) {
    returning {
      id
    }
  }
}
''';

String queryRatingList = r'''
query MyQuery {
  Project_Management_Process_rating_title (order_by: {title_id: asc}){
    description
    maxvalue
    name
    title_id
  }
}
''';

String performanceQuery = r'''
query MyQuery($_eq: uuid = "") {
  Project_Management_Process_daily_performance_index_aggregate(where: {user_id: {_eq: $_eq}}) {
    aggregate {
      sum {
        rating
      }
      avg {
        rating
      }
      count
    }
  }
  Project_Management_Process_supervisors_performance_index_aggregate(where: {user_id: {_eq: $_eq}}) {
    aggregate {
      sum {
        rating
      }
      avg {
        rating
      }
      count
    }
  }
   Project_Management_Process_quality_performance_index_aggregate(where: {user_id: {_eq: $_eq}}) {
    aggregate {
      sum {
        rating_value
      }
      avg {
        rating_value
      }
      count
    }
  }
  Project_Management_Process_productivity_index_aggregate(where: {user_id: {_eq: $_eq}}) {
    aggregate {
      sum {
        rating
      }
      avg {
        rating
      }
      count
    }
  }
}
''';

String queryCheckSupervisorsRatingDate = r'''
query MyQuery($userId : uuid = "", $date : date!) {
  Project_Management_Process_daily_performance_index(where: {user_id: {_eq: $userId}, _and: {created_date: {_eq: $date}}}) {
    user_id
    date
  }
  Project_Management_Process_supervisors_performance_index(where: {user_id: {_eq: $userId}, _and: {created_date: {_eq: $date}}}) {
    user_id
    date
  }
}
''';



String getAssigneeDepartment = r'''query MyQuery($_eq: uuid = "") {
  Project_Management_Process_project_assign(where: {user_id: {_eq: $_eq}}, order_by: {project_creation: {update_date: desc}}) {
    assigned_date
    assigned_id
    is_active
    id
    project_id
    project_creation {
      project_code
      project_name
      planned_hrs
      is_active
      status
      description
      deparment_id
      delivery_date
      create_date
      allocation_projects {
        planned_hrs
        team_creation {
          team_name
        }
      }
      project_assigns {
        user_id
        assigned_hrs
        assign_hr {
          id
          assign_hrs
        }
      }
      project_comments {
        comment
        user_registration {
          user_name
        }
      }
    }
  }
}
''';

String getAssigneeFilterManagerQuery =
    r'''query MyQuery($_eq: uuid = "", $_date: String = "", $_status: String = "") {
  Project_Management_Process_project_assign(where: {user_id: {_eq: $_eq}, project_creation: {status: {_eq: $_status}, create_date: {_iregex: $_date}}}, order_by: {project_creation: {update_date: desc}}) {
    assigned_date
    assigned_id
    is_active
    id
    project_id
    project_creation {
      project_code
      project_name
      planned_hrs
      is_active
      status
      description
      deparment_id
      delivery_date
      create_date
      allocation_projects(where: {project_creation: {}}) {
        planned_hrs
        team_creation {
          team_name
        }
      }
      project_assigns {
        user_id
        assigned_hrs
        assign_hr {
          id
          assign_hrs
        }
      }
      project_comments {
        comment
        user_registration {
          user_name
        }
      }
    }
  }
}
''';

String getAssigneeIndividualManagerQuery =
r'''query MyQuery($_eq: uuid = "",$project_id: uuid = "") {
  Project_Management_Process_project_assign(where: {user_id: {_eq: $_eq}, project_creation: {id:{_eq:$project_id}}}) {
    assigned_date
    assigned_id
    is_active
    id
    project_id
    project_creation {
      project_code
      project_name
      planned_hrs
      is_active
      status
      description
      deparment_id
      delivery_date
      create_date
      allocation_projects(where: {project_creation: {}}) {
        planned_hrs
        team_creation {
          team_name
        }
      }
      project_assigns {
        user_id
        assigned_hrs
        assign_hr {
          id
          assign_hrs
        }
      }
      project_comments {
        comment
        user_registration {
          user_name
        }
      }
    }
  }
}
''';


String deleteQuery = r'''
mutation MyMutation($employe_code : String = "", $is_active : Boolean!) {
  update_Project_Management_Process_user_registration(where: {employe_code: {_eq: $employe_code}}, _set: {is_active: $is_active}) {
    returning {
      is_active
    }
  }
}
''';

String createProjectQuery = r'''
mutation createProject($delivery_date: String = "", $planned_hrs: String = "", $description: String = "", $project_code: String = "", $project_name: String = "", $update_date: String = "", $deparment_id: uuid = "", $create_date: String = "", $is_active: Boolean!, $status: String = "",$projectValue: float8!, $projectWeightage: float8!) {
  insert_Project_Management_Process_project_creation(objects: {delivery_date: $delivery_date, description: $description, planned_hrs: $planned_hrs, project_code: $project_code, project_name: $project_name, update_date: $update_date, create_date: $create_date, deparment_id: $deparment_id, is_active: $is_active, status: $status, project_value:$projectValue, project_weightage: $projectWeightage}) {
    returning {
      id
      planned_hrs
    }
  }
}
''';

String addProjectTaskQuery = r'''
mutation MyMutation($created_id: uuid = "", $planned_hrs: float8! = "", $description: String = "", $task_name: String = "", $team_id: uuid = "",$project_id: uuid = "") {
  insert_Project_Management_Process_task_creation(objects: {created_id: $created_id,  planned_hrs: $planned_hrs, project_id: $project_id, task_description: $description, task_name: $task_name, team_id: $team_id}) {
    returning {
      id
    }
  }
}
''';

String updateAssignHrs = r'''
mutation MyMutation($_eq: uuid = "",$assign_hrs: String = "") {
  update_Project_Management_Process_assign_hrs(where: {id: {_eq: $_eq}}, _set: {assign_hrs: $assign_hrs}) {
    returning {
      id
    }
  }
}
''';

String projectAllocation = r'''
mutation MyMutation($planned_hrs : String = "", $created_id : uuid = "",$is_active : Boolean!  $team_id : uuid = "", $project_id : uuid = "") {
  insert_Project_Management_Process_allocation_project(objects: {created_id: $created_id, is_active: $is_active, planned_hrs: $planned_hrs, team_id: $team_id, project_id: $project_id}) {
    returning {
      id
    }
  }
}
''';

String projectAllocationUpdate = r'''
mutation MyMutation($_eq : uuid = "", $planned_hrs : String = "", $created_id : uuid = "",$is_active : Boolean!  $team_id : uuid = "", $project_id : uuid = "") {
   update_Project_Management_Process_allocation_project(where: {id: {_eq: $_eq}}, _set: {team_id: $team_id, project_id: $project_id, planned_hrs: $planned_hrs, created_id: $created_id, is_active: $is_active}) {
    returning {
      id
    }
  }
}
''';

String getProjectDetails =
    r''' query MyQuery($_eq: uuid = "", $_date: String = "", $_status: String = "") {
  Project_Management_Process_project_creation(where: {deparment_id: {_eq: $_eq}}, order_by: {update_date: desc}) {
    create_date
    delivery_date
    deparment_id
    description
    id
    is_active
    planned_hrs
    project_code
    project_name
    update_date
    status
    project_assigns {
      user_id
      project_id
      id
      assigned_id
      assigned_date
      is_active
      assign_hr {
        assign_hrs
        id
      }
    }
    allocation_projects {
      team_id
      project_id
      planned_hrs
      is_active
      id
      created_id
      created_date
      team_creation {
        team_name
      }
    }
    project_comments {
      user_registration {
        user_name
      }
      comment
    }
  }
}
''';

String getTaskListDetailsQuery =
    r''' query MyQuery($created_id: uuid = "", $project_id: uuid = "") {
  Project_Management_Process_task_creation(where: {created_id: {_eq: $created_id}, project_id: {_eq: $project_id}}) {
    team_id
    task_name
    task_description
    project_id
    planned_hrs
    date
    created_id
    id
  }
  Project_Management_Process_task_creation_aggregate(where: {created_id: {_eq: $created_id}, project_id: {_eq: $project_id}}) {
    aggregate {
      sum {
        planned_hrs
      }
    }
  }
}
''';

String getTaskManagerListDetailsQuery =
    r''' query MyQuery($created_id: uuid = "", $project_id: uuid = "") {
  Project_Management_Process_task_creation(where: {created_id: {_eq: $created_id}, project_id: {_eq: $project_id}}) {
    team_id
    task_name
    task_description
    project_id
    planned_hrs
    date
    created_id
    id
    task_assigns {
      task_assign_hrs
      id
      date
    }
  }
  Project_Management_Process_task_creation_aggregate(where: {created_id: {_eq: $created_id}, project_id: {_eq: $project_id}}) {
    aggregate {
      sum {
        planned_hrs
      }
    }
  }
}
''';

String getFilterProjectDetails =
    r''' query MyQuery($_eq: uuid = "", $_date: String = "", $_status: String = "") {
  Project_Management_Process_project_creation(where: {deparment_id: {_eq: $_eq}, create_date: {_iregex: $_date}, status: {_eq: $_status}}, order_by: {update_date: desc}) {
    create_date
    delivery_date
    deparment_id
    description
    id
    is_active
    planned_hrs
    project_code
    project_name
    update_date
    status
    project_assigns {
      user_id
      project_id
      id
      assigned_id
      assigned_date
      is_active
      assign_hr {
        assign_hrs
        id
      }
    }
    allocation_projects {
      team_id
      project_id
      planned_hrs
      is_active
      id
      created_id
      created_date
      team_creation {
        team_name
      }
    }
    project_comments {
      user_registration {
        user_name
      }
      comment
    }
  }
}
''';

String getFilterIndividualProjectDetailsDepHeadQuery =
r''' query MyQuery($_project_id: uuid = "") {
  Project_Management_Process_project_creation(where: {id: {_eq: $_project_id}}) {
    create_date
    delivery_date
    deparment_id
    description
    id
    is_active
    planned_hrs
    project_code
    project_name
    update_date
    status
    project_assigns {
      user_id
      project_id
      id
      assigned_id
      assigned_date
      is_active
      assign_hr {
        assign_hrs
        id
      }
    }
    allocation_projects {
      team_id
      project_id
      planned_hrs
      is_active
      id
      created_id
      created_date
      team_creation {
        team_name
      }
    }
    project_comments {
      user_registration {
        user_name
      }
      comment
    }
  }
}
''';

String getProjectDetailsSuperAdmin = r''' query MyQuery {
  Project_Management_Process_project_creation {
    create_date
    delivery_date
    id
    description
    deparment_id
    is_active
    planned_hrs
    project_code
    project_name
    update_date
    status
    allocation_projects {
      planned_hrs
      team_creation {
        team_name
      }
    }
project_comments {
      comment
      user_registration {
        user_name
      }
    }
  }
}
''';

String getProjectCodeDetails = r''' query MyQuery($_eq: String = "") {
  Project_Management_Process_project_creation(where: {project_code: {_eq: $_eq}}) {
    update_date
    team_id
    project_name
    project_code
    planned_hrs
    is_active
    id
    description
    delivery_date
    create_date
    team_creation {
      department_id
      icon
      id
      team_name
    }
  }
}
''';
