import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



Widget defaultTextForm({
  @required TextEditingController controller,
  @required TextInputType inputType,
  @required IconData prefix,
  bool isPassword = false,
  IconData suffix,
  @required String label,
  ValueChanged<String> onSubmit,
  Function validate,
  Function suffixPressed,
  Function onTap,
  Function onChange
}) =>
    TextFormField(
      obscureText: isPassword,
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(
                  suffix,
                ),
                onPressed: suffixPressed,
              )
            : null,
        labelText: label,
      ),
      onFieldSubmitted: onSubmit,
      validator: validate,
      onTap: onTap,
      onChanged: onChange,
    );

Widget taskList(Map task) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(task['time']),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task['name'],
                style: TextStyle(fontSize: 20),
              ),
              Text(
                task['date'],
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );


Widget separator() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 1,
        color: Colors.grey,
      ),
    );



void navigateTo(context, screen)
{
  Navigator.push(
      context,
      MaterialPageRoute(builder:(context) => screen));
}

void navigateAndReplace(context, screen)
{
 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>screen), (route) => false);
}