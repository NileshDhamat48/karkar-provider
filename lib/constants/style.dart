import 'package:responsive_builder/responsive_builder.dart';

import 'all_imports.dart';

class Style {
  tStyle12(BuildContext context) {
    return getValueForScreenType(
      context: context,
      mobile: getValueForRefinedSize(
        context: context,
        normal: 22.0,
        large: 20.0,
        extraLarge: 20.0,
      ),
      tablet: getValueForRefinedSize(
        context: context,
        normal: 60.0,
        large: 60.0,
        extraLarge: 60.0,
      ),
      desktop: 16.0,
    );
  }

  tStyle13(BuildContext context) {
    return getValueForScreenType(
      context: context,
      mobile: getValueForRefinedSize(
        context: context,
        normal: 14.0,
        large: 20.0,
        extraLarge: 20.0,
      ),
      tablet: getValueForRefinedSize(
        context: context,
        normal: 100.0,
        large: 60.0,
        extraLarge: 60.0,
      ),
      desktop: 16.0,
    );
  }

  tStyle14(BuildContext context) {
    return getValueForScreenType(
      context: context,
      mobile: getValueForRefinedSize(
        context: context,
        normal: 16.0,
        large: 20.0,
        extraLarge: 20.0,
      ),
      tablet: getValueForRefinedSize(
        context: context,
        normal: 100.0,
        large: 60.0,
        extraLarge: 60.0,
      ),
      desktop: 16.0,
    );
  }

  tStyle15(BuildContext context) {
    return getValueForScreenType(
      context: context,
      mobile: getValueForRefinedSize(
        context: context,
        normal: 18.0,
        large: 20.0,
        extraLarge: 20.0,
      ),
      tablet: getValueForRefinedSize(
        context: context,
        normal: 100.0,
        large: 60.0,
        extraLarge: 60.0,
      ),
      desktop: 16.0,
    );
  }

  // htmlStyle(){
  //   return {
  //     'H1':Style(
  //       TextStyle()
  //     )
  //   }
  // }

}
