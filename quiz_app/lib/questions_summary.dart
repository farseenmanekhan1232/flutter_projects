import "package:flutter/material.dart";

import "package:google_fonts/google_fonts.dart";

class QuestionsSummary extends StatelessWidget {
  const QuestionsSummary(this.summaryData, {super.key});
  final List<Map<String, Object>> summaryData;

  @override
  Widget build(context) {
    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData.map(
            (data) {
              return Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: data['answer'] == data['user_answer']
                            ? Colors.green
                            : Colors.red,
                        border: Border.all(
                            color: const Color.fromARGB(255, 99, 46, 184)),
                      ),
                      child: Text(
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        ((data['question_index'] as int) + 1).toString(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(122, 108, 10, 189),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(data['question'] as String,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                const SizedBox(height: 15),
                                Text(data['answer'] as String,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      color:
                                          data['answer'] == data['user_answer']
                                              ? const Color.fromARGB(
                                                  255, 138, 255, 140)
                                              : Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                  data['user_answer'] as String,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                      fontSize: 15,
                                      color: const Color.fromARGB(
                                          255, 138, 255, 140),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
