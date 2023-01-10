import 'package:flashcards/models/user.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flashcards/views/styled_widgets.dart';

import '../models/flashcard.dart';

String? validateCharLimit(String? value, int upperLimit, [int lowerLimit = 1]) {
  if (lowerLimit > upperLimit || upperLimit < 1) {
    throw "Invalid input limits set for input validation";
  }
  final String lowerLimitString = lowerLimit == 1 ? "character" : "characters";
  final String upperLimitString = upperLimit == 1 ? "character" : "characters";
  if (value == null) {
    return "Enter at least $lowerLimit $lowerLimitString";
  } else if (value.length < lowerLimit) {
    return "Enter at least $lowerLimit $lowerLimitString";
  } else if (value.length > upperLimit) {
    return "Your input must not exceed $upperLimit $upperLimitString";
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();
  final List<TextEditingController> _hiddenFieldControllers = [
    TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: StyledButton(
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
                  validator: (value) => validateCharLimit(value, 25),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  autofocus: true,
                  controller: _hintController,
                  decoration: const InputDecoration(labelText: "Hint"),
                  validator: (value) => validateCharLimit(value, 75, 0),
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
                      validator: (value) => validateCharLimit(value, 25),
                    );
                  }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    splashRadius: 15.0,
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _hiddenFieldControllers.add(TextEditingController());
                      });
                    },
                  ),
                  _hiddenFieldControllers.length > 1
                      ? IconButton(
                          splashRadius: 15.0,
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              _hiddenFieldControllers.removeLast();
                            });
                          },
                        )
                      : Container(),
                ],
              ),
              StyledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
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
                  }
                },
                child: const StyledText("Submit"),
              )
            ],
          ),
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
  bool isHintShown = false;

  @override
  Widget build(BuildContext context) {
    final controllers = List<TextEditingController>.generate(
        widget.flashcard.hidden.length, (_) => TextEditingController());
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: isHintShown
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      child: const StyledText("Back"),
                    ),
                  ),
                ),
              ),
              StyledText(
                widget.flashcard.name,
              ),
              widget.flashcard.hint != null
                  ? isHintShown
                      ? Text("Hint: ${widget.flashcard.hint!}",
                          style: const TextStyle(fontSize: 16))
                      : StyledButton(
                          onPressed: () {
                            setState(
                              () {
                                isHintShown = true;
                              },
                            );
                          },
                          child: const StyledText('Show Hint'))
                  : Container(),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: controllers.length,
                itemBuilder: ((context, index) {
                  return TextFormField(
                    controller: controllers[index],
                    decoration:
                        InputDecoration(labelText: "Hidden #${index + 1}"),
                    validator: (value) => validateCharLimit(value, 25),
                  );
                }),
              ),
              StyledButton(
                onPressed: () {
                  final FlashcardGuess flashcardGuess = FlashcardGuess(
                    flashcard: widget.flashcard,
                    guessFields: controllers.map((e) => e.text).toList(),
                    isHintShown: isHintShown,
                  );
                  final result =
                      context.read<User>().checkFlashcardGuess(flashcardGuess);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: StyledText(
                              result == true ? "Correct" : "Incorrect"),
                          actions: [
                            ElevatedButton(
                              autofocus: true,
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const StyledText("ok"),
                            ),
                          ]);
                    },
                  );
                },
                child: const StyledText("Check"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlashcardView extends StatelessWidget {
  const FlashcardView({
    Key? key,
    required this.buttonBackgroundColor,
    required this.flashcard,
    required this.currentTime,
  }) : super(key: key);

  final Color? buttonBackgroundColor;
  final Flashcard flashcard;
  final DateTime currentTime;

  @override
  Widget build(BuildContext context) {
    final flashcardAlertState = flashcard.getAlertState(currentTime);
    final Color textColor =
        flashcardAlertState == FlashcardAlertState.reviewLocked ||
                buttonBackgroundColor!.computeLuminance() > 0.5
            ? Colors.black
            : Colors.white;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0.0,
          backgroundColor: buttonBackgroundColor,
          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
      onPressed: flashcardAlertState == FlashcardAlertState.reviewLocked
          ? null
          : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) {
                    return CheckFlashcardView(
                      flashcard: flashcard,
                    );
                  }),
                ),
              );
            },
      child: ListTile(
        leading: flashcardAlertState == FlashcardAlertState.triggered
            ? Icon(Icons.warning, color: textColor)
            : const SizedBox(width: 0, height: 0),
        title: Text(
          flashcard.name,
          style: TextStyle(
            color: textColor,
          ),
        ),
        subtitle: Text(
          "Review ${flashcard.getFormattedTimeTillALert(currentTime)}",
          style: TextStyle(
              color: textColor, fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class DebugFlashcardView extends StatelessWidget {
  const DebugFlashcardView({
    Key? key,
    required this.card,
    required this.index,
  }) : super(key: key);

  final Flashcard card;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.lightBlue[(index + 1) * 50],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const StyledText("name: "),
              card.hint != null ? const StyledText("hint: ") : Container(),
              Column(
                children: card.hidden
                    .mapIndexed(
                      (i, e) => StyledText("hidden field #${i + 1}: "),
                    )
                    .toList(),
              ),
              const StyledText("created: "),
              const StyledText("due: "),
              const StyledText("next alert in: "),
              const StyledText("id: "),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              StyledText(card.name),
              card.hint != null ? StyledText(card.hint!) : Container(),
              Column(
                children: card.hidden
                    .map(
                      (e) => StyledText(e),
                    )
                    .toList(),
              ),
              StyledText(card.created.toString()),
              StyledText(card.alertTime.toString()),
              StyledText(card.alertTime.difference(card.created).toString()),
            ]),
          ],
        ),
      ),
    );
  }
}
