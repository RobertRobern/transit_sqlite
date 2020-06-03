import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:transit_sqlite/model/model.dart';

class DbHelper {
  String tblCustomers = "tblCustomers";
  int version = 1;
  String columnId = "id";
  String columnFname = "fname";
  String columnLname = "lname";
  String columnIdnumber = "idnumber";
  String columnPhonenumber = "phonenumber";
  String columnDestination = "destination";
  String columnDate = "date";
  String columnPlate = "vehicleplate";
  String columnResident = "resident";

  static Database _db;
  // Singleton
  DbHelper._internal();
  static final DbHelper dbHelper = DbHelper._internal();
  factory DbHelper() {
    return dbHelper;
  }

  // Get runtime reference to the database and initialization
  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = documentDirectory.path + "/transitapp.db";
    var db = await openDatabase(path, version: version, onCreate: _createDb);
    return db;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tblCustomers($columnId INTEGER PRIMARY KEY, $columnFname TEXT," +
            "$columnLname TEXT, $columnIdnumber TEXT, $columnPhonenumber TEXT," +
            "$columnDestination TEXT, $columnDate TEXT, $columnPlate TEXT," +
            "$columnResident TEXT)");
  }

  // Insert a new customer
  Future<int> insertCustomer(Customer customer) async {
    var insertQuery;
    Database database = await this.db;
    try {
      insertQuery = await database.insert(tblCustomers, customer.toMap());
    } catch (e) {
      debugPrint("InsertCustomer: " + e.toString());
    }

    return insertQuery;
  }

// Get a list of customers
  Future<List> getCusts() async {
    Database database = await this.db;
    var selectQuery = await database
        .rawQuery("SELECT * FROM $tblCustomers ORDER BY $columnFname ASC");
    return selectQuery;
  }

  // Get a customer based on the id
  Future<List> getCust(int id) async {
    Database database = await this.db;
    var selectQuery = database.rawQuery(
        "SELECT * FROM $tblCustomers WHERE $columnId = " + id.toString() + "");
    return selectQuery;
  }

  // Get the number of customers
  Future<int> getCustsCount() async {
    Database database = await this.db;
    var custCount = Sqflite.firstIntValue(
        await database.rawQuery("SELECT COUNT(*) FROM $tblCustomers"));
    return custCount;
  }

  // Get the max custumer id available on the database
  Future<int> getMaxId() async {
    Database database = await this.db;
    var maxId = Sqflite.firstIntValue(
        await database.rawQuery("SELECT MAX(id) FROM $tblCustomers"));
    return maxId;
  }

  // Update a customer
  Future<int> updateCust(Customer cust) async {
    var database = await this.db;
    var updateQuery = database.update(tblCustomers, cust.toMap(),
        where: "$columnId = ?", whereArgs: [cust.id]);
    return updateQuery;
  }

  // Delete a Cust
  Future<int> deleteCust(int id) async {
    var database = await this.db;
    var deleteQuery =
        database.rawDelete("DELETE FROM $tblCustomers WHERE $columnId = $id");
    return deleteQuery;
  }

  // Delete all customers
  Future<int> deleteRows(String tbl) async{
    var database = await this.db;
    int updateQuery = await database.rawDelete("DELETE FROM $tblCustomers");
    return updateQuery;
  }
}
