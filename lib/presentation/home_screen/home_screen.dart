import 'package:ds250/presentation/home_screen/widgets/task_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ds250/core/app_export.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../model/device_data.dart';
import '../../services/database_service.dart';
import '../../services/stomp_service.dart';
import '../../widgets/custom_text_form_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  TextEditingController _searchQuery = TextEditingController();
  GlobalKey<TaskListState> taskListKey = GlobalKey<TaskListState>();
  GlobalKey<TaskListState> taskListTomorrowKey = GlobalKey<TaskListState>();
  final FocusNode _focusNode = FocusNode(); // Cria um FocusNode
  int totalTasks = 0;
  int completedTasks = 0;
  double completionPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    initializeApp();
    fetchdata();
  }

  Future<void> fetchdata() async {
    // Busca os dados no banco
    final results = await DatabaseHelper.instance.fetchTasks(date: DateTime.now().toString());
    totalTasks = results.length;

    completedTasks = 0;
    
    for (var task in results) {
      if (task['concluido'] == 1) {
        completedTasks++;
      }
    }

    if (totalTasks > 0) {
      completionPercentage = (completedTasks / totalTasks);
    }
    setState(() {});
  }


  Future<void> initializeApp() async {
    await DatabaseHelper.instance.createTaskTable();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            floatingActionButton: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(2000),
                onTap: () async {
                  final result = await onNavigate(context, AppRoutes.taskScreen);
                  if(result != null){
                    taskListKey.currentState?.fetchdata();
                    taskListTomorrowKey.currentState?.fetchdata();
                    fetchdata();
                  }
                },
                child: Ink(
                  height: 70.w,
                  width: 70.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // circular shape
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 26, 255),
                        Color.fromARGB(255, 131, 162, 222)
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 30.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            key: _scaffoldKey,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Você tem 5 tarefas para\n',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'completar hoje',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: CustomImageView(
                                          imagePath: ImageConstant.imgPencilIcon,
                                          height: 20.h,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgNoProfilePic,
                          height: 50.h,
                          width: 50.h,
                          fit: BoxFit.cover,
                          radius: BorderRadius.circular(100),
                        )
                      ],
                    ),
                    SizedBox(height: 15,),
                    // SizedBox(
                    //   height: 40,
                    //   child: TextField(
                    //     controller: nomeController,
                    //     onSubmitted: (value) {
                    //       taskListKey.currentState?.fetchdata(busca: value);
                    //       taskListTomorrowKey.currentState?.fetchdata(busca: value);
                    //     },
                    //     decoration: InputDecoration(
                    //       hintText: "Pesquise as tarefas aqui",
                    //       filled: true,
                    //       fillColor: Color.fromARGB(255, 30, 30, 30),
                    //       border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(10)
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //         borderSide: BorderSide(
                    //           color: Color.fromARGB(255, 33, 84, 161),
                    //           width: 1,
                    //         ),
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(10)
                    //       ),
                    //       prefix: IconButton(
                    //         onPressed: (){},
                    //         icon: Icon(
                    //           Icons.search,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //       hintStyle: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.w300),
                    //       contentPadding: EdgeInsets.only(
                    //           top: 12.h,
                    //           right: 10.w,
                    //           left: 10.w,
                    //           bottom: 12.h
                    //       ),
                    //       prefixIconConstraints: BoxConstraints(maxHeight: 10.h),
                    //     ),
                    //     style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w400),
                    //   ),
                    // ),
                    _searchTextField(),
                    SizedBox(height: 10,),
                    Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Progresso",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                ),
                              ),
                              SizedBox(height: 10,),
                              _buildProgressContainer(),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tarefas de hoje",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  TextButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.2)),
                                      ),
                                      onPressed: () async {
                                        final result = await onNavigate(context, AppRoutes.taskListScreen, arguments: {"data": DateTime.now().toString()});
                                        if(result != null){
                                          taskListKey.currentState?.fetchdata();
                                          taskListTomorrowKey.currentState?.fetchdata();
                                          fetchdata();
                                        }
                                      },
                                      child: Text(
                                        "Ver todas",
                                        style: TextStyle(
                                            color: Colors.blue
                                        ),
                                      )
                                  )
                                ],
                              ),
                              TaskList(key: taskListKey, limit: 3, data: DateTime.now().toString(), onCompleted: onTaskCompleted),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tarefas de amanhã",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  TextButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.2)),
                                      ),
                                      onPressed: () async {
                                        final result = await onNavigate(context, AppRoutes.taskListScreen, arguments: {"data": DateTime.now().add(Duration(days: 1)).toString()});
                                        if(result != null){
                                          taskListKey.currentState?.fetchdata();
                                          taskListTomorrowKey.currentState?.fetchdata();
                                          fetchdata();
                                        }
                                      },
                                      child: Text(
                                        "Ver todas",
                                        style: TextStyle(
                                            color: Colors.blue
                                        ),
                                      )
                                  )
                                ],
                              ),
                              TaskList(key: taskListTomorrowKey, limit: 3, data: DateTime.now().add(Duration(days: 1)).toString(), onCompleted: onTaskCompleted),
                              SizedBox(height: 100,)
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }

  void onTaskCompleted() {
    print("Tarefa concluída!");
    fetchdata();
    setState(() {});
  }

  Widget _searchTextField() {
    return SizedBox(
      height: 60, // Altura desejada do TextField
      child: TextField(
        focusNode: _focusNode,
        cursorColor:  Color.fromARGB(255, 220, 220, 220),
        style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w400),
        controller: _searchQuery,
        onSubmitted: (String searchTerm) {
          setState(() {
            _searchQuery.text = searchTerm;
            taskListKey.currentState?.fetchdata(busca: searchTerm);
            taskListTomorrowKey.currentState?.fetchdata(busca: searchTerm);
          });
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, size: 20, color: Colors.white),
          suffixIcon: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
              onTap: () {
                setState(() {
                  _searchQuery.text = "";
                  taskListKey.currentState?.fetchdata();
                  taskListTomorrowKey.currentState?.fetchdata();
                });
              },
              child: Icon(
                Icons.clear,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          isDense: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 33, 84, 161),
              width: 1,
            ),
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 32, 32, 32),
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
          hintText: 'Digite o que deseja buscar...',
          hintStyle: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildProgressContainer() {
    print(totalTasks);
    String message = "Você consegue, vamos lá!";
    String percent = (completionPercentage * 100).toStringAsFixed(2);
    if((completionPercentage * 100 ).toInt() > 60){
      message = "Você está quase terminando, vá em frente!";
    }
    if((completionPercentage * 100).toInt() == 100){
      message = "Você terminou, parabéns!";
    }
    return Container(
      width: 1000.h,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 28, 28, 28),
          borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tarefas Diárias",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: 5,),
          Text(
            "$completedTasks/$totalTasks Tarefas Completadas",
            style: TextStyle(
                color: Color.fromARGB(255, 190, 190, 190),
                fontSize: 14.sp,
                fontWeight: FontWeight.w300
            ),
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${message}",
                style: TextStyle(
                    color: Color.fromARGB(255, 190, 190, 190),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w200
                ),
              ),
              Text(
                "${percent}%",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
          SizedBox(height: 5,),
          LinearPercentIndicator(
            animation: true,
            lineHeight: 20.0,
            padding: EdgeInsets.zero,
            animationDuration: 1000,
            percent: completionPercentage,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Color.fromARGB(255, 33, 84, 161),
            barRadius: Radius.circular(10.0),
          ),
        ],
      ),
    );
  }
}
