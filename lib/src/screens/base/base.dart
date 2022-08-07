import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_view_model.dart';

class BaseStatefulView<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final T viewModel;
  final Widget? child;
  final Function(T model) onInit;

  const BaseStatefulView({
    Key? key,
    required this.builder,
    required this.viewModel,
    this.child,
    required this.onInit,
  }) : super(key: key);

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();

}

class _BaseViewState<T extends BaseViewModel> extends State<BaseStatefulView<T>> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T?>(
      create: (context) {
        widget.onInit(widget.viewModel);
        return widget.viewModel;
      },
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

class BaseStatelessView<T extends BaseViewModel> extends StatelessWidget {
  final Widget Function(BuildContext context, T model) builder;
  final T viewModel;

  const BaseStatelessView({
    Key? key,
    required this.builder,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context, viewModel);
  }
}