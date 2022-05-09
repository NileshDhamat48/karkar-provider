import 'package:intl/intl.dart';
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';

class Formatter {
  String formatTimeG({required String time, required BuildContext context}) {
    String mytime = '';
    DateTime nows = DateTime.now();

    if (time.isNotEmpty) {
      var hr = int.parse(time.split(":")[0]);
      var min = int.parse(time.split(":")[1]);
      var newDate = DateTime(nows.year, nows.month, nows.day, hr, min);

      if (newDate != '') {
        var mytime = DateFormat('hh:mm a').format(newDate);

        return mytime;
      }
      return mytime;
    }
    return mytime;
  }

  String dateformatG({required String date}) {
    String mydate = '';
    if (date != '') {
      var parseDate = DateTime.parse(date);
      var formatedDate = DateFormat('dd MMMM yyyy').format(parseDate);
      return formatedDate;
    }
    return mydate;
  }

  IconData ratingG({required String rating}) {
    if (rating != '') {
      var rate = double.parse(rating);

      if (rate == 0) {
        return Icons.star_border;
      } else if (rate > 2.5) {
        return Icons.star_half;
      } else if (rate > 4) {
        return Icons.star_purple500_outlined;
      } else {
        return Icons.star_border;
      }
    }
    return Icons.star_border;
  }

  String capitalize({required String text}) {
    String x = '';
    if (text != '') {
      var fL = text.substring(0, 1).toUpperCase();
      var oL = text.substring(1).toLowerCase();
      x = fL + oL;
      return x;
    }
    return x;
  }

  String dateTImeformatG({required String date, required String time}) {
    String mydate = '';
    if (date != '' && time != '') {
      var f = date + ' ' + time;
      var parseDate = DateTime.parse(f);
      var formatedDate = DateFormat('dd MMM yyyy hh:mm a').format(parseDate);
      return formatedDate;
    }
    return mydate;
  }

  static Gradient paymentStatusColor({required String text}) {
    Gradient x = AppColors.greyGradient;
    if (text != '') {
      switch (text) {
        case 'PAID':
          x = AppColors.appGradient;
          break;
        case 'UNPAID':
          x = AppColors.greyGradient;
          break;
        default:
          x;
      }
      return x;
    }
    return x;
  }

  static Gradient statusColor({required String text}) {
    Gradient deaultGradient = AppColors.greyGradient;
    if (text != '') {
      switch (text) {
        case 'REQUESTED':
          deaultGradient = AppColors.yellowLineargradient;
          break;
        case 'ACCEPTED':
          deaultGradient = AppColors.deepOrandeLineargradient;
          break;
        case 'REJECTED':
          deaultGradient = AppColors.redLineargradient;
          break;
        case 'FINISHED':
          deaultGradient = AppColors.appGradient;
          break;
        default:
          deaultGradient;
      }
      return deaultGradient;
    }
    return deaultGradient;
  }

  static String statusString(
      {required String text, required BuildContext context}) {
    String deaultString = '';
    if (text != '') {
      switch (text) {
        case 'REQUESTED':
          deaultString = AppLocalizations.of(context).requested;
          break;
        case 'ACCEPTED':
          deaultString = AppLocalizations.of(context).accepted;
          break;
        case 'REJECTED':
          deaultString = AppLocalizations.of(context).rejected;
          break;
        case 'FINISHED':
          deaultString = AppLocalizations.of(context).finished;
          break;
        default:
          deaultString;
      }
      return deaultString;
    }
    return deaultString;
  }

  static String paymentStatusString(
      {required String text, required BuildContext context}) {
    String x = '';
    if (text != '') {
      switch (text) {
        case 'PAID':
          x = AppLocalizations.of(context).paid;
          break;
        case 'UNPAID':
          x = AppLocalizations.of(context).unpaid;
          break;
        default:
          x;
      }
      return x;
    }
    return x;
  }

  static String paymentStatusDetailsString(
      {required String text, required BuildContext context}) {
    String x = '';
    if (text != '') {
      switch (text) {
        case 'PAID':
          x = AppLocalizations.of(context).dpaid;
          break;
        case 'UNPAID':
          x = AppLocalizations.of(context).dUnPaid;
          break;
        default:
          x;
      }
      return x;
    }
    return x;
  }

  static String paymentMethodDetailsString(
      {required String text, required BuildContext context}) {
    String x = '';
    print(text);
    if (text != '') {
      switch (text) {
        case 'COD':
          x = AppLocalizations.of(context).cod;
          break;
        case 'CARD':
          x = AppLocalizations.of(context).card;
          break;
        default:
          x;
      }
      return x;
    }
    return x;
  }
}
