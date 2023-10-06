import 'package:flutter/foundation.dart';

class TextChanger with ChangeNotifier, DiagnosticableTreeMixin {
  String _searchService = "";
  String _searchServiceGroup = "";

  String _searchClient = "";
  String _searchClientGroup = "";

  String _searchUsers = "";
  String _searchUserRoles = "";
  String _searchDepartment = "";

  String _searchOrganization = "";
  String _searchClientResource = "";

  String _searchUserChat = "";
  String _searchClientChat = "";

  String _addService = "";
  String _addServiceGroup = "";

  String _addClient = "";
  String _addClientGroup = "";

  String _addServiceAddTask = "";
  String _addServiceAddStatus = "";

  String _addServiceAddClient = "";
  String _addServiceAddFiles = "";

  String _addServiceManagement = "";

  String _addClientAddress = "";
  String _addClientImpDate = "";

  String _addTeamNewStaff = "";
  String _addTeamNewRole = "";
  String _addTeamNewDepartment = "";


  String get searchService => _searchService;
  String get searchServiceGroup => _searchServiceGroup;

  String get searchClient => _searchClient;
  String get searchClientGroup => _searchClientGroup;

  String get searchUsers => _searchUsers;
  String get searchUserRoles => _searchUserRoles;
  String get searchDepartment => _searchDepartment;

  String get searchOrganizationResource => _searchOrganization;
  String get searchClientResource => _searchClientResource;

  String get searchUserChat => _searchUserChat;
  String get searchClientChat => _searchClientChat;

  String get addService => _addService;
  String get addServiceGroup =>_addServiceGroup;

  String get addClient => _addClient;
  String get addClientGroup =>_addClientGroup;

  String get addServiceTask => _addServiceAddTask;
  String get addServiceStatus =>_addServiceAddStatus;

  String get addServiceClient => _addServiceAddClient;
  String get addServiceFile =>_addServiceAddFiles;

  String get addServiceManagement =>_addServiceManagement;

  String get addClientAddress =>_addClientAddress;
  String get addClientImpDate =>_addClientImpDate;

  String get addTeamNewStaff =>_addTeamNewStaff;
  String get addTeamNewRole =>_addTeamNewRole;
  String get addTeamNewDepartment =>_addTeamNewDepartment;

  void setAddClient(String data) {
    _addClient = data;
    notifyListeners();
  }

  void setAddClientGroup(String data) {
    _addClientGroup = data;
    notifyListeners();
  }

  void setAddService(String data) {
    _addService = data;
    notifyListeners();
  }

  void setAddServiceGroup(String data) {
    _addServiceGroup = data;
    notifyListeners();
  }

  void setAddServiceTask(String data) {
    _addServiceAddTask = data;
    notifyListeners();
  }

  void setAddServiceStatus(String data) {
    _addServiceAddStatus = data;
    notifyListeners();
  }

  void setAddServiceClient(String data) {
    _addServiceAddClient = data;
    notifyListeners();
  }

  void setAddServiceFile(String data) {
    _addServiceAddFiles = data;
    notifyListeners();
  }

  void setAddServiceManagement(String data) {
    _addServiceManagement = data;
    notifyListeners();
  }

  void setAddClientAddress(String data) {
    _addClientAddress = data;
    notifyListeners();
  }

  void setAddClientImpDate(String data) {
    _addClientImpDate = data;
    notifyListeners();
  }

  void setAddTeamNewStaff(String data) {
    _addTeamNewStaff = data;
    notifyListeners();
  }

  void setAddTeamNewRole(String data) {
    _addTeamNewRole = data;
    notifyListeners();
  }

  void setAddTeamNewDepartment(String data) {
    _addTeamNewDepartment = data;
    notifyListeners();
  }

  void setSearchUserChat(String data) {
    _searchUserChat = data;
    notifyListeners();
  }

  void setSearchClientChat(String data) {
    _searchClientChat = data;
    notifyListeners();
  }

  void setServiceSearch(String data) {
    _searchService = data;
    notifyListeners();
  }

  void setServiceGroupSearch(String data) {
    _searchServiceGroup = data;
    notifyListeners();
  }

  void setClientSearch(String data) {
    _searchClient = data;
    notifyListeners();
  }

  void setClientGroupSearch(String data) {
    _searchClientGroup = data;
    notifyListeners();
  }

  void setDepartmentSearch(String data) {
    _searchDepartment = data;
    notifyListeners();
  }

  void setUserRolesSearch(String data) {
    _searchUserRoles = data;
    notifyListeners();
  }

  void setUsersSearch(String data) {
    _searchUsers = data;
    notifyListeners();
  }

  void setOrganizationResourceSearch(String data) {
    _searchOrganization = data;
    notifyListeners();
  }

  void setClientResourceSearch(String data) {
    _searchClientResource = data;
    notifyListeners();
  }


  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('searchService', searchService));
    properties.add(StringProperty('searchServiceGroup', searchServiceGroup));

    properties.add(StringProperty('searchClient', searchClient));
    properties.add(StringProperty('searchClientGroup', searchClientGroup));

    properties.add(StringProperty('searchUsers', searchUsers));
    properties.add(StringProperty('searchUserRoles', searchUserRoles));
    properties.add(StringProperty('searchDepartment', searchDepartment));

    properties.add(StringProperty('searchOrganizationResource', searchOrganizationResource));
    properties.add(StringProperty('searchClientResource', searchClientResource));

    properties.add(StringProperty('searchUserChat', searchUserChat));
    properties.add(StringProperty('searchClientChat', searchClientChat));

    properties.add(StringProperty('addService', addService));
    properties.add(StringProperty('addServiceGroup', addServiceGroup));

    properties.add(StringProperty('addServiceTask', addServiceTask));
    properties.add(StringProperty('addServiceStatus', addServiceStatus));

    properties.add(StringProperty('addServiceClient', addServiceClient));
    properties.add(StringProperty('addServiceFile', addServiceFile));

    properties.add(StringProperty('addServiceManagement', addServiceManagement));

    properties.add(StringProperty('addClient', addClient));
    properties.add(StringProperty('addClientGroup', addClientGroup));

    properties.add(StringProperty('addClientAddress', addClientAddress));
    properties.add(StringProperty('addClientImpDate', addClientImpDate));

    properties.add(StringProperty('addTeamNewStaff', addTeamNewStaff));
    properties.add(StringProperty('addTeamNewRole', addTeamNewRole));
    properties.add(StringProperty('addTeamNewDepartment', addTeamNewDepartment));

  }

}