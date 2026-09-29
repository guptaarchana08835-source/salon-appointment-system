import 'package:flutter/material.dart';

void main() {
  runApp(const SalonApp());
}

class SalonApp extends StatelessWidget {
  const SalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Glow & Grace",
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xffFFF5F7),
      ),
      home: const MainPage(),
    );
  }
}

// COMMON

InputDecoration input(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: const Color(0xffC95B78)),
    filled: true,
    fillColor: const Color(0xffFFF8FA),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
  );
}

ButtonStyle buttonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: const Color(0xffC95B78),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
  );
}

AppBar myAppBar(String title) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    backgroundColor: const Color(0xffC95B78),
    foregroundColor: Colors.white,
  );
}

Widget background({required Widget child}) {
  return Stack(
    children: [
      Image.network(
        "https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=1400&q=80",
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Container(
        color: const Color(0xffFFF5F7).withOpacity(.94),
      ),
      child,
    ],
  );
}

// MAIN PAGE

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int page = 0;
  // DSA: LIST
  List<Map<String, String>> appointments = [];
  // DSA: STACK
  List<Map<String, String>> cancelled = [];
  // DSA: LIST
  List<Map<String, dynamic>> feedbackList = [];

  void addAppointment(Map<String, String> appointment) {
    setState(() {
      appointments.add(appointment);
    });
  }

  void cancelAppointment(int index) {
    setState(() {
      cancelled.add(appointments[index]);
      appointments.removeAt(index);
    });
  }

  void undoCancel() {
    if (cancelled.isNotEmpty) {
      setState(() {
        appointments.add(cancelled.removeLast());
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Last cancelled appointment restored ✨"),
        ),
      );
    }
  }

  // DSA: SORTING
  void sortAppointments() {
    setState(() {
      appointments.sort((a, b) {
        return a["dateKey"]!.compareTo(b["dateKey"]!);
      });
    });
  }

  void addFeedback(Map<String, dynamic> feedback) {
    setState(() {
      feedbackList.add(feedback);
    });
  }

  // DSA: SORTING
  void sortFeedback() {
    setState(() {
      feedbackList.sort(
            (a, b) => b["rating"].compareTo(a["rating"]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        count: appointments.length,
        book: () {
          setState(() {
            page = 1;
          });
        },
      ),
      BookingPage(
        appointments: appointments,
        onBook: addAppointment,
      ),
      BookingsPage(
        appointments: appointments,
        cancelled: cancelled,
        cancel: cancelAppointment,
        undo: undoCancel,
        sort: sortAppointments,
      ),
      FeedbackPage(
        feedbackList: feedbackList,
        addFeedback: addFeedback,
        sortFeedback: sortFeedback,
      ),

      const AboutPage(),
    ];

    return Scaffold(
      body: pages[page],

      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        indicatorColor: Color(0xffFFD8E2),

        onDestinationSelected: (value) {
          setState(() {
            page = value;
          });
        },

        destinations:  [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: "Book",
          ),
          NavigationDestination(
            icon: Icon(Icons.book_online),
            label: "Bookings",
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            label: "Feedback",
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            label: "About",
          ),
        ],
      ),
    );
  }
}

// HOME
class HomePage extends StatelessWidget {
  final int count;
  final VoidCallback book;

  HomePage({
    super.key,
    required this.count,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> services = [
      {
        "name": "Hair Styling",
        "price": "₹500",
        "image":
        "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?auto=format&fit=crop&w=500&q=80"
      },
      {
        "name": "Facial",
        "price": "₹1000",
        "image":
        "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?auto=format&fit=crop&w=500&q=80"
      },
      {
        "name": "Makeup",
        "price": "₹2000",
        "image":
        "https://images.unsplash.com/photo-1487412912498-0447578fcca8?auto=format&fit=crop&w=500&q=80"
      },
      {
        "name": "Spa",
        "price": "₹1500",
        "image":
        "https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=500&q=80"
      },
    ];

    return Scaffold(
      body: background(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE
              Stack(
                children: [
                  Image.network(
                    "https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=1000&q=80",
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 190,
                    color: Colors.black.withOpacity(.4),
                  ),
                  Positioned(
                    left: 25,
                    bottom: 25,
                    child: Text(
                      "Welcome to Glow & Grace ✨\nYour beauty journey starts here 💕",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // TOTAL BOOKINGS
              Container(
                margin: const EdgeInsets.all(18),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffC95B78),
                      Color(0xffE99AAF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                      size: 35,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      "$count Total Appointments Booked",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              heading("Special Offers 🎁"),
              SizedBox(
                height: 125,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  children: const [
                    Offer(
                      icon: Icons.card_giftcard,
                      title: "20% OFF",
                      subtitle: "First Visit",
                    ),
                    Offer(
                      icon: Icons.spa,
                      title: "₹300 OFF",
                      subtitle: "Spa Treatment",
                    ),
                    Offer(
                      icon: Icons.auto_awesome,
                      title: "COMBO",
                      subtitle: "Hair + Facial",
                    ),
                  ],
                ),
              ),

              heading("Our Services 💅"),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: services.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 185,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            services[index]["image"]!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            services[index]["name"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          services[index]["price"]!,
                          style: const TextStyle(
                            color: Color(0xffC95B78),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: buttonStyle(),
                    onPressed: book,
                    child: const Text(
                      "BOOK APPOINTMENT ✨",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget heading(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 15, 18, 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// OFFER

class Offer extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const Offer({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xffFFDCE5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xffC95B78),
            size: 30,
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xffC95B78),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(subtitle),
        ],
      ),
    );
  }
}

//  BOOK APPOINTMENT

class BookingPage extends StatefulWidget {
  final List<Map<String, String>> appointments;
  final Function(Map<String, String>) onBook;

  const BookingPage({
    super.key,
    required this.appointments,
    required this.onBook,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final name = TextEditingController();
  final time = TextEditingController();

  String service = "Hair Styling";
  DateTime? selectedDate;

  List<String> services = [
    "Hair Styling",
    "Facial",
    "Makeup",
    "Spa",
    "Hair + Facial Combo",
  ];

  void message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: const Color(0xffC95B78),
      ),
    );
  }
  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void bookAppointment() {
    if (name.text.trim().isEmpty) {
      message("Please enter customer name");
      return;
    }
    if (selectedDate == null || time.text.trim().isEmpty) {
      message("Please select date and enter time");
      return;
    }
    // DSA: LINEAR SEARCH
    // Count bookings of same customer
    int customerAppointments = 0;
    for (var appointment in widget.appointments) {
      if (appointment["name"]!.toLowerCase() ==
          name.text.trim().toLowerCase()) {
        customerAppointments++;
      }
    }
    // MAXIMUM 2 APPOINTMENTS PER CUSTOMER
    if (customerAppointments >= 2) {
      message("This customer already has 2 appointments! ❌");
      return;
    }
    String dateKey =
        "${selectedDate!.year.toString().padLeft(4, "0")}-"
        "${selectedDate!.month.toString().padLeft(2, "0")}-"
        "${selectedDate!.day.toString().padLeft(2, "0")}";

    String displayDate =
        "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Appointment ✨"),
          content: Text(
            "Customer: ${name.text}\n\n"
                "Service: $service\n\n"
                "Date: $displayDate\n\n"
                "Time: ${time.text.trim()}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("EDIT"),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onBook({
                  "name": name.text.trim(),
                  "service": service,
                  "date": displayDate,
                  "time": time.text.trim(),
                  "dateKey": dateKey,
                });

                Navigator.pop(context);

                message("Appointment Booked Successfully! 🎉");

                setState(() {
                  name.clear();
                  time.clear();
                  selectedDate = null;
                });
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String dateText = selectedDate == null
        ? "Select Date"
        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

    return Scaffold(
      appBar: myAppBar("Book Appointment"),
      body: background(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.93),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.spa,
                    size: 60,
                    color: Color(0xffC95B78),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Book Your Appointment ✨",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),

                  TextField(
                    controller: name,
                    decoration: input(
                      "Customer Name",
                      Icons.person,
                    ),
                  ),

                  const SizedBox(height: 18),

                  DropdownButtonFormField<String>(
                    value: service,
                    decoration: input(
                      "Select Service",
                      Icons.spa,
                    ),
                    items: services.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        service = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  ListTile(
                    tileColor: const Color(0xffFFF0F4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Color(0xffC95B78),
                    ),
                    title: Text(dateText),
                    onTap: pickDate,
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: time,
                    decoration: input(
                      "Enter Time (Example: 10:30 AM)",
                      Icons.access_time,
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: buttonStyle(),
                      onPressed: bookAppointment,
                      child: const Text(
                        "CONFIRM BOOKING ✨",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// MY BOOKINGS

class BookingsPage extends StatefulWidget {
  final List<Map<String, String>> appointments;
  final List<Map<String, String>> cancelled;
  final Function(int) cancel;
  final VoidCallback undo;
  final VoidCallback sort;

  const BookingsPage({
    super.key,
    required this.appointments,
    required this.cancelled,
    required this.cancel,
    required this.undo,
    required this.sort,
  });

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> result = [];

    // DSA: LINEAR SEARCH
    for (var appointment in widget.appointments) {
      if (appointment["service"]!
          .toLowerCase()
          .contains(search.toLowerCase()) ||
          appointment["name"]!
              .toLowerCase()
              .contains(search.toLowerCase())) {
        result.add(appointment);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Bookings"),
        centerTitle: true,
        backgroundColor: const Color(0xffC95B78),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              widget.sort();
              setState(() {});
            },
          ),
        ],
      ),
      body: background(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                decoration: input(
                  "Search customer or service",
                  Icons.search,
                ),
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
              ),
            ),

            if (widget.cancelled.isNotEmpty)
              TextButton.icon(
                icon: const Icon(Icons.undo),
                label: const Text(
                  "Undo Last Cancelled Appointment",
                ),
                onPressed: widget.undo,
              ),

            Expanded(
              child: result.isEmpty
                  ? const Center(
                child: Text(
                  "No Appointments Yet ✨",
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  var appointment = result[index];

                  int originalIndex =
                  widget.appointments.indexOf(appointment);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 7,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xffFFDCE5),
                        child: Icon(
                          Icons.person,
                          color: Color(0xffC95B78),
                        ),
                      ),
                      title: Text(
                        appointment["name"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${appointment["service"]}\n"
                            "📅 ${appointment["date"]}  |  "
                            "🕒 ${appointment["time"]}",
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          widget.cancel(originalIndex);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Appointment Cancelled",
                              ),
                            ),
                          );

                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  FEEDBACK PAGE

class FeedbackPage extends StatefulWidget {
  final List<Map<String, dynamic>> feedbackList;
  final Function(Map<String, dynamic>) addFeedback;
  final VoidCallback sortFeedback;

  const FeedbackPage({
    super.key,
    required this.feedbackList,
    required this.addFeedback,
    required this.sortFeedback,
  });

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int rating = 0;

  final name = TextEditingController();
  final feedback = TextEditingController();

  void submit() {
    if (name.text.trim().isEmpty ||
        rating == 0 ||
        feedback.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all feedback details"),
        ),
      );
      return;
    }

    // DSA: LIST
    widget.addFeedback({
      "name": name.text.trim(),
      "rating": rating,
      "feedback": feedback.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Feedback submitted successfully! 💕"),
      ),
    );

    setState(() {
      name.clear();
      feedback.clear();
      rating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("Feedback"),
      body: background(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // FEEDBACK FORM
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.94),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.favorite,
                      size: 60,
                      color: Color(0xffC95B78),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Share Your Experience 💕",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: name,
                      decoration: input(
                        "Your Name",
                        Icons.person,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text("Rate Our Service"),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 35,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = index + 1;
                            });
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: feedback,
                      maxLines: 4,
                      decoration: input(
                        "Write your feedback...",
                        Icons.edit,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: buttonStyle(),
                        onPressed: submit,
                        child: const Text(
                          "SUBMIT FEEDBACK 💕",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              // FEEDBACK TITLE +  DSA SORT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Customer Feedback 💬",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffC95B78),
                    ),
                    onPressed: () {
                      widget.sortFeedback();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.sort,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Sort",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              if (widget.feedbackList.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "No feedback submitted yet 💕",
                    style: TextStyle(fontSize: 16),
                  ),
                ),

              // DISPLAY FEEDBACK
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.feedbackList.length,
                itemBuilder: (context, index) {
                  var item = widget.feedbackList[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xffFFDCE5),
                        child: Text(
                          "${item["rating"]}⭐",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      title: Text(
                        item["name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${item["feedback"]}\n"
                            "Rating: ${item["rating"]}/5 ⭐",
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  ABOUT PAGE

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("About Us"),
      body: background(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const Icon(
                Icons.spa,
                size: 80,
                color: Color(0xffC95B78),
              ),

              const Text(
                "Glow & Grace Salon",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Beauty • Care • Confidence ✨",
                style: TextStyle(
                  color: Color(0xffC95B78),
                ),
              ),

              const SizedBox(height: 25),

              aboutCard(
                Icons.favorite,
                "Who We Are",
                "Glow & Grace is a modern beauty and wellness salon focused on helping every customer look and feel confident.",
              ),

              aboutCard(
                Icons.auto_awesome,
                "Our Mission",
                "Our mission is to make salon appointment booking simple, convenient and stress-free for everyone.",
              ),

              aboutCard(
                Icons.spa,
                "Our Services",
                "We provide hair styling, facials, makeup, spa treatments and exciting combo packages.",
              ),

              aboutCard(
                Icons.phone,
                "Contact Us",
                "Mumbai, Maharashtra\n+91 98765 43210\nOpen Daily: 10 AM - 8 PM",
              ),

              const SizedBox(height: 20),

              const Text(
                "✨ Your beauty journey begins here ✨",
                style: TextStyle(
                  color: Color(0xffC95B78),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget aboutCard(
      IconData icon,
      String title,
      String description,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xffFFDCE5),
              child: Icon(
                icon,
                color: const Color(0xffC95B78),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      height: 1.4,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}