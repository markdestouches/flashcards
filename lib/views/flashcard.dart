import 'package:flashcards/models/user.dart';
import 'package:flutter/material.dart';
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
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: MainButtonStyle(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const StyledText("Back"),
              ),
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                autofocus: true,
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Visible"),
                validator: validateInput,
              ),
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                autofocus: true,
                controller: _hintController,
                decoration: const InputDecoration(labelText: "Hint"),
                validator: validateInput,
              ),
            ),
            SizedBox(
              width: 300,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _hiddenFieldControllers.length,
                itemBuilder: ((context, index) {
                  return TextFormField(
                    controller: _hiddenFieldControllers[index],
                    decoration:
                        InputDecoration(labelText: "Hidden #${index + 1}"),
                    validator: validateInput,
                  );
                }),
              ),
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
                context.read<User>().addFlashcard(flashcard);
                Navigator.of(context).pop();
              },
              child: const StyledText("Submit"),
            )
          ],
        ),
      ),
    );
  }
}

class CheckFlashcardView extends StatefulWidget {
  final Flashcard flashcard;
  const CheckFlashcardView({super.key, required this.flashcard});

  @override
  State<CheckFlashcardView> createState() => _CheckFlashcardViewState();
}

class _CheckFlashcardViewState extends State<CheckFlashcardView> {
  bool isHintDisplayed = false;

  @override
  Widget build(BuildContext context) {
    final controllers = List<TextEditingController>.generate(
        widget.flashcard.hidden.length, (_) => TextEditingController());
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: MainButtonStyle(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const StyledText("Back"),
              ),
            ),
            SizedBox(
              width: 300,
              child: StyledText("Check flashcard: ${widget.flashcard.name}"),
            ),
            widget.flashcard.hint != null
                ? isHintDisplayed
                    ? StyledText(widget.flashcard.hint!)
                    : MainButtonStyle(
                        onPressed: () {
                          setState(
                            () {
                              isHintDisplayed = true;
                            },
                          );
                        },
                        child: const StyledText('Show hint'))
                : Container(),
            SizedBox(
              width: 300,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: controllers.length,
                itemBuilder: ((context, index) {
                  return TextFormField(
                    controller: controllers[index],
                    decoration:
                        InputDecoration(labelText: "Hidden #${index + 1}"),
                    validator: validateInput,
                  );
                }),
              ),
            ),
            MainButtonStyle(
              onPressed: () {
                final result = context.read<User>().checkFlashcardGuess(
                    widget.flashcard,
                    controllers
                        .map(
                          (e) => e.text,
                        )
                        .toList());
                AlertDialog(
                  title: StyledText(result == true ? "Correct" : "Incorrect"),
                );
                Navigator.of(context).pop();
              },
              child: const StyledText("Check"),
            ),
          ],
        ),
      ),
    );
  }
}
