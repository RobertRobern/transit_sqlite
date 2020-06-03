class Customer {
  int id;
  String fName;
  String lName;
  int idNumber;
  int phoneNumber;
  String destination;
  String dateTime;
  String vehiclPlate;
  String residential;

  Customer(this.fName, this.lName, this.idNumber, this.phoneNumber,
      this.destination, this.dateTime, this.vehiclPlate, this.residential);

  // Named constructor
  Customer.withId(
      this.id,
      this.fName,
      this.lName,
      this.idNumber,
      this.phoneNumber,
      this.destination,
      this.dateTime,
      this.vehiclPlate,
      this.residential);

  // Method to write data to the database
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['fName'] = this.fName;
    map['lName'] = this.lName;
    map['idNumber'] = this.idNumber;
    map['phoneNumber'] = this.phoneNumber;
    map['destination'] = this.destination;
    map['dateTime'] = this.dateTime;
    map['vehiclPlate'] = this.vehiclPlate;
    map['residential'] = this.residential;

    if (id != null) {
      map['id'] = this.id;
    }
     
     return map;
  }

  // Method to read data to the database
  Customer.fromMap(dynamic o){
    this.id = o['id'];
    this.fName = o['fName'];
    this.lName = o['lName'];
    this.idNumber = o['idNumber'];
    this.phoneNumber = o['phoneNumber'];
    this.destination = o['destination'];
    this.dateTime = o['dateTime'];
    this.vehiclPlate = o['vehiclPlate'];
    this.residential = o['residential'];
  }
}
