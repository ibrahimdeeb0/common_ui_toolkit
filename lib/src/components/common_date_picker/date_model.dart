import 'dart:math';

import './index.dart';

//interface for picker data model
abstract class CommonBasePickerModel {
  //a getter method for left column data, return null to end list
  String? leftStringAtIndex(int index);

  //a getter method for middle column data, return null to end list
  String? middleStringAtIndex(int index);

  //a getter method for right column data, return null to end list
  String? rightStringAtIndex(int index);

  //set selected left index
  void setLeftIndex(int index);

  //set selected middle index
  void setMiddleIndex(int index);

  //set selected right index
  void setRightIndex(int index);

  //return current left index
  int currentLeftIndex();

  //return current middle index
  int currentMiddleIndex();

  //return current right index
  int currentRightIndex();

  //return final time
  DateTime? finalTime();

  //return left divider string
  String leftDivider();

  //return right divider string
  String rightDivider();

  //layout proportions for 3 columns
  List<int> layoutProportions();
}

//a base class for picker data model
class CommonPickerModel extends CommonBasePickerModel {
  CommonPickerModel({LocaleType? locale}) : locale = locale ?? LocaleType.en;

  late List<String> leftList;
  late List<String> middleList;
  late List<String> rightList;
  late DateTime currentTime;
  late int _currentLeftIndex;
  late int _currentMiddleIndex;
  late int _currentRightIndex;

  late LocaleType locale;

  @override
  String? leftStringAtIndex(int index) {
    return null;
  }

  @override
  String? middleStringAtIndex(int index) {
    return null;
  }

  @override
  String? rightStringAtIndex(int index) {
    return null;
  }

  @override
  int currentLeftIndex() {
    return _currentLeftIndex;
  }

  @override
  int currentMiddleIndex() {
    return _currentMiddleIndex;
  }

  @override
  int currentRightIndex() {
    return _currentRightIndex;
  }

  @override
  void setLeftIndex(int index) {
    _currentLeftIndex = index;
  }

  @override
  void setMiddleIndex(int index) {
    _currentMiddleIndex = index;
  }

  @override
  void setRightIndex(int index) {
    _currentRightIndex = index;
  }

  @override
  String leftDivider() {
    return '';
  }

  @override
  String rightDivider() {
    return '';
  }

  @override
  List<int> layoutProportions() {
    return <int>[1, 1, 1];
  }

  @override
  DateTime? finalTime() {
    return null;
  }
}

//a date picker model
class CommonDatePickerModel extends CommonPickerModel {
  CommonDatePickerModel({
    DateTime? currentTime,
    DateTime? maxTime,
    DateTime? minTime,
    LocaleType? locale,
  }) : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970);

    currentTime = currentTime ?? DateTime.now();

    if (currentTime.compareTo(this.maxTime) > 0) {
      currentTime = this.maxTime;
    } else if (currentTime.compareTo(this.minTime) < 0) {
      currentTime = this.minTime;
    }

    this.currentTime = currentTime;

    _fillLeftLists();
    _fillMiddleLists();
    _fillRightLists();
    final int minMonth = _minMonthOfCurrentYear();
    final int minDay = _minDayOfCurrentMonth();
    _currentLeftIndex = this.currentTime.year - this.minTime.year;
    _currentMiddleIndex = this.currentTime.month - minMonth;
    _currentRightIndex = this.currentTime.day - minDay;
  }
  late DateTime maxTime;
  late DateTime minTime;

  void _fillLeftLists() {
    leftList =
        List<String>.generate(maxTime.year - minTime.year + 1, (int index) {
      // print('LEFT LIST... ${minTime.year + index}${_localeYear()}');
      return '${minTime.year + index}${_localeYear()}';
    });
  }

  int _maxMonthOfCurrentYear() {
    return currentTime.year == maxTime.year ? maxTime.month : 12;
  }

  int _minMonthOfCurrentYear() {
    return currentTime.year == minTime.year ? minTime.month : 1;
  }

  int _maxDayOfCurrentMonth() {
    final int dayCount =
        calculateDateCount(currentTime.year, currentTime.month);
    return currentTime.year == maxTime.year &&
            currentTime.month == maxTime.month
        ? maxTime.day
        : dayCount;
  }

  int _minDayOfCurrentMonth() {
    return currentTime.year == minTime.year &&
            currentTime.month == minTime.month
        ? minTime.day
        : 1;
  }

  void _fillMiddleLists() {
    final int minMonth = _minMonthOfCurrentYear();
    final int maxMonth = _maxMonthOfCurrentYear();

    middleList = List<String>.generate(maxMonth - minMonth + 1, (int index) {
      return _localeMonth(minMonth + index);
    });
  }

  void _fillRightLists() {
    final int maxDay = _maxDayOfCurrentMonth();
    final int minDay = _minDayOfCurrentMonth();
    rightList = List<String>.generate(maxDay - minDay + 1, (int index) {
      return '${minDay + index}${_localeDay()}';
    });
  }

  @override
  void setLeftIndex(int index) {
    super.setLeftIndex(index);
    //adjust middle
    final int destYear = index + minTime.year;
    int minMonth = _minMonthOfCurrentYear();
    DateTime newTime;
    //change date time
    if (currentTime.month == 2 && currentTime.day == 29) {
      newTime = currentTime.isUtc
          ? DateTime.utc(
              destYear,
              currentTime.month,
              calculateDateCount(destYear, 2),
            )
          : DateTime(
              destYear,
              currentTime.month,
              calculateDateCount(destYear, 2),
            );
    } else {
      newTime = currentTime.isUtc
          ? DateTime.utc(
              destYear,
              currentTime.month,
              currentTime.day,
            )
          : DateTime(
              destYear,
              currentTime.month,
              currentTime.day,
            );
    }
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillMiddleLists();
    _fillRightLists();
    minMonth = _minMonthOfCurrentYear();
    final int minDay = _minDayOfCurrentMonth();
    _currentMiddleIndex = currentTime.month - minMonth;
    _currentRightIndex = currentTime.day - minDay;
  }

  @override
  void setMiddleIndex(int index) {
    super.setMiddleIndex(index);
    //adjust right
    final int minMonth = _minMonthOfCurrentYear();
    final int destMonth = minMonth + index;
    DateTime newTime;
    //change date time
    final int dayCount = calculateDateCount(currentTime.year, destMonth);
    newTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          )
        : DateTime(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          );
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillRightLists();
    final int minDay = _minDayOfCurrentMonth();
    _currentRightIndex = currentTime.day - minDay;
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
    final int minDay = _minDayOfCurrentMonth();
    currentTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            minDay + index,
          )
        : DateTime(
            currentTime.year,
            currentTime.month,
            minDay + index,
          );
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < middleList.length) {
      return middleList[index];
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < rightList.length) {
      return rightList[index];
    } else {
      return null;
    }
  }

  String _localeYear() {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '年';
    } else if (locale == LocaleType.ko) {
      return '년';
    } else {
      return '';
    }
  }

  String _localeMonth(int month) {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '$month月';
    } else if (locale == LocaleType.ko) {
      return '$month월';
    } else {
      final List<String> monthStrings =
          i18nObjInLocale(locale)['monthLong'] as List<String>;
      return monthStrings[month - 1];
    }
  }

  String _localeDay() {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '日';
    } else if (locale == LocaleType.ko) {
      return '일';
    } else {
      return '';
    }
  }

  @override
  DateTime finalTime() {
    return currentTime;
  }
}

//a time picker model
class CommonTimePickerModel extends CommonPickerModel {
  CommonTimePickerModel(
      {DateTime? currentTime,
      LocaleType? locale,
      this.showSecondsColumn = true})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();

    _currentLeftIndex = this.currentTime.hour;
    _currentMiddleIndex = this.currentTime.minute;
    _currentRightIndex = this.currentTime.second;
  }
  bool showSecondsColumn;

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return ':';
  }

  @override
  String rightDivider() {
    if (showSecondsColumn) {
      return ':';
    } else {
      return '';
    }
  }

  @override
  List<int> layoutProportions() {
    if (showSecondsColumn) {
      return <int>[1, 1, 1];
    } else {
      return <int>[1, 1, 0];
    }
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
            _currentLeftIndex, _currentMiddleIndex, _currentRightIndex)
        : DateTime(currentTime.year, currentTime.month, currentTime.day,
            _currentLeftIndex, _currentMiddleIndex, _currentRightIndex);
  }
}

//a time picker model
class CommonTime12hPickerModel extends CommonPickerModel {
  CommonTime12hPickerModel({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();

    _currentLeftIndex = this.currentTime.hour % 12;
    _currentMiddleIndex = this.currentTime.minute;
    _currentRightIndex = this.currentTime.hour < 12 ? 0 : 1;
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 12) {
      if (index == 0) {
        return digits(12, 2);
      } else {
        return digits(index, 2);
      }
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index == 0) {
      return i18nObjInLocale(locale)['am'] as String?;
    } else if (index == 1) {
      return i18nObjInLocale(locale)['pm'] as String?;
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return ':';
  }

  @override
  String rightDivider() {
    return ':';
  }

  @override
  List<int> layoutProportions() {
    return <int>[1, 1, 1];
  }

  @override
  DateTime finalTime() {
    final int hour = _currentLeftIndex + 12 * _currentRightIndex;
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
            hour, _currentMiddleIndex)
        : DateTime(currentTime.year, currentTime.month, currentTime.day, hour,
            _currentMiddleIndex);
  }
}

// a date&time picker model
class CommonDateTimePickerModel extends CommonPickerModel {
  CommonDateTimePickerModel(
      {DateTime? currentTime,
      DateTime? maxTime,
      DateTime? minTime,
      LocaleType? locale})
      : super(locale: locale) {
    if (currentTime != null) {
      this.currentTime = currentTime;
      if (maxTime != null &&
          (currentTime.isBefore(maxTime) ||
              currentTime.isAtSameMomentAs(maxTime))) {
        this.maxTime = maxTime;
      }
      if (minTime != null &&
          (currentTime.isAfter(minTime) ||
              currentTime.isAtSameMomentAs(minTime))) {
        this.minTime = minTime;
      }
    } else {
      this.maxTime = maxTime;
      this.minTime = minTime;
      final DateTime now = DateTime.now();
      if (this.minTime != null && this.minTime!.isAfter(now)) {
        this.currentTime = this.minTime!;
      } else if (this.maxTime != null && this.maxTime!.isBefore(now)) {
        this.currentTime = this.maxTime!;
      } else {
        this.currentTime = now;
      }
    }

    if (this.minTime != null &&
        this.maxTime != null &&
        this.maxTime!.isBefore(this.minTime!)) {
      // invalid
      this.minTime = null;
      this.maxTime = null;
    }

    _currentLeftIndex = 0;
    _currentMiddleIndex = this.currentTime.hour;
    _currentRightIndex = this.currentTime.minute;
    if (this.minTime != null && isAtSameDay(this.minTime!, this.currentTime)) {
      _currentMiddleIndex = this.currentTime.hour - this.minTime!.hour;
      if (_currentMiddleIndex == 0) {
        _currentRightIndex = this.currentTime.minute - this.minTime!.minute;
      }
    }
  }
  DateTime? maxTime;
  DateTime? minTime;

  bool isAtSameDay(DateTime? day1, DateTime? day2) {
    return day1 != null &&
        day2 != null &&
        day1.difference(day2).inDays == 0 &&
        day1.day == day2.day;
  }

  @override
  void setLeftIndex(int index) {
    super.setLeftIndex(index);
    final DateTime time = currentTime.add(Duration(days: index));
    if (isAtSameDay(minTime, time)) {
      final int index = min(24 - minTime!.hour - 1, _currentMiddleIndex);
      setMiddleIndex(index);
    } else if (isAtSameDay(maxTime, time)) {
      final int index = min(maxTime!.hour, _currentMiddleIndex);
      setMiddleIndex(index);
    }
  }

  @override
  void setMiddleIndex(int index) {
    super.setMiddleIndex(index);
    final DateTime time = currentTime.add(Duration(days: _currentLeftIndex));
    if (isAtSameDay(minTime, time) && index == 0) {
      final int maxIndex = 60 - minTime!.minute - 1;
      if (_currentRightIndex > maxIndex) {
        _currentRightIndex = maxIndex;
      }
    } else if (isAtSameDay(maxTime, time) &&
        _currentMiddleIndex == maxTime!.hour) {
      final int maxIndex = maxTime!.minute;
      if (_currentRightIndex > maxIndex) {
        _currentRightIndex = maxIndex;
      }
    }
  }

  @override
  String? leftStringAtIndex(int index) {
    final DateTime time = currentTime.add(Duration(days: index));
    if (minTime != null &&
        time.isBefore(minTime!) &&
        !isAtSameDay(minTime!, time)) {
      return null;
    } else if (maxTime != null &&
        time.isAfter(maxTime!) &&
        !isAtSameDay(maxTime, time)) {
      return null;
    }
    return formatDate(time, <String>[ymdw], locale);
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      final DateTime time = currentTime.add(Duration(days: _currentLeftIndex));
      if (isAtSameDay(minTime, time)) {
        if (index >= 0 && index < 24 - minTime!.hour) {
          return digits(minTime!.hour + index, 2);
        } else {
          return null;
        }
      } else if (isAtSameDay(maxTime, time)) {
        if (index >= 0 && index <= maxTime!.hour) {
          return digits(index, 2);
        } else {
          return null;
        }
      }
      return digits(index, 2);
    }

    return null;
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      final DateTime time = currentTime.add(Duration(days: _currentLeftIndex));
      if (isAtSameDay(minTime, time) && _currentMiddleIndex == 0) {
        if (index >= 0 && index < 60 - minTime!.minute) {
          return digits(minTime!.minute + index, 2);
        } else {
          return null;
        }
      } else if (isAtSameDay(maxTime, time) &&
          _currentMiddleIndex >= maxTime!.hour) {
        if (index >= 0 && index <= maxTime!.minute) {
          return digits(index, 2);
        } else {
          return null;
        }
      }
      return digits(index, 2);
    }

    return null;
  }

  @override
  DateTime finalTime() {
    final DateTime time = currentTime.add(Duration(days: _currentLeftIndex));
    int hour = _currentMiddleIndex;
    int minute = _currentRightIndex;
    if (isAtSameDay(minTime, time)) {
      hour += minTime!.hour;
      if (minTime!.hour == hour) {
        minute += minTime!.minute;
      }
    }

    return currentTime.isUtc
        ? DateTime.utc(time.year, time.month, time.day, hour, minute)
        : DateTime(time.year, time.month, time.day, hour, minute);
  }

  @override
  List<int> layoutProportions() {
    return <int>[4, 1, 1];
  }

  @override
  String rightDivider() {
    return ':';
  }
}
