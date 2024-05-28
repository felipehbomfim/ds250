import 'package:ds250/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../services/database_service.dart';

class TaskList extends StatefulWidget {
  final String? data;
  final int? limit;
  final VoidCallback onCompleted;

  const TaskList({Key? key, this.data, this.limit, required this.onCompleted}) : super(key: key);

  @override
  State<TaskList> createState() => TaskListState();
}

class TaskListState extends State<TaskList> {
  dynamic tasks = [];
  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata({String? busca}) async {
    tasks = await DatabaseHelper.instance.fetchTasks(date: widget.data, limit: widget.limit, busca: busca);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return tasks.length > 0 ? ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _buildTripItem(context, index);
      },
    ) : _notFound();
  }

  String getMonthName(String dateString) {
    initializeDateFormatting('pt_BR', null);
    DateTime parsedDate = DateTime.parse(dateString);
    DateFormat formatter = DateFormat.MMMM('pt_BR');
    String month = formatter.format(parsedDate);
    return '${month[0].toUpperCase()}${month.substring(1, 3).toLowerCase()}';
  }

  /// Section Widget
  Widget _buildTripItem(BuildContext context, int index) {
    dynamic task = tasks[index];
    DateTime parsedDate = DateTime.parse(task['data']);
    String monthName = getMonthName(task['data']);
    Color color = Colors.red;
    if(task['prioridade'] == "Média")
      color = Colors.orange;
    else if(task['prioridade'] == "Baixa")
      color = Colors.green;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Material(
        child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              final result = await onNavigate(context, AppRoutes.taskScreen, arguments: {"task": task});
              if(result != null){
                widget.onCompleted();
                fetchdata();
              }
            },
            child: Ink(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 30, 30, 30),
                  borderRadius: BorderRadius.circular(10)
              ),
              height: 60.h,
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                      color: color,
                    ),
                    width: 15.w,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(task['nome'], maxLines: 1, style: TextStyle(fontSize: 14.sp, overflow: TextOverflow.ellipsis),),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.calendarIcon,
                              width: 14.w,
                            ),
                            SizedBox(width: 5,),
                            Text('${parsedDate.day} $monthName', style: TextStyle(color: Colors.grey, fontSize: 14.sp))
                          ],
                        )
                      ],
                    ),
                  ),
                  if(task['concluido'] == 0)
                    IconButton(
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                icon: 'info',
                                title: 'Atenção!',
                                cancelButtonText: "Cancelar",
                                confirmButtonText: "OK, entendi",
                                message: "Tem certeza que deseja concluir a tarefa?",
                                onOkPressed: () async {
                                  await DatabaseHelper.instance.updateTaskAsCompleted(task['id']);
                                  fetchdata();
                                  toastification.show(
                                    style: ToastificationStyle.fillColored,
                                    type: ToastificationType.success,
                                    context: context,
                                    showProgressBar: true,
                                    autoCloseDuration: Duration(seconds: 4),
                                    title: Text('Sucesso!'),
                                    description: RichText(text: const TextSpan(text: 'A tarefa foi concluída com sucesso!')),
                                  );

                                  widget.onCompleted();
                                  Navigator.of(context).pop(); // Fecha o dialog
                                },
                                onCancelPressed: () {
                                  Navigator.of(context).pop(); // Fecha o dialog
                                },
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.circle_outlined,color: Colors.blue,
                          size: 25.w,
                        )
                    )
                  else
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.check_circle,color: Colors.blue,
                          size: 25.w,
                        )
                    ),
                  SizedBox(width: 20,)
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget _notFound() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 60.h,  // Ajustado para melhor visualização
          color: Color.fromARGB(255, 45, 45, 45),  // Cor ligeiramente mais clara para variar do fundo
          child: Row(
            children: <Widget>[
              Container(
                color: Colors.redAccent,  // Cor de destaque para chamar a atenção
                width: 5.w,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Oops! Parece que não há nada por aqui!',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white70),  // Cor do texto ajustada para contraste
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

