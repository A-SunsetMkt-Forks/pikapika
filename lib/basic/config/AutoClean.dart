/// 自动清理

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pikapika/basic/Method.dart';

// const _autoCleanMap = {
//   "一个月前": "${3600 * 24 * 30}",
//   "一周前": "${3600 * 24 * 7}",
//   "一天前": "${3600 * 24 * 1}",
//   "不自动清理": "${0}",
// };

const _autoCleanMap = {};

late String _autoCleanSec;

Future<dynamic> initAutoClean() async {
  _autoCleanMap.putIfAbsent(tr("settings.auto_clean.one_month_ago"), () => "${3600 * 24 * 30}");
  _autoCleanMap.putIfAbsent(tr("settings.auto_clean.one_week_ago"), () => "${3600 * 24 * 7}");
  _autoCleanMap.putIfAbsent(tr("settings.auto_clean.one_day_ago"), () => "${3600 * 24 * 1}");
  _autoCleanMap.putIfAbsent(tr("settings.auto_clean.no_auto_clean"), () => "${0}");

  _autoCleanSec =
      await method.loadProperty("autoCleanSec", "${3600 * 24 * 30}");
  if ("0" != _autoCleanSec) {
    await method.autoClean(_autoCleanSec);
  }
}

String _currentAutoCleanSec() {
  for (var value in _autoCleanMap.entries) {
    if (value.value == _autoCleanSec) {
      return value.key;
    }
  }
  return "";
}

Future<void> _chooseAutoCleanSec(BuildContext context) async {
  String? choose = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('选择自动清理周期'),
        children: <Widget>[
          ..._autoCleanMap.entries.map(
            (e) => SimpleDialogOption(
              child: Text(e.key),
              onPressed: () {
                Navigator.of(context).pop(e.value);
              },
            ),
          ),
        ],
      );
    },
  );
  if (choose != null) {
    await method.saveProperty("autoCleanSec", choose);
    _autoCleanSec = choose;
  }
}

Widget autoCleanSecSetting() {
  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return ListTile(
        title: const Text("自动清理缓存"),
        subtitle: Text(_currentAutoCleanSec()),
        onTap: () async {
          await _chooseAutoCleanSec(context);
          setState(() {});
        },
      );
    },
  );
}
