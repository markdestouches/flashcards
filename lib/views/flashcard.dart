import 'package:flashcards/models/flashcard_manager.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import 'package:flashcards/models/user_manager.dart';
import 'package:flashcards/views/styled_widgets.dart';
import 'package:flashcards/views/user.dart';
import 'package:flashcards/views/user_manager_view.dart';

import '../models/flashcard.dart';

String? validateInput(String? value) {
  if (value == null) {
    return "Enter at least 1 character";
  } else if (value.isEmpty) {
    return "Enter at least 1 character";
  } else if (value.length > 50) {
    return "Your input is too long";
  } else {
    return null;
  }
}

class AddFlashcardView extends StatefulWidget {
  const AddFlashcardView({super.key});

  @override
  State<AddFlashcardView> createState() => _AddFlashcardViewState();
}

class _AddFlashcardViewState extends State<AddFlashcardView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();
  final List<TextEditingController> _hiddenFieldControllers = [
    TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            autofocus: true,
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Visible"),
            validator: validateInput,
          ),
          TextFormField(
            autofocus: true,
            controller: _hintController,
            decoration: const InputDecoration(labelText: "Hint"),
            validator: validateInput,
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _hiddenFieldControllers.length,
            itemBuilder: ((context, index) {
              return TextFormField(
                controller: _hiddenFieldControllers[index],
                decoration: InputDecoration(labelText: "Hidden #$index"),
                validator: validateInput,
              );
            }),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _hiddenFieldControllers.add(TextEditingController());
              });
            },
          ),
          MainButtonStyle(
            onPressed: () {
              final flashcard = Flashcard(
                name: _nameController.text,
                hint: _hintController.text.isNotEmpty
                    ? _hintController.text
                    : null,
                hidden: _hiddenFieldControllers
                    .map(
                      (e) => e.text,
                    )
                    .toList(),
              );
              context.read<FlashcardManager>().add(flashcard);
            },
            child: const StyledText("Submit"),
          )
        ],
      ),
    );
  }
}
