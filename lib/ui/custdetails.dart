import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:transit_sqlite/model/model.dart';
import 'package:transit_sqlite/util/dbhelper.dart';
import 'package:transit_sqlite/util/util.dart';

const menuDelete = "Delete";
const menuEdit = "Edit";
final List<String> menuOptions = const <String>[menuEdit, menuDelete];

class CustDetail extends StatefulWidget {
  Customer cust;
  final DbHelper dbHelper = DbHelper();
  CustDetail(this.cust);

  @override
  _CustDetailState createState() => _CustDetailState();
}

class _CustDetailState extends State<CustDetail> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController fNameCtrl = TextEditingController();
  final TextEditingController lNameCtrl = TextEditingController();
  final TextEditingController idNumberCtrl =
      new MaskedTextController(mask: '00000000');
  final TextEditingController phoneNumberCtrl =
      new MaskedTextController(mask: '000-000-0000');
  final TextEditingController destinationCtrl = TextEditingController();
  final TextEditingController dateCtrl =
      new MaskedTextController(mask: '00/00/0000');
  final TextEditingController vehiclePlateCtrl = TextEditingController();
  final TextEditingController residentialCtrl = TextEditingController();

  // Initialization code
  void _initCtrls() {
    fNameCtrl.text = widget.cust.fName != null ? widget.cust.fName : "";
    lNameCtrl.text = widget.cust.lName != null ? widget.cust.lName : "";
    idNumberCtrl.text =
        widget.cust.idNumber != null ? widget.cust.idNumber : "";
    phoneNumberCtrl.text =
        widget.cust.phoneNumber != null ? widget.cust.phoneNumber : "";
    destinationCtrl.text =
        widget.cust.destination != null ? widget.cust.dateTime : "";
    dateCtrl.text =
        widget.cust.dateTime != null ? widget.cust.dateTime != null : "";
    vehiclePlateCtrl.text =
        widget.cust.vehiclPlate != null ? widget.cust.vehiclPlate : "";
    residentialCtrl.text =
        widget.cust.residential != null ? widget.cust.residential : "";
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = DateUtils.convertToDate(initialDateString) ?? now;

    initialDate = (initialDate.year >= now.year &&
            initialDate.month >= now.month &&
            initialDate.day >= now.day)
        ? initialDate
        : now;

    DatePicker.showDatePicker(context, showTitleActions: true,
        onConfirm: (date) {
      setState(() {
        DateTime dt = date;
        String r = DateUtils.convertDateToStr(dt);
        dateCtrl.text = r;
      });
    }, currentTime: initialDate);
  }

  // Upper Menu
  void _selectMenu(String value) async {
    switch (value) {
      case menuDelete:
        if (widget.cust.id == -1) {
          return;
        }
        await _deleteCust(widget.cust.id);
    }
  }

  // Delete Customer
  void _deleteCust(int id) async {
    await widget.dbHelper.deleteCust(widget.cust.id);
    Navigator.pop(context, true);
  }

  // Save cust
  void _saveCust() {
    widget.cust.fName = fNameCtrl.text;
    widget.cust.lName = lNameCtrl.text;
    widget.cust.idNumber = int.parse(idNumberCtrl.text);
    widget.cust.phoneNumber = int.parse(phoneNumberCtrl.text);
    widget.cust.destination = destinationCtrl.text;
    widget.cust.dateTime = dateCtrl.text;
    widget.cust.vehiclPlate = vehiclePlateCtrl.text;

    if (widget.cust.id > -1) {
      debugPrint("_update->Customer Id: " + widget.cust.id.toString());
      widget.dbHelper.updateCust(widget.cust);
      Navigator.pop(context, true);
    } else {
      Future<int> idMax = widget.dbHelper.getMaxId();
      idMax.then((result) {
        debugPrint("_insert->Customer Id: " + widget.cust.id.toString());
        widget.cust.id = (result != null) ? result + 1 : 1;
        widget.dbHelper.insertCustomer(widget.cust);
        Navigator.pop(context, true);
      });
    }
  }

  // Submit form
  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Some data is invalid. Please correct.');
    } else {
      _saveCust();
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      backgroundColor: color,
    ));
  }

  @override
  void initState() {
    super.initState();
    _initCtrls();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.headline6;
    String title = widget.cust.fName;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(title != "" ? widget.cust.fName : "New Customer"),
        actions: (title == "")
            ? <Widget>[]
            : <Widget>[
                PopupMenuButton(
                    onSelected: _selectMenu,
                    itemBuilder: (BuildContext context) {
                      return menuOptions.map((String select) {
                        return PopupMenuItem<String>(
                            value: select, child: Text(select));
                      }).toList();
                    })
              ],
      ),
      body: Form(
          key: _formKey,
          autovalidate: true,
          child: SafeArea(
            top: false,
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                TextFormField(
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]"))
                  ],
                  controller: fNameCtrl,
                  style: titleStyle,
                  validator: (val) => Validations.validateFname(val),
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: "Enter your first name",
                    labelText: "First Name",
                  ),
                ),
                TextFormField(
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]"))
                  ],
                  controller: lNameCtrl,
                  style: titleStyle,
                  validator: (val) => Validations.validateLname(val),
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: "Enter your last name",
                    labelText: "Last Name",
                  ),
                ),
                TextFormField(
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  controller: idNumberCtrl,
                  style: titleStyle,
                  validator: (val) =>
                      Validations.validateIdNumber(int.parse(val)),
                  decoration: InputDecoration(
                    icon: Icon(Icons.perm_identity),
                    hintText: "Enter your ID number",
                    labelText: "ID Number",
                  ),
                ),
                TextFormField(
                  maxLength: 10,
                  controller: phoneNumberCtrl,
                  keyboardType: TextInputType.number,
                  validator: (val) => Validations.validatePhoneNumber(int.parse(val)),
                  decoration: InputDecoration(
                    icon: Icon(Icons.dialpad),
                    hintText: "Enter your phone number",
                    labelText: "Phone Number",
                  ),
                ),
                TextFormField(
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]"))
                  ],
                  controller: destinationCtrl,
                  style: titleStyle,
                  validator: (val) => Validations.validateDestination(val),
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: "Enter the destination name",
                    labelText: "Destination Name",
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        controller: dateCtrl,
                        style: titleStyle,
                        validator: (val) => DateUtils.isValidDate(val)
                            ? null
                            : "Not a valid date",
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Current date (i.e. 01/01/2020)',
                          labelText: "Travel Date",
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.more_horiz),
                        onPressed: () {
                          _chooseDate(context, dateCtrl.text);
                        })
                  ],
                ),
                TextFormField(
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]"))
                  ],
                  controller: vehiclePlateCtrl,
                  validator: (val) => Validations.validateVehiclePlate(val),
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: "Enter vehicle plate",
                    labelText: "Vehicle Plate",
                  ),
                ),
                TextFormField(
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]"))
                  ],
                  controller: fNameCtrl,
                  style: titleStyle,
                  validator: (val) => Validations.validateResidential(val),
                  decoration: InputDecoration(
                    icon: Icon(Icons.extension),
                    hintText: "Enter place of resident",
                    labelText: "Residential",
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    top: 20.0,
                  ),
                  child:
                      RaisedButton(child: Text("Save"), onPressed: _submitForm),
                )
              ],
            ),
          )),
    );
  }
}
