import 'package:flutter/material.dart';

class LSListView extends StatelessWidget {
    final List<Widget> children;
    final EdgeInsetsGeometry customPadding;
    final ScrollController controller;

    LSListView({
        @required this.children,
        this.controller,
        this.customPadding = const EdgeInsets.symmetric(vertical: 8.0),
    });

    @override
    Widget build(BuildContext context) => Scrollbar(
        controller: controller == null ? ScrollController() : controller,
        child: ListView(
            controller: controller,
            children: children,
            padding: customPadding,
            physics: AlwaysScrollableScrollPhysics(),
        ),
    );
}
