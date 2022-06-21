import 'package:flutter/material.dart';

class TermsConditionPage extends StatelessWidget {
  const TermsConditionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
      ),
      body: ListView(children: [
        Container(
          height: 200,
          //color: Colors.blue,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 100,
                    width: 100,
                    child: Image.asset("assets/images/aclogo.png")),
                SizedBox(
                  height: 20,
                ),
                Text("Can Do Today")
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
          child: Text(
              """ A long text Violate any local, state, federal and international laws and regulations 
                      Violate any copyright, trademark rights, patent rights, rights in know-how, privacy or publicity rights, trade secret rights, confidentiality rights, contract rights, or other rights of any individual or legal entity;
                      Are harmful; hateful; threatening; abusive; harassing; defamatory or libelous; tortious; sexually explicit, vulgar, lewd, obscene, or pornographic; racially, ethnically offensive; inappropriate; or inflammatory; or otherwise objectionable or offensive as solely determined in NCH’s discretion;
                      You know (or reasonably should know) are false, deceptive or misleading; including any in which you impersonate any person or entity or falsely misrepresent your affiliation with a person or entity;
                      Contain information that could be used for identity theft purposes, such as social security numbers, credit card, bank account or other financial information, driver’s license numbers, security codes or passwords;
                      Contain private or sensitive information about any other individual, such as information about that person’s sex life, political opinions, criminal charges or convictions, religious or philosophical beliefs, physical or mental health conditions, or other sensitive matters, without first obtaining that person’s express permission;
                      Contain the image, name, or likeness of anyone other than yourself, unless you have first obtained that individual’s express permission;
                      Contain unsolicited or unauthorized advertising (including advertising of non NCH services or products), promotional materials, “junk mail,” “spam,” “chain letters,” “pyramid schemes” or any other form of solicitation;
                      Transmit any material (by uploading, posting, email or otherwise) that contains software viruses, worms, disabling code, or any other computer code, files or programs designed to interrupt, destroy or limit the functionality of any computer software or hardware or telecommunications equipment;
                      Link to materials or other content, directly or indirectly, to which you do not have a right to link or that violates these restrictions'""
                                      overflow: TextOverflow.clip,""",textAlign: TextAlign.justify,),
        ),
      ]),
    );
  }
}
