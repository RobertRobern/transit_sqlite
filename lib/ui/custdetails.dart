import 'package:flutter/material.dart';
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
  final GlobalKey<FormState> _globalKey = new GlobalKey<FormState>();
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

  @override
  void initState() {
    super.initState();
    _initCtrls();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
