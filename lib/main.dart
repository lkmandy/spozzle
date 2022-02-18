// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';
import 'bootstrap.dart';
import 'language_control/language.dart';

import 'language_control/language_control.dart';

void main() {
  bootstrap(() => BlocProvider<LanguageControlBloc>(
        create: (BuildContext context) => LanguageControlBloc(
          languages: Language.languageList(),
        ),
        child: const App(),
      ));
}
